//
//  Common+Expand.h
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-5.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//


#define BASEURL @"http://115.29.186.152"

#import <Foundation/Foundation.h>
#import "Common.h"
#import "ConfigManage+Expand.h"

@interface Common(Expand)
+(id) getNetWorkImpl;
+(void) setRootController:(UIViewController*) c window:(UIWindow*) window;
+(id) getEntityManger;
@end
