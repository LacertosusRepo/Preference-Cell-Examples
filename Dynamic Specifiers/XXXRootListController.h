#import <Preferences/PSListController.h>

@class PSSpecifier;

typedef NS_ENUM(NSInteger, XXDynamicSpecifierOperatorType) {
  XXEqualToOperatorType,
  XXNotEqualToOperatorType,
  XXGreaterThanOperatorType,
  XXLessThanOperatorType,
};

@interface XXXRootListController : PSListController
@property (nonatomic, assign) BOOL hasDynamicSpecifiers;
@property (nonatomic, retain) NSMutableDictionary *dynamicSpecifiers;
- (void)collectDynamicSpecifiersFromArray:(NSArray *)array;
- (BOOL)shouldHideSpecifier:(PSSpecifier *)specifier;
- (XXDynamicSpecifierOperatorType)operatorTypeForString:(NSString *)string;
@end
