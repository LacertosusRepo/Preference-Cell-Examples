-(NSArray *)specifiers {
	if(!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

		PSSpecifier *footerSpecifier = [self specifierForID:@"TEST_FOOTER_HYPERLINK"];
		[footerSpecifier setProperty:[NSValue valueWithNonretainedObject:self] forKey:@"footerHyperlinkTarget"];
	}

	return _specifiers;
}

-(void)linkTapped:(PSFooterHyperlinkView *)footerHyperlinkView {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://lacertosusrepo.github.io/"] options:@{} completionHandler:nil];

	//OR

	SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://lacertosusrepo.github.io/"]];
	safariViewController.delegate = self;
	[self presentViewController:safariViewController animated:YES completion:nil];
}
