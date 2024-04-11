//
//  log.c
//  change-label
//
//  Created by Jb on 10/04/2024.
//

#import <Foundation/Foundation.h>

NSString *logFilePath;

// Initialize the log file
void init_log_file(const char *filename) {
    logFilePath = [NSString stringWithUTF8String:filename];
    // Create an empty file at the specified path
    [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:nil attributes:nil];
}

// Write log message to the log file
void NSLogf(const char *format, ...) {
    va_list args;
    va_start(args, format);

    NSString *message = [[NSString alloc] initWithFormat:@(format) arguments:args];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    if (fileHandle == nil) {
        // Handle file not found error
        NSLog(@"Error: Log file not found.");
        return;
    }

    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];

    va_end(args);
}
