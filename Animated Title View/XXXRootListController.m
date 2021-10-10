- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	// Create view and set as titleView of your navigation bar
	// Set the title and the minimum scroll offset before starting the animation
	if (!self.navigationItem.titleView) {
		LBMAnimatedTitleView *titleView = [[LBMAnimatedTitleView alloc] initWithTitle:@"Title" minimumScrollOffsetRequired:100];
		self.navigationItem.titleView = titleView;
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  	// Send scroll offset updates to view
	if ([self.navigationItem.titleView respondsToSelector:@selector(adjustLabelPositionToScrollOffset:)]) {
		[(XXXAnimatedTitleView *)self.navigationItem.titleView adjustLabelPositionToScrollOffset:scrollView.contentOffset.y];
	}
}
