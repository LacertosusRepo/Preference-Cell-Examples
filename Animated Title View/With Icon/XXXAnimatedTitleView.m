#import "XXXAnimatedTitleView.h"

@implementation XXXAnimatedTitleView

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image minimumScrollOffsetRequired:(CGFloat)minimumOffset {
	if (self = [super init]) {
		self.superview.clipsToBounds = YES;

		UILabel *titleLabel = [[UILabel alloc] init];
		titleLabel.text = title;
		titleLabel.textAlignment = NSTextAlignmentCenter;
		if (@available(iOS 13.0, *)) {
			titleLabel.textColor = [UIColor labelColor];
		} else {
			titleLabel.textColor = [UIColor blackColor];
		}
		titleLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] weight:UIFontWeightSemibold];
		titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[titleLabel sizeToFit];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.iconView.image = image;
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;

		[self addSubview:titleLabel];
        [self addSubview:self.iconView];

		[NSLayoutConstraint activateConstraints:@[
			[self.widthAnchor constraintEqualToAnchor:titleLabel.widthAnchor],
			[self.heightAnchor constraintEqualToAnchor:titleLabel.heightAnchor],
			[titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
			self.labelYConstraint = [titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:50],
			
			[self.iconView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
			self.iconYConstraint = [self.iconView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:0]
		]];

		self.minimumOffsetRequired = minimumOffset;
	}

	return self;
}

- (void)adjustItemsPositionToScrollOffset:(CGFloat)offset {
	CGFloat adjustment = 50 - (offset - self.minimumOffsetRequired);
	if (offset >= self.minimumOffsetRequired) {
		self.labelYConstraint.constant = adjustment <= 0 ? 0 : adjustment;
		self.iconYConstraint.constant = adjustment <= 40 ? adjustment <= -10 ? -50 : adjustment - 40 : 0; // don't ask me i don't know
	} else {
		self.labelYConstraint.constant = 50;
		self.iconYConstraint.constant = 0;
	}
	self.iconView.alpha = self.labelYConstraint.constant / 50;
}
@end
