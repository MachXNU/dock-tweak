//
//  main.c
//  dock-tweak
//
//  Created by Jb on 10/04/2024.
//

#include <stdio.h>
#include "substrate.h"
#include "log.h"
#include <Foundation/Foundation.h>
#include "Tile.h"
#include "DOCKTileLayer.h"
#include <CoreGraphics/CGImage.h>
#import <AppKit/AppKit.h>

static void (*setLabelOrig)(id, SEL, id, bool);
static void (*setReplacementAppImageOrig)(id, SEL, id); //apparently never called

static id (*addNamedImageLayerOrig)(id, SEL, id, id, bool); //apparently never called
static void (*_setReplacementExtraImageOrig)(id, SEL, id);
static void (*_setImageOrig)(id, SEL, id);

void setLabelHook(id self, SEL _cmd, id arg1, bool arg2) {
#if VERBOSE
    NSLogf("[+] [setLabelHook] called with arg1 : %@ and arg2 : %d\n", arg1, arg2);
#endif

    setLabelOrig(self, _cmd, @"pwned", arg2);
}

void setReplacementAppImageHook(id self, SEL _cmd, id arg1){
#if VERBOSE
    NSLogf("[+] [setReplacementAppImageHook] called with arg1 : %@\n", arg1);
#endif
    
    setReplacementAppImageOrig(self, _cmd, arg1);
}

id addNamedImageLayerHook(id self, SEL _cmd, id arg1, id name, bool atBottom){
    id result = addNamedImageLayerHook(self, _cmd, arg1, name, atBottom);
    
    NSLogf("[+] [addNamedImageLayerHook] called with arg1 : %@, name : %@, atBottom : %d\nReturned %@\n", arg1, name, atBottom, result);
    
    return result;
}

void _setReplacementExtraImageHook(id self, SEL _cmd, id arg1){
#if VERBOSE
    NSLogf("[+] [_setReplacementExtraImage] called with arg1 : %@\n", arg1);
#endif
    //_setReplacementExtraImageOrig(self, _cmd, arg1);
}

void _setImageHook(id self, SEL _cmd, id arg1){
#if VERBOSE
    NSLogf("[+] [_setImageHook] called with arg1 : %@\n", arg1);
#endif

    CGImageRef imageRef = (__bridge CGImageRef)arg1;
    
#if VERBOSE
    NSLogf("[+] Apparently got a CGImageRef %p : %dx%d\n", imageRef, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
#endif
    
    // Load the new image from a PNG file
    NSURL *newImageURL = [NSURL fileURLWithPath:@"/Users/jb/FinderIcon.png"];
    CGImageSourceRef newImageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)newImageURL, NULL);
    CGImageRef newCGImage = CGImageSourceCreateImageAtIndex(newImageSource, 0, NULL);

    // Get the width, height, and other properties from the original CGImage
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    _setImageOrig(self, _cmd, (__bridge id)(newCGImage));
}

// Entry point
__attribute__((constructor))
static void do_hooks() {
    init_log_file(LOGFILE);
    NSLogf("[+] Hello world from Dock tweak\n");
    
    MSHookMessageEx(objc_getClass("Tile"), @selector(setLabel:stripAppSuffix:), (IMP)&setLabelHook, (IMP *)&setLabelOrig);
    
    MSHookMessageEx(objc_getClass("Tile"), @selector(setReplacementAppImage:), (IMP)&setReplacementAppImageHook, (IMP *)&setReplacementAppImageOrig);
    
    MSHookMessageEx(objc_getClass("DOCKTileLayer"), @selector(_setImage:), (IMP)&_setImageHook, (IMP *)&_setImageOrig);
    
    MSHookMessageEx(objc_getClass("DOCKTileLayer"), @selector(addNamedImageLayer:name:atBottom:), (IMP)&addNamedImageLayerHook, (IMP *)&addNamedImageLayerOrig);
    
    MSHookMessageEx(objc_getClass("DOCKTileLayer"), @selector(_setReplacementExtraImage:), (IMP)&_setReplacementExtraImageHook, (IMP *)&_setReplacementExtraImageOrig);
    
}
