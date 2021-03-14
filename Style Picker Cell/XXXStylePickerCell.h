@interface PSSpecifier (PrivateMethods)
-(void)performSetterWithValue:(id)value;
-(id)performGetter;
@end

@interface LBMStylePickerCell : PSTableCell <LBMStyleOptionViewDelegate>
-(LBMStyleOptionView *)optionViewForID:(NSString *)identifier;
@end
