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

## Code Organization
Once an interesting method to hook has been found, we have to write code to hook it, and this code needs to be organized.
- If your method comes from a new class that is not yet being hooked, create a new group in Xcode hierarchy
- Inside this new group, copy the dumped header, and create two files : `<yourClass>Hook.h` and `<yourClassHook.m`
- Inside the `<yourClassHook.h` header, import the dumped header, define the orig methods and replacement methods prototypes.
- Inside the `<yourClassHook.m`, define the replacement methods, and add a constructor called `do_hooks()` that hooks the target methods.

At the moment, the `main.m` file is pretty useless, but confirms our tweak is injected and running, so it is always useful to have.
