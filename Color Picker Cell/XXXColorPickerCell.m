#import "XXXColorPickerCell.h"

@implementation XXXColorPickerCell {
  UIColorPickerViewController *_colorPicker;
  UIColor *_currentColor;
  NSString *_fallbackHex;
  BOOL _supportsAlpha;

  UIView *_indicatorView;
  CAShapeLayer *_indicatorShape;
}

  -(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier];

    if(self) {
      _fallbackHex = [specifier propertyForKey:@"fallbackHex"];
      _supportsAlpha = [specifier propertyForKey:@"supportsAlpha"];

      NSBundle *bundle = [specifier.target bundle];
      NSString *label = [specifier propertyForKey:@"label"];
      NSString *localizationTable = [specifier propertyForKey:@"localizationTable"];

        //Setup color picker
      _colorPicker = [[UIColorPickerViewController alloc] init];
      _colorPicker.delegate = self;
      _colorPicker.supportsAlpha = _supportsAlpha;
      _colorPicker.title = [bundle localizedStringForKey:label value:label table:localizationTable];

        //Create color indicator
      _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
      _indicatorView.clipsToBounds = YES;
      _indicatorView.layer.borderColor = [UIColor opaqueSeparatorColor].CGColor;
      _indicatorView.layer.borderWidth = 3;
      _indicatorView.layer.cornerRadius = 14.5;
      self.accessoryView = _indicatorView;

        //Create color indicator fill
      _indicatorShape = [CAShapeLayer layer];
      _indicatorShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 29, 29) cornerRadius:14.5].CGPath;
      [_indicatorView.layer addSublayer:_indicatorShape];

        //Get saved hex or fallback hex, convert to color and set indicator color and hex subtitle
      NSString *hex = ([specifier performGetter]) ?: _fallbackHex;
      _currentColor = [self colorFromHex:hex useAlpha:_supportsAlpha];
      _indicatorShape.fillColor = _currentColor.CGColor;
      self.detailTextLabel.text = [self legibleStringFromHex:hex];
    }

    return self;
  }

  -(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if(selected) {
      [self presentColorPicker];
    } else {
      [super setSelected:selected animated:animated];
    }
  }

    //Present color picker on selection
  -(void)presentColorPicker {
    _colorPicker.selectedColor = _currentColor;

    //Ignore keywindow deprecation warning
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIViewController *rootViewController = self._viewControllerForAncestor ?: [UIApplication sharedApplication].keyWindow.rootViewController;
#pragma clang diagnostic pop
    
    [rootViewController presentViewController:_colorPicker animated:YES completion:nil];
  }

#pragma mark - UIColorPickerViewControllerDelegate Methods

    //Update color on selection. We then we save the hex, update the indicator, and update the subtitle.
  -(void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)colorPicker {
    _currentColor = colorPicker.selectedColor;

    NSString *selectedColorHex = [self hexFromColor:_currentColor useAlpha:_supportsAlpha];
    [self.specifier performSetterWithValue:selectedColorHex];

    [UIView transitionWithView:_indicatorView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      _indicatorShape.fillColor = _currentColor.CGColor;
    } completion:nil];

    [UIView transitionWithView:self.detailTextLabel duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve  animations:^{
      self.detailTextLabel.text = [self legibleStringFromHex:selectedColorHex];
    } completion:nil];
  }

#pragma mark - Converting Colors

    //Convert hex value to UIColor
  -(UIColor *)colorFromHex:(NSString *)hexString useAlpha:(BOOL)useAlpha {
    hexString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];

    if([hexString containsString:@":"] || hexString.length == 6) {
      NSArray *hexComponents = [hexString componentsSeparatedByString:@":"];
      CGFloat alpha = (hexComponents.count == 2) ? [[hexComponents lastObject] floatValue] / 100 : 1.0;
      hexString = [NSString stringWithFormat:@"%@%02X", [hexComponents firstObject], (int)(alpha * 255.0)];
    }

    unsigned int hex = 0;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hex];

    CGFloat r = ((hex & 0xFF000000) >> 24) / 255.0;
    CGFloat g = ((hex & 0x00FF0000) >> 16) / 255.0;
    CGFloat b = ((hex & 0x0000FF00) >> 8) / 255.0;
    CGFloat a = (useAlpha) ? ((hex & 0x000000FF) >> 0) / 255.0 : 0xFF;

    return [UIColor colorWithRed:r green:g blue:b alpha:a];
  }

    //Convert UIColor components into hex format including alpha
  -(NSString *)hexFromColor:(UIColor *)color useAlpha:(BOOL)useAlpha {
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];

    NSString *hexString = [NSString stringWithFormat:@"#%02X%02X%02X%02X", (int)(r * 255.0), (int)(g * 255.0), (int)(b * 255.0), (int)(a * 255.0)];

    if(!useAlpha) {
      hexString = [hexString substringToIndex:hexString.length - 2];
    }

    return hexString;;
  }

  -(NSString *)legibleStringFromHex:(NSString *)hexString {
    hexString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];

    if([hexString containsString:@":"]) {
      NSArray *hexComponents = [hexString componentsSeparatedByString:@":"];
      return [NSString stringWithFormat:@"#%@:%@", hexComponents[0], hexComponents[1]];

    } else if(hexString.length == 6) {
      return [NSString stringWithFormat:@"#%@", hexString];
    }

    unsigned int hex = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&hex];

    return [NSString stringWithFormat:@"#%@:%.2f", [hexString substringToIndex:hexString.length - 2], ((hex & 0x000000FF) >> 0) / 255.0];
  }

#pragma mark - Tint Color

    //Tint text color
  -(void)tintColorDidChange {
    [super tintColorDidChange];

    self.textLabel.textColor = self.tintColor;
    self.textLabel.highlightedTextColor = self.tintColor;
  }

  -(void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    if([self respondsToSelector:@selector(tintColor)]) {
      self.textLabel.textColor = self.tintColor;
      self.textLabel.highlightedTextColor = self.tintColor;
    }
  }
@end
