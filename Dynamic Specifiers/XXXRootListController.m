@implementation XXXRootListController
	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

			NSArray *chosenIDs = @[@"CELL_ID"];
			self.savedSpecifiers = (self.savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
			for(PSSpecifier *specifier in [self specifiersForIDs:chosenIDs]) {
				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
			}
		}

		return _specifiers;
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
		[super setPreferenceValue:value specifier:specifier];

		[self toggleSpecifiersVisibility:YES];
	}

	-(void)reloadSpecifiers {
		[super reloadSpecifiers];

		[self toggleSpecifiersVisibility:NO];
	}

	-(void)updateSpecifierVisibility:(BOOL)animated {
		PSSpecifier *switchSpecifier = [self specifierForID:@"SWITCH_ID"];
		BOOL switchValue = [self readPreferenceValue:switchSpecifier];
				
		if(!switchValue) {
			[self removeSpecifier:self.savedSpecifiers[@"CELL_ID"] animated:animated];
		} else if(![self containsSpecifier:self.savedSpecifiers[@"CELL_ID"]]) {
			[self insertSpecifier:self.savedSpecifiers[@"CELL_ID"] afterSpecifierID:@"SWITCH_ID" animated:animated];
		}
	}

	-(void)viewDidLoad {
		[super viewDidLoad];

		[self toggleSpecifiersVisibility:NO];
	}
@end
