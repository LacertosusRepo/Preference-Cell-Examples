#import <UIKit/UIKit.h>

@interface XXXAnimatedBanner : UIView
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *gradientView;
@property(nonatomic, strong) UILabel *subtitleLabel;
@property(nonatomic, strong) CAGradientLayer *gradient;
@property(nonatomic, strong) NSMutableArray *animations;
@property(nonatomic, strong) NSMutableArray *cgcolors;
@property(nonatomic) CGFloat defaultOffset;
@property(nonatomic, strong) NSLayoutConstraint *stackCenter;
@property(nonatomic, assign, getter=isGradientActivated) BOOL activateGradient;
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle colors:(NSArray<__kindof UIColor *> *)colors defaultOffset:(CGFloat)offset;
- (void)adjustStackPositionToScrollOffset:(CGFloat)offset;
@end
