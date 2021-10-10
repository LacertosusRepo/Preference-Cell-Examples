#import <UIKit/UIKit.h>

@interface XXXAnimatedTitleView : UIView
-(instancetype)initWithTitle:(NSString *)title minimumScrollOffsetRequired:(CGFloat)minimumOffset;
-(void)adjustLabelPositionToScrollOffset:(CGFloat)offset;
@end
