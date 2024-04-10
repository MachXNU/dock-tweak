//
//  main.c
//  dock-tweak
//
//  Created by Jb on 10/04/2024.
//

#include <stdio.h>
#include "substrate.h"
#include "log.h"

// Entry point
__attribute__((constructor))
static void do_hooks() {
    lprintf("[+] Hello world from Dock tweak\n");
}
