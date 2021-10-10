#import <Preferences/PSSpecifier.h>

@interface UIColor (SymbolsLinkCell)
+ (UIColor *)systemColorFromString:(NSString *)stringColor;
+ (UIColor *)colorFromHexString:(NSString *)hex;
@end

@interface XXXSymbolsLinkCell : PSTableCell
@property (nonatomic, strong) UIImage *symbolsImage;
@end
