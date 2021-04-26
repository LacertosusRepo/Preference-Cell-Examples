#import <UIKit/UIKit.h>

@interface XXXAnimatedTitleView : UIView
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) NSLayoutConstraint *labelYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *iconYConstraint;
@property (nonatomic) CGFloat minimumOffsetRequired;
-(instancetype)initWithTitle:(NSString *)title image:(UIImage *)image minimumScrollOffsetRequired:(CGFloat)minimumOffset;
-(void)adjustItemsPositionToScrollOffset:(CGFloat)offset;
@end
