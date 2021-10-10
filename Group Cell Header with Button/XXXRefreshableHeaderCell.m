#import "XXXRefreshableHeaderCell.h"

@implementation XXXRefreshableHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if (self = [super initWithStyle:style reuseIdentifier:nil specifier:specifier]) {
        // Recreate main label
        self.titleLabel.text = [localize(specifier.properties[@"label"], @"MoreSub") uppercaseString];
        [self.titleLabel sizeToFit];
        self.titleLabel.textColor = [UIColor _groupTableHeaderFooterTextColor];
        self.titleLabel.font = [UIFont systemFontOfSize:13.f];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

        // Button
        self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.actionButton setTitle:[specifier.properties[@"actionLabel"] uppercaseString] forState:UIControlStateNormal];
        [self.actionButton setTitleColor:[self.actionButton.tintColor colorWithAlphaComponent:.5] forState:(UIControlStateHighlighted | UIControlStateSelected)];
        self.actionButton.titleLabel.font = [self.actionButton.titleLabel.font fontWithSize:13.f];
        [self.actionButton addTarget:specifier.target action:NSSelectorFromString(specifier.properties[@"action"]) forControlEvents:UIControlEventTouchUpInside];
        self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.actionButton];

        // Constraints
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-[action]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"label" : self.titleLabel, @"action" : self.actionButton }]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"label" : self.titleLabel }]];
        // For a reason the constraint needs to be inverted for the button
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[action]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{ @"action" : self.actionButton }]];
    }
    return self;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
    return self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil specifier:specifier];
}

#pragma mark - PSHeaderFooterView

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
    return 38.f; // default height
}

@end
