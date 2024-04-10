//
//  log.c
//  change-label
//
//  Created by Jb on 10/04/2024.
//

#include <stdio.h>
#include <stdarg.h>
#include "log.h"

FILE *log_file;

// Initialize the log file
void init_log_file(const char *filename) {
    log_file = fopen(filename, "a");
    if (log_file == NULL) {
        printf("Error opening log file!\n");
    }
}

// Write log message to the log file
void lprintf(const char *format, ...) {
    
    init_log_file(LOGFILE);
    
    if (log_file == NULL) {
        printf("Log file not initialized!\n");
        return;
    }

    va_list args;
    va_start(args, format);

    vfprintf(log_file, format, args);
    fflush(log_file);

    va_end(args);
    
    close_log_file();
}

// Close the log file
void close_log_file() {
    if (log_file != NULL) {
        fclose(log_file);
    }
}

