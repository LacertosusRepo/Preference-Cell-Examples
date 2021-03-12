#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface PSSpecifier (Private)
-(id)performGetter;
-(void)performSetterWithValue:(id)value;
@end

@interface UIView (Private)
-(UIViewController *)_viewControllerForAncestor;
@end

@interface XXXLabeledSliderCell : PSSliderTableCell
@end
