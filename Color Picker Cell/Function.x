//Function to convert hex to UIColor
UIColor* colorFromHex(NSString *hexString, BOOL useAlpha) {
	hexString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];

	if([hexString containsString:@":"] || hexString.length == 6) {
		NSArray *colorComponents = [hexString componentsSeparatedByString:@":"];
		CGFloat alpha = (colorComponents.count == 2) ? [[colorComponents lastObject] floatValue] / 100 : 1.0;
		hexString = [NSString stringWithFormat:@"%@%02X", [colorComponents firstObject], int(alpha * 255.0)];
	}

	unsigned hex = 0;
	[[NSScanner scannerWithString:hexString] scanHexInt:&hex];

	CGFloat r = ((hex & 0xFF000000) >> 24) / 255.0;
	CGFloat g = ((hex & 0x00FF0000) >> 16) / 255.0;
	CGFloat b = ((hex & 0x0000FF00) >> 8) / 255.0;
	CGFloat a = (useAlpha) ? ((hex & 0x000000FF) >> 0) / 255.0 : 0xFF;

	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}
