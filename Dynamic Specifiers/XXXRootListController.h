@interface PSListController (Private)
-(BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end

@interface XXXRootListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@end
