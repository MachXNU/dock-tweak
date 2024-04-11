//
//  DOCKTileLayerHook.h
//  dock-tweak
//
//  Created by Jb on 11/04/2024.
//

#ifndef DOCKTileLayerHook_h
#define DOCKTileLayerHook_h

#import "DOCKTileLayer.h"
#import <Foundation/Foundation.h>
#include <CoreGraphics/CGImage.h>
#import <AppKit/AppKit.h>
#import "log.h"
#import "substrate.h"

// Orig methods
static id (*addNamedImageLayerOrig)(id, SEL, id, id, bool); //apparently never called
static void (*_setReplacementExtraImageOrig)(id, SEL, id);
static void (*_setImageOrig)(id, SEL, id);

// Replacement methods
id addNamedImageLayerHook(id self, SEL _cmd, id arg1, id name, bool atBottom);
void _setReplacementExtraImageHook(id self, SEL _cmd, id arg1);
void _setImageHook(id self, SEL _cmd, id arg1);
#endif /* DOCKTileLayerHook_h */
