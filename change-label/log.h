//
//  log.h
//  change-label
//
//  Created by Jb on 10/04/2024.
//

#ifndef log_h
#define log_h

#include <stdio.h>

#define LOGFILE "/Users/jb/log_dock.txt"

void init_log_file(const char *filename);
void lprintf(const char *format, ...);
void close_log_file(void);
#endif /* log_h */
