#import "XXXSymbolsLinkCell.h"

@implementation UIColor (SymbolsLinkCell)

+ (UIColor *)customDynamicColorWithLightColor:(id)lightColor darkColor:(id)darkColor {
    if ((![lightColor isKindOfClass:UIColor.class] && ![lightColor isKindOfClass:NSString.class]) || 
        (![darkColor isKindOfClass:UIColor.class] && ![darkColor isKindOfClass:NSString.class])) {
        NSLog(@"[%@] Incorrect arguments, returning nil", NSStringFromSelector(_cmd));
        return nil;
    }

    UIColor *light = [lightColor isKindOfClass:UIColor.class] ? lightColor : [self.class colorFromHexString:lightColor];
    UIColor *dark = [darkColor isKindOfClass:UIColor.class] ? darkColor : [self.class colorFromHexString:darkColor];

    return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traits) {
        return traits.userInterfaceStyle == UIUserInterfaceStyleLight ? light : dark;
    }];
}

// https://stackoverflow.com/a/12397366/12070367
+ (UIColor *)colorFromHexString:(NSString *)hex {
    unsigned intValue = 0;
    [[NSScanner scannerWithString:[hex stringByReplacingOccurrencesOfString:@"#" withString:@""]] scanHexInt:&intValue];
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
            if (!specifier.properties[@"icon"]) {
                NSLog(@"[%@ %p] No icon found, falling back to default behavior", NSStringFromClass(self.class), self);
                return self;
            }
            
            if ((self.symbolsImage = [UIImage systemImageNamed:specifier.properties[@"icon"]])) {
                NSLog(@"[%@ %p] Applied SF Symbol: %@", NSStringFromClass(self.class), self, specifier.properties[@"icon"]);
            } else {
                NSLog(@"[%@ %p] SF Symbol \"%@\" not found, falling back to default behavior", NSStringFromClass(self.class), self, specifier.properties[@"icon"]);
                return self;
            }

            if (specifier.properties[@"weight"]) {
                NSString *weight = [specifier.properties[@"weight"] lowercaseString];
                UIImageConfiguration *config;
                if ([weight isEqualToString:@"ultralight"]) {
                    config = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightUltraLight];
                } else if ([weight isEqualToString:@"thin"]) {
                    config = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightThin];
                } else if ([weight isEqualToString:@"light"]) {
                    config = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightLight];
                } else if ([weight isEqualToString:@"regular"]) {
                    config = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightRegular];
                } else if ([weight isEqualToString:@"medium"]) {
                    config = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightMedium];
                } else if ([weight isEqualToString:@"semibold"]) {
                    config = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightSemibold];
                } else if ([weight isEqualToString:@"bold"]) {
                    config = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightBold];
                } else if ([weight isEqualToString:@"heavy"]) {
                    config = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightHeavy];
                } else if ([weight isEqualToString:@"black"]) {
                    config = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightBlack];
                } else {
                    config = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightUnspecified];
                }
                self.symbolsImage = [self.symbolsImage imageWithConfiguration:config];
                NSLog(@"[%@ %p] Applied weight configuration from weight \"%@\"", NSStringFromClass(self.class), self, weight);
            }

            if (specifier.properties[@"size"]) { // in px, modifies the largest side but keeps aspect ratio
                CGFloat biggestSide = [specifier.properties[@"size"] floatValue];

                CGSize actualSize = self.symbolsImage.size;
                CGSize newSize = CGSizeZero;
                if (actualSize.width == actualSize.height) {
                    newSize.width = (biggestSide / actualSize.width) * actualSize.width;
                    newSize.height = (biggestSide / actualSize.height) * actualSize.height;
                } else if (actualSize.width > actualSize.height) {
                    newSize.width = (biggestSide / actualSize.width) * actualSize.width;
                    newSize.height = (biggestSide / actualSize.width) * actualSize.height;
                } else {
                    newSize.width = (biggestSide / actualSize.height) * actualSize.width;
                    newSize.height = (biggestSide / actualSize.height) * actualSize.height;
                }

                UIImage *imageCopy = [self.symbolsImage copy];
                UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
                [imageCopy drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                self.symbolsImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                NSLog(@"[%@ %p] Resizing done, symbol is now %.1f x %.1f", NSStringFromClass(self.class), self, self.symbolsImage.size.width, self.symbolsImage.size.height);
            }
            
            if (specifier.properties[@"color"]) { // hex or system color
                NSString *color = [specifier.properties[@"color"] lowercaseString];
                UIColor *chosenColor;
                if ([color containsString:@"blue"]) {
                    chosenColor = [UIColor systemBlueColor];
                } else if ([color containsString:@"green"]) {
                    chosenColor = [UIColor systemGreenColor];
                } else if ([color containsString:@"indigo"]) {
                    chosenColor = [UIColor systemIndigoColor];
                } else if ([color containsString:@"orange"]) {
                    chosenColor = [UIColor systemOrangeColor];
                } else if ([color containsString:@"pink"]) {
                    chosenColor = [UIColor systemPinkColor];
                } else if ([color containsString:@"purple"]) {
                    chosenColor = [UIColor systemPurpleColor];
                } else if ([color containsString:@"red"]) {
                    chosenColor = [UIColor systemRedColor];
                } else if ([color containsString:@"teal"]) {
                    chosenColor = [UIColor systemTealColor];
                } else if ([color containsString:@"yellow"]) {
                    chosenColor = [UIColor systemYellowColor];
                } else if ([color containsString:@"gray2"]) {
                    chosenColor = [UIColor systemGray2Color];
                } else if ([color containsString:@"gray3"]) {
                    chosenColor = [UIColor systemGray3Color];
                } else if ([color containsString:@"gray4"]) {
                    chosenColor = [UIColor systemGray4Color];
                } else if ([color containsString:@"gray5"]) {
                    chosenColor = [UIColor systemGray5Color];
                } else if ([color containsString:@"gray6"]) {
                    chosenColor = [UIColor systemGray6Color];
                } else if ([color containsString:@"gray"]) {
                    chosenColor = [UIColor systemGrayColor];
                } else { // hex
                    NSString *darkString = specifier.properties[@"darkColor"] ?: color;
                    chosenColor = [UIColor customDynamicColorWithLightColor:color darkColor:darkString];
                }

                if (chosenColor) {
                    self.symbolsImage = [self.symbolsImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    self.customColor = chosenColor;
                    NSLog(@"[%@ %p] Color changed, now %@", NSStringFromClass(self.class), self, [[CIColor colorWithCGColor:chosenColor.CGColor] stringRepresentation]);
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
        if (self.customColor) self.imageView.tintColor = self.customColor;
    }
}

@end