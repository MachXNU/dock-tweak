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

static void (*setLabelOrig)(id, SEL, id, bool);

void setLabelHook(id self, SEL _cmd, id arg1, bool arg2) {
    NSLogf("[+] Replacement method called with arg1 : %@ and arg2 : %d\n", arg1, arg2);
    
    setLabelOrig(self, _cmd, @"pwned", arg2);
}

// Entry point
__attribute__((constructor))
static void do_hooks() {
    init_log_file(LOGFILE);
    NSLogf("[+] Hello world from Dock tweak\n");
    
    MSHookMessageEx(objc_getClass("Tile"), @selector(setLabel:stripAppSuffix:), (IMP)&setLabelHook, (IMP *)&setLabelOrig);
}
