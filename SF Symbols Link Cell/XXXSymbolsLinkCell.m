#import "XXXSymbolsLinkCell.h"

@implementation UIColor (SymbolsLinkCell)

+ (UIColor *)systemColorFromString:(NSString *)stringColor {
    if ([stringColor containsString:@"blue"]) {
        return [UIColor systemBlueColor];
    } else if ([stringColor containsString:@"green"]) {
        return [UIColor systemGreenColor];
    } else if ([stringColor containsString:@"indigo"]) {
        return [UIColor systemIndigoColor];
    } else if ([stringColor containsString:@"orange"]) {
        return [UIColor systemOrangeColor];
    } else if ([stringColor containsString:@"pink"]) {
        return [UIColor systemPinkColor];
    } else if ([stringColor containsString:@"purple"]) {
        return [UIColor systemPurpleColor];
    } else if ([stringColor containsString:@"red"]) {
        return [UIColor systemRedColor];
    } else if ([stringColor containsString:@"teal"]) {
        return [UIColor systemTealColor];
    } else if ([stringColor containsString:@"yellow"]) {
        return [UIColor systemYellowColor];
    } else if ([stringColor containsString:@"gray2"]) {
        return [UIColor systemGray2Color];
    } else if ([stringColor containsString:@"gray3"]) {
        return [UIColor systemGray3Color];
    } else if ([stringColor containsString:@"gray4"]) {
        return [UIColor systemGray4Color];
    } else if ([stringColor containsString:@"gray5"]) {
        return [UIColor systemGray5Color];
    } else if ([stringColor containsString:@"gray6"]) {
        return [UIColor systemGray6Color];
    } else if ([stringColor containsString:@"gray"]) {
        return [UIColor systemGrayColor];
    }
    return nil;
}

// https://stackoverflow.com/a/12397366/12070367
+ (UIColor *)colorFromHexString:(NSString *)hex {
    hex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSCharacterSet *hexChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"] invertedSet];
    if ([[hex uppercaseString] rangeOfCharacterFromSet:hexChars].location != NSNotFound) {
        NSLog(@"[%@] Argument is not a valid hexadecimal color, returning", NSStringFromSelector(_cmd));
        return nil;
    }

    unsigned intValue = 0;
    [[NSScanner scannerWithString:hex] scanHexInt:&intValue];
    return [UIColor colorWithRed:((intValue & 0xFF0000) >> 16) / 255.0
                           green:((intValue & 0xFF00) >> 8) / 255.0
                            blue:(intValue & 0xFF) / 255.0
                           alpha:1.0];
}

@end

@implementation XXXSymbolsLinkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier]) {
        if (@available(iOS 13.0, *)) {
            // Checking availability and presence of icon property
            if (!specifier.properties[@"icon"]) {
                NSLog(@"[%@ %p] No icon found, falling back to default behavior", NSStringFromClass(self.class), self);
                return self;
            }
            
            // Applying SF Symbol
            if ((self.symbolsImage = [UIImage systemImageNamed:specifier.properties[@"icon"]])) {
                NSLog(@"[%@ %p] Applied SF Symbol: %@", NSStringFromClass(self.class), self, specifier.properties[@"icon"]);
            } else {
                NSLog(@"[%@ %p] SF Symbol \"%@\" not found, falling back to default behavior", NSStringFromClass(self.class), self, specifier.properties[@"icon"]);
                return self;
            }

            CGFloat pointSize = specifier.properties[@"size"] ? [specifier.properties[@"size"] floatValue] : 29.f;

            // Setting custom weight if requested
            if (specifier.properties[@"weight"]) {
                NSString *weightString = [specifier.properties[@"weight"] lowercaseString];
                UIImageSymbolWeight weight;
                if ([weightString isEqualToString:@"ultralight"]) {
                    weight = UIImageSymbolWeightUltraLight;
                } else if ([weightString isEqualToString:@"thin"]) {
                    weight = UIImageSymbolWeightThin;
                } else if ([weightString isEqualToString:@"light"]) {
                    weight = UIImageSymbolWeightLight;
                } else if ([weightString isEqualToString:@"regular"]) {
                    weight = UIImageSymbolWeightRegular;
                } else if ([weightString isEqualToString:@"medium"]) {
                    weight = UIImageSymbolWeightMedium;
                } else if ([weightString isEqualToString:@"semibold"]) {
                    weight = UIImageSymbolWeightSemibold;
                } else if ([weightString isEqualToString:@"bold"]) {
                    weight = UIImageSymbolWeightBold;
                } else if ([weightString isEqualToString:@"heavy"]) {
                    weight = UIImageSymbolWeightHeavy;
                } else if ([weightString isEqualToString:@"black"]) {
                    weight = UIImageSymbolWeightBlack;
                } else {
                    weight = UIImageSymbolWeightUnspecified;
                }

                UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:weight scale:UIImageSymbolScaleSmall];
                self.symbolsImage = [self.symbolsImage imageWithConfiguration:config];
                NSLog(@"[%@ %p] Applied weight configuration from weight \"%@\" and size %.f", NSStringFromClass(self.class), self, weightString, pointSize);
            } else {
                UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:pointSize weight:UIImageSymbolWeightUnspecified scale:UIImageSymbolScaleSmall];
                self.symbolsImage = [self.symbolsImage imageWithConfiguration:config];
                NSLog(@"[%@ %p] Applied size configuration with size %.f", NSStringFromClass(self.class), self, pointSize);
            }
            
            // Setting custom color if requested
            if (specifier.properties[@"color"]) {
                UIColor *finalColor = nil;

                NSString *stringColor = [specifier.properties[@"color"] lowercaseString];
                UIColor *color = [UIColor systemColorFromString:stringColor] ?: [UIColor colorFromHexString:stringColor];
                if (color) {
                    if (specifier.properties[@"darkColor"]) {
                        NSString *stringDarkColor = [specifier.properties[@"darkColor"] lowercaseString];
                        UIColor *darkColor = [UIColor systemColorFromString:stringDarkColor] ?: [UIColor colorFromHexString:stringDarkColor];
                        finalColor = [UIColor colorWithDynamicProvider:^UIColor * (UITraitCollection *traits) {
                            return traits.userInterfaceStyle == UIUserInterfaceStyleLight ? color : darkColor;
                        }];
                    } else {
                        finalColor = color;
                    }
                }

                if (finalColor) {
                    self.symbolsImage = [self.symbolsImage imageWithTintColor:finalColor renderingMode:UIImageRenderingModeAlwaysOriginal];
                    NSLog(@"[%@ %p] Color changed, now %@", NSStringFromClass(self.class), self, [[CIColor colorWithCGColor:finalColor.CGColor] stringRepresentation]);
                } else {
                    NSLog(@"[%@ %p] Error when changing color (color: %@, darkColor: %@)", NSStringFromClass(self.class), self, color, specifier.properties[@"darkColor"]);
                }
            }
        }
    }
    
    return self;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    if (self.imageView && self.symbolsImage && self.imageView.image != self.symbolsImage) {
        self.imageView.image = self.symbolsImage;
    }
}

@end
