//
//  LOInjector.m
//  LogOut
//
//  Created by Federico Gasperini on 06/06/2020.
//  Copyright © 2020 Federico Gasperini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LOInjector.h"
#import <LogOut/LogOut-Swift.h>

@implementation LOInjector

static LogRouter* stdoutReader = nil;
static LogRouter* stderrReader = nil;

static void __attribute__((constructor)) initialize(void) {
    [LOLogger log:@"Injection started"];

    WebSocketSink* wss = [[WebSocketSink alloc] init];
    stdoutReader = [[LogRouter alloc] init];
    stdoutReader.logSink = wss;
    [stdoutReader startOn:STDOUT_FILENO];

    wss = [[WebSocketSink alloc] init];
    stderrReader = [[LogRouter alloc] init];
    stderrReader.logSink = wss;
    [stderrReader startOn:STDERR_FILENO];
}

@end
