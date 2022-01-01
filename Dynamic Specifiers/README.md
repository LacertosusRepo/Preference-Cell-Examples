## Dynamically Toggling Specifiers
*Hiding specifiers can be a way to communicate to a user that an option is unavailable or available in certain circumstances. In this example we will hide a cell when a switch is set to NO.*

1. Add a `NSMutableDictionary` property named `dynamicSpecifiers` and a `BOOL` property named `hasDynamicSpecifiers` to your RootListController's interface. The dictionary is where we will save our togglable specifiers and the opposing specifier `id` who's value determines the visibility of the toggleable specifier:

```objc
@interface XXXRootListController : PSListController
@property (nonatomic, assign) BOOL hasDynamicSpecifiers;
@property (nonatomic, retain) NSMutableDictionary *dynamicSpecifiers;
@end
```

2. Add an (unique) `id` to the opposing specifier which value we need to check when hiding or showing our dynamic specifier. Add the `dynamicRule` key to the specifier that will be dynamic:

```xml
<dict>
  <key>cell</key>
  <string>PSGroupCell</string>
</dict>
<dict>
  <key>cell</key>
  <string>PSSwitchCell</string>
  <key>default</key>
  <true/>
  <key>defaults</key>
  <string>com.company.tweak</string>
  <key>key</key>
  <string>switchKey</string>
  <key>label</key>
  <string>This Switch Will Toggle The Other Cell</string>
  <key>PostNotification</key>
  <string>com.company.tweak/ReloadPrefs</string>
  <key>id</key>
  <string>SWITCH_ID</string>
</dict>
<dict>
  <key>cell</key>
  <string>PSButtonCell</string>
  <key>action</key>
  <string>buttonAction:</string>
  <key>label</key>
  <string>This Button Cell Will Be Dynamically Hidden/Shown</string>
  <key>dynamicRule</key>
  <string></string>
</dict>
```

3. You **MUST** add the `height` key to your dynamic specifier if it is not specified already or is set somewhere else programatically:

```xml
<dict>
  <key>cell</key>
  <string>PSButtonCell</string>
  <key>action</key>
  <string>buttonAction:</string>
  <key>label</key>
  <string>This Button Cell Will Be Dynamically Hidden/Shown</string>
  <key>height</key>
  <real>44</key>
  <key>dynamicRule</key>
  <string></string>
</dict>
```

4. A specifiers's `dynamicRule` is the condition that needs to be met for your the specifier to be hidden. Configuring your 'dynamicRule' is easy, here is a quick description of each component: Specifier ID, Comparator, Value To Compare To. For this example, we would configure the specifier to hide when the switch's value is NO:

```xml
<dict>
  <key>cell</key>
  <string>PSButtonCell</string>
  <key>action</key>
  <string>buttonAction:</string>
  <key>label</key>
  <string>This Button Cell Will Be Dynamically Hidden/Shown</string>
  <key>dynamicRule</key>
  <string>SWITCH_ID, ==, 0</string>
</dict>
```

5. Add the method `collectDynamicSpecifiersFromArray:` to your RootListController. This method adds the dynamic specifier to the `dynamicSpecifiers` dictionary with the opposing specifier's `id` as the key. Call this method from the `-specifiers` method and `-reloadSpecifiers`:

```objc
-(void)collectDynamicSpecifiersFromArray:(NSArray *)array {
  if(!self.dynamicSpecifiers) {
    self.dynamicSpecifiers = [NSMutableDictionary new];

  } else {
    [self.dynamicSpecifiers removeAllObjects];
  }

  for(PSSpecifier *specifier in array) {
    NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];

    if(dynamicSpecifierRule.length > 0) {
      NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];

      if(ruleComponents.count == 3) {
        NSString *opposingSpecifierID = [ruleComponents objectAtIndex:0];
        [self.dynamicSpecifiers setObject:specifier forKey:opposingSpecifierID];

      } else {
        [NSException raise:NSInternalInconsistencyException format:@"dynamicRule key requires three components (Specifier ID, Comparator, Value To Compare To). You have %ld of 3 (%@) for specifier '%@'.", ruleComponents.count, dynamicSpecifierRule, [specifier propertyForKey:PSTitleKey]];
      }
    }
  }

  self.hasDynamicSpecifiers = (self.dynamicSpecifiers.count > 0);
}

-(NSArray *)specifiers {
  if (!_specifiers) {
    _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

    [self collectDynamicSpecifiersFromArray:_specifiers];
  }

  return _specifiers;
}

-(void)reloadSpecifiers {
  [super reloadSpecifiers];

  [self collectDynamicSpecifiersFromArray:self.specifiers];
}
```

