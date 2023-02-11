#import <UIKit/UIKit.h>
#import "XXXStyleCheckView.h"
#import "XXXStyleOptionView.h"

@implementation XXXStyleOptionView {
  UIStackView *_stackView;
  UIImageView *_previewImageView;
  XXXStyleCheckView *_checkView;
  UILongPressGestureRecognizer *_pressGesture;
}

  -(instancetype)initWithAppearanceOption:(id)option {
    self = [super init];

      //Setup preview image, label, stackview and add gesture
    if(self) {
      _appearanceOption = option;

      _previewImageView = [[UIImageView alloc] init];
      _previewImageView.clipsToBounds = YES;
      _previewImageView.contentMode = UIViewContentModeScaleAspectFit;
      _previewImageView.layer.cornerRadius = 8;
      _previewImageView.layer.borderColor = self.tintColor.CGColor;
      _previewImageView.translatesAutoresizingMaskIntoConstraints = NO;

      _label = [[UILabel alloc] init];
      _label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
      _label.numberOfLines = 2;
      _label.textAlignment = NSTextAlignmentCenter;
      _label.translatesAutoresizingMaskIntoConstraints = NO;

      _checkView = [[XXXStyleCheckView alloc] init];
      _checkView.translatesAutoresizingMaskIntoConstraints = NO;

      _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_previewImageView, _label, _checkView]];
      _stackView.alignment = UIStackViewAlignmentCenter;
      _stackView.axis = UILayoutConstraintAxisVertical;
      _stackView.distribution = UIStackViewDistributionEqualSpacing;
      _stackView.spacing = 5;
      _stackView.translatesAutoresizingMaskIntoConstraints = NO;
      [self addSubview:_stackView];

      [NSLayoutConstraint activateConstraints:@[
        [_stackView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

        [_checkView.heightAnchor constraintEqualToConstant:22],
        [_checkView.widthAnchor constraintEqualToConstant:22],
      ]];

      _pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
      _pressGesture.delegate = self;
      _pressGesture.minimumPressDuration = 0.01;
      _pressGesture.allowableMovement = 0;
      [self addGestureRecognizer:_pressGesture];
    }

    return self;
  }

  -(void)setPreviewImage:(UIImage *)image {
    _previewImage = image;
    _previewImageView.image = _previewImage;
  }

    //Change image if dark mode is active & the alternative image exists
  -(void)setPreviewImageAlt:(UIImage *)image {
    _previewImageAlt = image;

    if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark && _previewImageAlt) {
      _previewImageView.image = _previewImageAlt;
    }
  }

    //Animate border when selected
  -(void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    [_checkView setSelected:_highlighted];

    if(_highlighted) {
      CABasicAnimation *showBorder = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
      showBorder.duration = 0.1;
      showBorder.fromValue = @0;
      showBorder.toValue = @3;

      _previewImageView.layer.borderWidth = 3;
      [_previewImageView.layer addAnimation:showBorder forKey:@"Show Border"];
    }

    if(!_highlighted && _previewImageView.layer.borderWidth == 3) {
      CABasicAnimation *hideBorder = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
      hideBorder.duration = 0.1;
      hideBorder.fromValue = @3;
      hideBorder.toValue = @0;

      _previewImageView.layer.borderWidth = 0;
      [_previewImageView.layer addAnimation:hideBorder forKey:@"Hide Border"];
    }
  }

    //Allows option to be disabled
  -(void)setDisabled:(BOOL)disabled {
    _disabled = disabled;

    if(disabled) {
      _pressGesture.enabled = NO;

      [UIView animateWithDuration:0.1 animations:^{
        _previewImageView.alpha = 0.5;
        _previewImageView.layer.borderColor = [UIColor grayColor].CGColor;
        self.label.alpha = 0.5;
        _checkView.alpha = 0.5;
      }];

    } else {
      _pressGesture.enabled = YES;

      [UIView animateWithDuration:0.1 animations:^{
        _previewImageView.alpha = 1.0;
        _previewImageView.layer.borderColor = self.tintColor.CGColor;
        self.label.alpha = 1.0;
        _checkView.alpha = 1.0;
      }];
    }
  }

    //Update option if it's selected
  -(void)updateViewForOption:(id)option {
    self.highlighted = [option isEqualToString:_appearanceOption];
  }

    //Fade image in/out during different states of press gesture
  -(void)handlePress:(UIGestureRecognizer *)gesture {
    switch (gesture.state) {
      case UIGestureRecognizerStateBegan:
      {
        [UIView animateWithDuration:0.1 animations:^{
          _previewImageView.alpha = 0.75;
        }];
      }
      break;

      case UIGestureRecognizerStateRecognized:
      {
        [UIView animateWithDuration:0.1 animations:^{
          _previewImageView.alpha = 1.0;
        }];

        if(!self.highlighted) {
          [self.delegate selectedOption:self];
        }
      }
      break;

      case UIGestureRecognizerStateFailed:
      case UIGestureRecognizerStateCancelled:
      {
        [UIView animateWithDuration:0.1 animations:^{
          _previewImageView.alpha = 1.0;
        }];
      }
      break;

      default:
      break;
    }
  }

    //Cancel long press gesture if scroll starts
  -(BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGesture {
    if([otherGesture isKindOfClass:[UIPanGestureRecognizer class]] && otherGesture.state == UIGestureRecognizerStateBegan) {
      _pressGesture.enabled = NO;
      _pressGesture.enabled = YES;
    }

    return YES;
  }

    //Change images based on dark or light mode
  -(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];

    if(self.previewImage && self.previewImageAlt) {
      switch (self.traitCollection.userInterfaceStyle) {
        case UIUserInterfaceStyleUnspecified:
        case UIUserInterfaceStyleLight:
        {
          [UIView transitionWithView:_previewImageView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _previewImageView.image = self.previewImage;
          } completion:nil];
        }
        break;

        case UIUserInterfaceStyleDark:
        {
          [UIView transitionWithView:_previewImageView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            _previewImageView.image = self.previewImageAlt;
          } completion:nil];
        }
        break;
      }
    }
  }

    //Update label tint color along with border color
  -(void)tintColorDidChange {
    [super tintColorDidChange];

    _previewImageView.layer.borderColor = self.tintColor.CGColor;
  }
@end
