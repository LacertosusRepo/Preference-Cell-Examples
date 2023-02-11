  /*
   * Based off of Boo-dev's libstylepicker
   * https://github.com/boo-dev/libstylepicker
   */
#import <UIKit/UIKit.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import "XXXStyleOptionView.h"
#import "XXXStylePickerCell.h"

@implementation XXXStylePickerCell {
  UIStackView *_stackView;
}

  -(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier specifier:specifier];

    if(self) {
        //Set height of cell
      [specifier setProperty:@215 forKey:@"height"];

      NSMutableArray *optionViewArray = [[NSMutableArray alloc] init];
      NSBundle *bundle = [specifier.target bundle];
      NSArray *optionArray = [specifier propertyForKey:@"options"];
      NSString *localizationTable = [specifier propertyForKey:@"localizationTable"];
      id cellValue = [specifier performGetter];

        //Create option views
      for(NSDictionary *styleProperties in optionArray) {
        NSString *appearanceOption = [styleProperties objectForKey:@"appearanceOption"];
        NSString *labelText = [styleProperties objectForKey:@"label"];
        NSString *imageName = [styleProperties objectForKey:@"image"];
        NSString *imageAltName = [styleProperties objectForKey:@"imageAlt"];

        XXXStyleOptionView *optionView = [[XXXStyleOptionView alloc] initWithAppearanceOption:appearanceOption];
        optionView.delegate = self;
        optionView.label.text = [bundle localizedStringForKey:labelText value:labelText table:localizationTable];
        optionView.previewImage = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
        optionView.previewImageAlt = [UIImage imageNamed:imageAltName inBundle:bundle compatibleWithTraitCollection:nil];
        optionView.highlighted = [optionView.appearanceOption isEqual:cellValue];
        optionView.translatesAutoresizingMaskIntoConstraints = NO;

        [optionViewArray addObject:optionView];
      }

      _stackView = [[UIStackView alloc] initWithArrangedSubviews:optionViewArray];
      _stackView.alignment = UIStackViewAlignmentCenter;
      _stackView.axis = UILayoutConstraintAxisHorizontal;
      _stackView.distribution = UIStackViewDistributionFillEqually;
      _stackView.spacing = 0;
      _stackView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.contentView addSubview:_stackView];

      [NSLayoutConstraint activateConstraints:@[
        [_stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [_stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [_stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [_stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
      ]];
    }

    return self;
  }

    //Update selected option view
  -(void)selectedOption:(XXXStyleOptionView *)option {
    [self.specifier performSetterWithValue:option.appearanceOption];

    for(XXXStyleOptionView *view in _stackView.arrangedSubviews) {
      [view updateViewForOption:option.appearanceOption];
    }
  }

    //Get option view for ID
  -(XXXStyleOptionView *)optionViewForID:(NSString *)identifier {
    for(XXXStyleOptionView *view in _stackView.arrangedSubviews) {
      if([view.label.text isEqualToString:identifier]) {
        return view;
      }
    }

    return nil;
  }
@end
