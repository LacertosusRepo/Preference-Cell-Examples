#import <UIKit/UIKit.h>

@interface XXXAnimatedTitleView : UIView {
    NSLayoutConstraint *labelYConstraint;
    NSLayoutConstraint *iconYConstraint;
    CGFloat minimumOffsetRequired;
}
@property (nonatomic, strong, readonly) UIImageView *iconImageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
- (instancetype)initWithTitle:(NSString *)title minimumScrollOffsetRequired:(CGFloat)minimumOffset;
- (instancetype)initWithTitle:(NSString *)title image:(_Nullable UIImage *)image minimumScrollOffsetRequired:(CGFloat)minimumOffset;
- (void)adjustItemsPositionToScrollOffset:(CGFloat)offset;
@end
