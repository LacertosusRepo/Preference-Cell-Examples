## In this example we will hide a cell when a switch is set to NO.

1. Add a `NSMutableDictionary` property named `savedSpecifiers` to your RootListController's interface, that is where we will store our specifiers that will be hidden and shown:

```objc
@interface XXXRootListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@end
```

2. Then in your `Root.plist`, add the ID property to the specifier(s) you intend to toggle along with the specifier(s) who's value(s) will determine if a specifier should be hidden or shown. The ID should be unique for each cell. Also add an ID to whatever specifiers are directly above the hideable specifiers so you can reinsert the specifiers underneath easily. Example *button cell* with a *switch cell*:

```xml
<dict>
	<key>cell</key>
	<string>PSGroupCell</string>
	<key>label</key>
	<string>My Cells</string>
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
	<string>This Button Cell Will Be Hidden/Shown</string>
	<key>id</key>
	<string>CELL_ID</string>
</dict>
```

3. In your XXXRootListController.m file, add a for loop that will add any specifiers with specific IDs to the savedSpecifiers NSMutableDictionary. Add this in the `-specifiers` method:

```objc
-(NSArray *)specifiers {
	if(!specifiers) {
		_specifiers = ...;  //Leave this as usual

		//In this array you should add the IDs of all the specifiers you are going to hide & show.
		//Do not include the IDs of the cells you will reinsert them under.
		//Notice I only included "CELL_ID" and not "SWITCH_ID".
		NSArray *chosenIDs = @[@"CELL_ID"];
		self.savedSpecifiers = (savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
		for(PSSpecifier *specifier in [self specifiersForIDs:chosenIDs) {
			[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
		}
	}

	return _specifiers;
}
```

4. Next add a new method to your RootListController's implementation. `-updateSpecifierVisibility:` will hide or show any specifiers whenever we call the method:

```objc
-(void)updateSpecifierVisibility:(BOOL)animated {
	//Get value of switch specifier
	PSSpecifier *switchSpecifier = [self specifierForID:@"SWITCH_ID"];
	BOOL switchValue = [[self readPreferenceValue:switchSpecifier] boolValue];
	
	//Check if our switch is set to NO, then remove the specifier
	if(!switchValue) {
		[self removeSpecifier:self.savedSpecifiers[@"CELL_ID"] animated:animated];

	//If the switch is set to YES, we check if the specifier exists then insert it after the switch using the SWITCH_ID
	} else if(![self containsSpecifier:self.savedSpecifiers[@"CELL_ID"]]) {
		[self insertSpecifier:self.savedSpecifiers[@"CELL_ID"] afterSpecifierID:@"SWITCH_ID" animated:animated];
	}
}
```

5. Next add the `-setPreferenceValue:specifier:` method to your XXXRootListController.m file. This method is called whenever a value is changed, so we can update specifier visibility:

```objc
-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	[super setPreferenceValue:value specifier:specifier];

	[self updateSpecifierVisibility:YES];
}
```

6. Similarly we do the same update in the `-reloadSpecifiers` method. You can notice if we hide a cell, leave then re-enter the preferences page that any hidden cells magically reappear. We fix this by updating the specifiers we need to again:

```objc
-(void)reloadSpecifiers {
	[super reloadSpecifiers];

	//We set the animated argument to NO to hide cell's animation of being removed
	[self updateSpecifierVisibility:NO];
}
```

7. Finally, to ensure our cells are in the right state on entering our preference page we update the specifiers in `-viewDidLoad`:

```objc
-(void)viewDidLoad {
	[super viewDidLoad];

	[self updateSpecifierVisibility:NO];
}
```

# Additional Notes:
- You might need to declare `-containsSpecifier:` or `-readPreferenceValue:` depending on your SDK:

```objc
@interface PSListController (Private)
-(BOOL)containsSpecifier:(PSSpecifier *)arg1;
-(id)readPreferenceValue:(PSSpecifier *)arg1;
@end
```

- Need to remove/insert multiple specifiers? Use these methods instead as they take an array of specifiers to remove/insert:
```objc
-(void)removeContiguousSpecifiers:(NSArray *)arg1 animated:(BOOL)arg2;
-(void)insertContiguousSpecifiers:(NSArray *)arg1 afterSpecifierID:(id)arg2 animated:(BOOL)arg3;
```
