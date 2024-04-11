#  macOS Dock Tweak

This tweak replaces all icons in the Dock by a custom one.\
_At the moment, all icons are replaced by the same icon. Better theming is in the plans._

![Alt text](Images/dock-with-only-finder-icons.png "macOS Ventura VM with all Dock icons replaced by the Finder icon")

## How it works
Dumping headers for `/System/Library/CoreServices/Dock.app` reveals several interesting functions.\
Notably : 
- in `Tile.h`, hooking the method `- (void)setLabel:(id)arg1 stripAppSuffix:(_Bool)arg2;` allows us to replace the label with any text we want.
- in `DOCKTileLayer`, hooking the method `- (void)_setImage:(id)arg1;` allows us to set a custom icon. We can create one manually via `CGImage` (and not `NSImage`, because this causes the Dock to crash with the message `NSApplication initialized in the Dock`). At the moment, the icon is created from a `.png` file, but it would probably be much better to generate one from a `.icns` file instead.\
- the `Calendar.app` is a bit different because its icon is being (partially) generated at runtime to display the date on it. As a result, its icon is not being replaced when hooking the `- (void)_setImage:(id)arg1;` method. Instead, we can brutally prevent the top layer from appearing by disabling calls to `- (void)_setReplacementExtraImage:(id)arg1;`. This is of course far from ideal, and cannot be considered a viable solution for the future.
