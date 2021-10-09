#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSHeaderFooterView.h>

@interface UIColor (Private)
+ (id)_groupTableHeaderFooterTextColor;
@end

@interface XXXRefreshableHeaderCell : PSTableCell <PSHeaderFooterView>
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *actionButton;
@end