6. Next we will override some methods to add some additional functionality. In the `-setPreferenceValue:specifier:` method we update our visible cells if the value changed belongs to a specifier tied to one of our dynamic specifiers:

```objc
-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];
    
    if(self.hasDynamicSpecifiers) {
      NSString *specifierID = [specifier propertyForKey:PSIDKey];
      PSSpecifier *dynamicSpecifier = [self.dynamicSpecifiers objectForKey:specifierID];

      if(dynamicSpecifier) {
        [self.table beginUpdates];
        [self.table endUpdates];
      }
    }
  }
```

7. Next, in the `-tableView:heightForRowAtIndexPath:` delegate method we return zero whenever one of our dynamic specifiers should be hidden:

```objc
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if(self.hasDynamicSpecifiers) {
    PSSpecifier *dynamicSpecifier = [self specifierAtIndexPath:indexPath];

    if([self.dynamicSpecifiers.allValues containsObject:dynamicSpecifier]) {
      BOOL shouldHide = [self shouldHideSpecifier:dynamicSpecifier];

      UITableViewCell *specifierCell = [dynamicSpecifier propertyForKey:PSTableCellKey];
      specifierCell.clipsToBounds = shouldHide;

      if(shouldHide) {
        return 0;
      } 
    }
  }

  return UITableViewAutomaticDimension;
}
```

8. Now we will implement the `-shouldHideSpecifier:` method. This method checks if the condition is met to hide the specifier:

```objc
-(BOOL)shouldHideSpecifier:(PSSpecifier *)specifier {
  if(specifier) {
    NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];
    NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];

    PSSpecifier *opposingSpecifier = [self specifierForID:[ruleComponents objectAtIndex:0]];
    id opposingValue = [self readPreferenceValue:opposingSpecifier];
    id requiredValue = [ruleComponents objectAtIndex:2];

    if([opposingValue isKindOfClass:NSNumber.class]) {
      XXDynamicSpecifierOperatorType operatorType = [self operatorTypeForString:[ruleComponents objectAtIndex:1]];

      switch(operatorType) {
        case LDEqualToOperatorType:
          return ([opposingValue intValue] == [requiredValue intValue]);
        break;

        case LDNotEqualToOperatorType:
          return ([opposingValue intValue] != [requiredValue intValue]);
        break;

        case LDGreaterThanOperatorType:
          return ([opposingValue intValue] > [requiredValue intValue]);
        break;

        case LDLessThanOperatorType:
          return ([opposingValue intValue] < [requiredValue intValue]);
        break;
      }
    }

    if([opposingValue isKindOfClass:NSString.class]) {
      return [opposingValue isEqualToString:requiredValue];
    }

    if([opposingValue isKindOfClass:NSArray.class]) {
      return [opposingValue containsObject:requiredValue];
    }
  }

  return NO;
}
```

8. Finally, we implement the `-operatorTypeForString:` helper method which converts the operator string from the `dynamicRule` key to an enum you should declare in your RootListController header:

```objc
-(XXDynamicSpecifierOperatorType)operatorTypeForString:(NSString *)string {
  NSDictionary *operatorValues = @{ @"==" : @(XXEqualToOperatorType), @"!=" : @(XXNotEqualToOperatorType), @">" : @(XXGreaterThanOperatorType), @"<" : @(XXLessThanOperatorType) };
  return [operatorValues[string] intValue];
}
```

```objc
typedef NS_ENUM(NSInteger, XXDynamicSpecifierOperatorType) {
  XXEqualToOperatorType,
  XXNotEqualToOperatorType,
  XXGreaterThanOperatorType,
  XXLessThanOperatorType,
};
```

# Additional Notes

* Depending on what SDK you use, you might need to declare the `-readPreferenceValue:` method for `PSListController`:

```objc
@interface PSListController (Private)
-(id)readPreferenceValue:(PSSpecifier *)arg1;
@end
```

* This method can be implemented in the form of a category to `PSListController`, if used often enough. Included in my [libDeusPrefs](https://github.com/LacertosusRepo/libDeusPrefs) library.

* This method improves over my old method of inserting/removing specifiers greatly (in my opinion), requireing less work on the developer's end at the cost of control.

* Here is a complete list of operators for the `dynamicRule` key. You can always add your own:

| Operator | Example Usage | 
| -------- | ------------- |
| == | SPEC_ID, ==, 242 |
| != | SPEC_ID, !=, 0 |
| > | SPEC_ID, >, 5 |
| < | SPEC_ID, <, 100 |
