//
//  BaseService.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService
-(BOOL) isSuccessResult:(NSObject**) result data:(NSObject*) data{
    if ([data valueForKey:@"errorNo"]) {
        *result = [NSMutableDictionary new];
        [*result setValue:[data valueForKey:@"erroNo"] forKey:@"erroNo"];
        [*result setValue:[data valueForKey:@"errorMessage"] forKey:@"errorMessage"];
        return false;
    }else{
        *result = data;
        return true;
    }
}

@end
