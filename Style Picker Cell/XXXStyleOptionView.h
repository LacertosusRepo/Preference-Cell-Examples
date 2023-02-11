@class XXXStyleOptionView;
@protocol XXXStyleOptionViewDelegate <NSObject>
@required
-(void)selectedOption:(XXXStyleOptionView *)option;
@end

@interface XXXStyleOptionView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, weak) id<XXXStyleOptionViewDelegate> delegate;
@property (nonatomic, retain) id appearanceOption;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, retain) UIImage *previewImage;
@property (nonatomic, retain) UIImage *previewImageAlt;
@property (nonatomic, retain) UILabel *label;
-(instancetype)initWithAppearanceOption:(id)option;
-(void)updateViewForOption:(id)option;
@end
