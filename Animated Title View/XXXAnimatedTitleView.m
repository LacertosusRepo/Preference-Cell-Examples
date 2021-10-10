#import "XXXAnimatedTitleView.h"

@implementation XXXAnimatedTitleView

- (instancetype)initWithTitle:(NSString *)title minimumScrollOffsetRequired:(CGFloat)minimumOffset {
	return [self initWithTitle:title image:nil minimumScrollOffsetRequired:minimumOffset];
}

- (instancetype)initWithTitle:(NSString *)title image:(_Nullable UIImage *)image minimumScrollOffsetRequired:(CGFloat)minimumOffset {
	if (self = [super init]) {
		self.superview.clipsToBounds = YES;

		_titleLabel = [[UILabel alloc] init];
		_titleLabel.text = title;
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		if (@available(iOS 13.0, *)) {
			_titleLabel.textColor = [UIColor labelColor];
		} else {
			_titleLabel.textColor = [UIColor blackColor];
		}
		_titleLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] weight:UIFontWeightSemibold];
		_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[_titleLabel sizeToFit];

        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _iconImageView.image = image;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;

		[self addSubview:_titleLabel];
        [self addSubview:_iconImageView];

		[NSLayoutConstraint activateConstraints:@[
			[self.widthAnchor constraintEqualToAnchor:_titleLabel.widthAnchor],
			[self.heightAnchor constraintEqualToAnchor:_titleLabel.heightAnchor],
			[_titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
			labelYConstraint = [_titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:50],
			
			[_iconImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
			iconYConstraint = [_iconImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:0]
		]];

		minimumOffsetRequired = minimumOffset;
	}

	return self;
}

- (void)adjustItemsPositionToScrollOffset:(CGFloat)offset {
	CGFloat adjustment = 50 - (offset - minimumOffsetRequired);
	if (offset >= minimumOffsetRequired) {
		labelYConstraint.constant = adjustment <= 0 ? 0 : adjustment;
		iconYConstraint.constant = adjustment <= 40 ? adjustment <= -10 ? -50 : adjustment - 40 : 0; // don't ask me i don't know
	} else {
		labelYConstraint.constant = 50;
		iconYConstraint.constant = 0;
	}
	_iconImageView.alpha = labelYConstraint.constant / 50;
}
@end
