//
//  FGInjector.m
//  LogOut
//
//  Created by Federico Gasperini on 06/06/2020.
//  Copyright © 2020 Federico Gasperini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGInjector.h"

@implementation FGInjector

static void __attribute__((constructor)) initialize(void) {
    NSLog(@"Injection started");
}

@end
