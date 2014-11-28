//
//  BaseService.h
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWork.h"

@interface BaseService : NSObject
-(BOOL) isSuccessResult:(NSObject**) result data:(NSObject*) data;
@end
