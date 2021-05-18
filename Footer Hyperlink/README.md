## Creating a Footer Hyperlink

1. Create your group cell using the example cell. The `id` key should be unique to this cell, more on the importance of that later:

```xml
<dict>
 	<key>cell</key>
 	<string>PSGroupCell</string>
 	<key>footerCellClass</key>
 	<string>PSFooterHyperlinkView</string>
 	<key>headerFooterHyperlinkButtonTitle</key>
 	<string>This is a test footer with a link. Tap here.</string>
 	<key>footerHyperlinkRange</key>
 	<string>{35, 8}</string>
 	<key>footerHyperlinkAction</key>
 	<string>linkTapped:</string>
	<key>id</key>
	<string>UNIQUE_FOOTER_HYPERLINK</string>
</dict>
```

| Key Cheat Sheet | Purpose |
| --------------- | ------- |
| **footerCellClass** | Sets the cell class of the footer view. In our case we set it the `PSFooterHyperlinkView`. |
| **headerFooterHyperlinkButtonTitle** | Sets the text of the footer view. This is interchangeable with the `footerText` key. |
| **footerHyperlinkRange** | Sets the range of the hyperlink using `NSRange`. First value is the location of the link, the second value is the length of the link. |
| **footerHyperlinkAction** | Sets the method that will be called when the hyperlink is tapped. |

2. Add your `footerHyperlinkAction` method to your RootListController that opens your link:

```objc
-(void)linkTapped:(PSFooterHyperlinkView *)footerHyperlinkView {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.google.com/"] options:@{} completionHandler:nil];
}
```

3. You might notice the link doesn't do anything in its current state. We need to set the target which unfortunately cannot be done from the PList. We need to set the target at runtime in the specifiers method of your RootListController:

```objc
-(NSArray *)specifiers {
	if(!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		
		//Get the specifier and set the target property. Here is where the unique id is used:
		PSSpecifier *footerSpecifier = [self specifierForID:@"UNIQUE_FOOTER_HYPERLINK"];
		[footerSpecifier setProperty:[NSValue valueWithNonretainedObject:self] forKey:@"footerHyperlinkTarget"];
	}
	
	return _specifiers;
}
```

4. Done!

## Displaying the Link in your Preferences Pane

Don't like the link opening another app? You can use `SFSafariViewController` to display the URL in a Safari window within your preferences window.

1. Import `SafariServices` and add the `SFSafariViewControllerDelegate` to your RootListController header file:

```objc
#import <SafariServices/SafariServices.h>

@interface RootListController : PSListController <SFSafariViewControllerDelegate>
@end
```

2. In your `footerHyperlinkAction` method, create an instance of `SFSafariViewController`, set the delegate, and present the view controller:

```objc
-(void)linkTapped:(PSFooterHyperlinkView *)footerHyperlinkView {
	SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.google.com/"]];
	safariViewController.delegate = self;
	[self presentViewController:safariViewController animated:YES completion:nil];
}
```

5. Done!
