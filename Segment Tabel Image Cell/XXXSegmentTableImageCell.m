#import "XXXSegmentTableImageCell.h"

@implementation XXXSegmentTableImageCell {
  NSBundle *_bundle;
}

  -(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if(self) {
        //Set cell height, default height makes the images too small in my opinion
      [specifier setProperty:@60 forKey:@"height"];

      _bundle = [specifier.target bundle];
    }

    return self;
  }

    //Images should be included in your preference bundle
    //Get value title then find image and set for segment, if no image is found the normal title is left alone
  -(void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];

    NSArray *values = [specifier performSelector:@selector(values)];
    NSDictionary *titles = [specifier titleDictionary];
    for(id value in values) {
      UIImage *image = [[UIImage imageNamed:titles[value] inBundle:_bundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
      if(image) {
        [(UISegmentControl *)self.control setImage:image forSegmentAtIndex:[values indexOfObject:value]];
      }
    }
  }
@end
