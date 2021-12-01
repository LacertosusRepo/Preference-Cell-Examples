#import "XXXRootListController.h"

@implementation XXXRootListController

#pragma mark - Collect Dynamic Specifiers

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

	-(void)collectDynamicSpecifiersFromArray:(NSArray *)array {
      //Create new dictionary or remove all previous specifiers
    if(!self.dynamicSpecifiers) {
      self.dynamicSpecifiers = [NSMutableDictionary new];

    } else {
      [self.dynamicSpecifiers removeAllObjects];
    }

      //Add any specifiers with rule to dynamic specifiers dictionary
    for(PSSpecifier *specifier in array) {
      NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];

      if(dynamicSpecifierRule.length > 0) {
          //Get rule components
        NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];

          //Add specifier to dictionary with opposing specifier ID as key
        if(ruleComponents.count == 3) {
          NSString *opposingSpecifierID = [ruleComponents objectAtIndex:0];
          [self.dynamicSpecifiers setObject:specifier forKey:opposingSpecifierID];

          //Throw error if rule has incorrect components
        } else {
          [NSException raise:NSInternalInconsistencyException format:@"dynamicRule key requires three components (Specifier ID, Comparator, Value To Compare To). You have %ld of 3 (%@) for specifier '%@'.", ruleComponents.count, dynamicSpecifierRule, [specifier propertyForKey:PSTitleKey]];
        }
      }
    }

      //Check if we need to update specifier height at all
    self.hasDynamicSpecifiers = (self.dynamicSpecifiers.count > 0);
  }

#pragma mark - Observing Opposing Specifier Value Changes

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];
    
    if(self.hasDynamicSpecifiers) {
        //Check if dynamic specifier exists for opposing specifier ID
      NSString *specifierID = [specifier propertyForKey:PSIDKey];
      PSSpecifier *dynamicSpecifier = [self.dynamicSpecifiers objectForKey:specifierID];

        //Update cells
      if(dynamicSpecifier) {
        [self.table beginUpdates];
        [self.table endUpdates];
      }
    }
  }

#pragma mark - Override Height

	-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.hasDynamicSpecifiers) {
      PSSpecifier *dynamicSpecifier = [self specifierAtIndexPath:indexPath];

        //Check if specifier exists in our dictionary values
      if([self.dynamicSpecifiers.allValues containsObject:dynamicSpecifier]) {
        BOOL shouldHide = [self shouldHideSpecifier:dynamicSpecifier];

          //Clips bounds if we're hiding the cell
        UITableViewCell *specifierCell = [dynamicSpecifier propertyForKey:PSTableCellKey];
        specifierCell.clipsToBounds = shouldHide;

        if(shouldHide) {
          return 0;
        } 
      }
    }

    return UITableViewAutomaticDimension;
  }

	-(BOOL)shouldHideSpecifier:(PSSpecifier *)specifier {
    if(specifier) {
        //Get dynamic rule components
      NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];
      NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];

				//Get values to compare to specifier's value
			PSSpecifier *opposingSpecifier = [self specifierForID:[ruleComponents objectAtIndex:0]];
			id opposingValue = [self readPreferenceValue:opposingSpecifier];
			id requiredValue = [ruleComponents objectAtIndex:2];

				//Numbers can use any operator
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

				//Strings can only check if equal
			if([opposingValue isKindOfClass:NSString.class]) {
				return [opposingValue isEqualToString:requiredValue];
			}

				//Arrays can check if value exists
			if([opposingValue isKindOfClass:NSArray.class]) {
				return [opposingValue containsObject:requiredValue];
			}
    }

    return NO;
  }

	-(XXDynamicSpecifierOperatorType)operatorTypeForString:(NSString *)string {
    NSDictionary *operatorValues = @{ @"==" : @(XXEqualToOperatorType), @"!=" : @(XXNotEqualToOperatorType), @">" : @(XXGreaterThanOperatorType), @"<" : @(XXLessThanOperatorType) };
    return [operatorValues[string] intValue];
  }
@end
