#import <Preferences/PSSpecifier.h>

@interface UIColor (SymbolsLinkCell)
+ (UIColor *)customDynamicColorWithLightColor:(id)lightColor darkColor:(id)darkColor API_AVAILABLE(ios(13.0));
+ (UIColor *)colorFromHexString:(NSString *)hex;
@end

@interface XXXSymbolsLinkCell : PSTableCell
@property (nonatomic, strong) UIImage *symbolsImage;
@property (nonatomic, strong) UIColor *customColor;
@end
