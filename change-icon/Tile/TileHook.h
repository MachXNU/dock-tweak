//
//  TileHook.h
//  change-icon
//
//  Created by Jb on 11/04/2024.
//

#ifndef TileHook_h
#define TileHook_h

#import "Tile.h"

// Orig methods
static void (*setLabelOrig)(id, SEL, id, bool);
static void (*setReplacementAppImageOrig)(id, SEL, id); //apparently never called

// Replacement methods
void setLabelHook(id self, SEL _cmd, id arg1, bool arg2);
void setReplacementAppImageHook(id self, SEL _cmd, id arg1);
#endif /* TileHook_h */
