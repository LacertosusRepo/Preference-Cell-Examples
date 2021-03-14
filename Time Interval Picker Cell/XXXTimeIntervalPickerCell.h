#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface XXXTimeIntervalPickerCell : PSTableCell <UIPickerViewDataSource, UIPickerViewDelegate>
@end

@interface UIView (Private)
-(UIViewController *)_viewControllerForAncestor;
@end

@interface PSSpecifier (Private)
-(void)performSetterWithValue:(id)value;
-(id)performGetter;
@end
