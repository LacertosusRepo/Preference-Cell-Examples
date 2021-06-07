## Creating a Footer Hyperlink

1. Create your group cell using the example cell. The `id` key should be unique to this cell allowing us to identify this group cell easily:

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

| Key | Type | Purpose |
| ----| ---- | ------- |
| **footerCellClass** | string<br>*class* | Sets the class of the footer view. In our case we set it the `PSFooterHyperlinkView`. |
| **headerFooterHyperlinkButtonTitle** | string | Sets the text of the footer view. This is interchangeable with the `footerText` key. |
| **footerHyperlinkRange** | range<br>*{location, length}* | Sets the range of the hyperlink using a `NSRange` in the form of a string. First value is the location of the link, the second value is the length of the link. |
| **footerHyperlinkAction** | string<br>*selector* | Sets the method that will be called when the hyperlink is tapped. |

2. Add the method you set for the `footerHyperlinkAction` key to your RootListController along with the code to open your link:

```objc
-(void)linkTapped:(PSFooterHyperlinkView *)footerHyperlinkView {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
}
```

3. You might notice the link doesn't do anything in its current state. We need to set the target which unfortunately cannot be done from the PList. In this last step we need to set the target at runtime in the specifiers method of your RootListController:

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

## Displaying the Link in your Preferences Pane
*Don't like the link opening the Safari app? You can use `SFSafariViewController` to display the URL in a Safari window within your preferences.*

1. Import `SafariServices` and add the `SFSafariViewControllerDelegate` to your RootListController header file:

```objc
#import <SafariServices/SafariServices.h>

@interface RootListController : PSListController <SFSafariViewControllerDelegate>
@end
```

2. Then in your `footerHyperlinkAction` method create an instance of `SFSafariViewController`, set the delegate, and present the view controller:

```objc
-(void)linkTapped:(PSFooterHyperlinkView *)footerHyperlinkView {
	SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/LacertosusRepo"]];
	safariViewController.delegate = self;
	[self presentViewController:safariViewController animated:YES completion:nil];
}
```
