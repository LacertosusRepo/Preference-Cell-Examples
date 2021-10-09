# Group Cell Header With Button
`PSGroupCell` with a button at the opposite of the header title

## Preview
<figure>
    <img src="preview.jpeg" alt="Preview" width=500 />
    <figcaption>Preview of the PSGroupCell</figcaption>
</figure>

## Features
- Native look
- Works with RTL
- Easily usable in a `.plist`

## Usage
```plist
<dict>
    <key>cell</key>
    <string>PSGroupCell</string>
    <key>headerCellClass</key>
    <string>XXXRefreshableHeaderCell</string>
    <key>label</key>
    <string>My label</string>
    <key>actionLabel</key>
    <string>Refresh</string>
    <key>action</key>
    <string>buttonAction:</string>
</dict>
```
You need to implement the method called by the button:
```objective-c
// MyController.m

- (void)buttonAction:(id)sender {
    // Actions after button triggering
    // Note that the ':(id)sender' part
    // isn't mandatory if you omit the ':'
    // when declaring the action in the plist
}
```

## Known issues
- The cell will disappear if the table or one of its section is reloaded. It's an issue affecting every subclass of `PSTableCell <PSHeaderFooterView>`. See issue [here](https://github.com/hbang/libcephei/issues/53).
