//
//  Common+Expand.h
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-5.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//


#define BASEURL @"http://127.0.0.1"

#import <Foundation/Foundation.h>
#import "Common.h"
@interface Common(Expand)
+(id) getNetWorkImpl;
+(void) setRootController:(UIViewController*) c window:(UIWindow*) window;
+(id) getEntityManger;
@end
