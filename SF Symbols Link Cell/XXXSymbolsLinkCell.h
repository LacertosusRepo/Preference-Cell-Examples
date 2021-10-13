#import <Preferences/PSSpecifier.h>

@interface UIColor (Private)
+ (UIColor *)_systemColorWithName:(NSString *)arg1;
@end

@interface UIColor (SymbolsLinkCell)
+ (UIColor *)systemColorFromString:(NSString *)colorString;
+ (UIColor *)colorFromHexString:(NSString *)hex;
@end

@interface XXXSymbolsLinkCell : PSTableCell
@property (nonatomic, strong) UIImage *symbolsImage;
@end
