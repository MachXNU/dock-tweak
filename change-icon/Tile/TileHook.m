//
//  TileHook.m
//  change-icon
//
//  Created by Jb on 11/04/2024.
//

#import <Foundation/Foundation.h>

#import "TileHook.h"
#import "substrate.h"
#import "log.h"

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

__attribute__((constructor))
static void hook_Tile() {
    MSHookMessageEx(objc_getClass("Tile"), @selector(setLabel:stripAppSuffix:), (IMP)&setLabelHook, (IMP *)&setLabelOrig);
    
    MSHookMessageEx(objc_getClass("Tile"), @selector(setReplacementAppImage:), (IMP)&setReplacementAppImageHook, (IMP *)&setReplacementAppImageOrig);
}
