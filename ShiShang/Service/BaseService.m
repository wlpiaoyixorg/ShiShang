//
//  BaseService.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BaseService.h"
#import "JSON.h"


 NSString *KEY_STATUS = @"status";
 NSString *KEY_DATA = @"data";

 NSString *KEY_CODE = @"errorNo";
 NSString *KEY_MESSAGE = @"errorMessage";


@implementation BaseService
-(BOOL) isSuccessResult:(NSObject**) result data:(NSObject*) data{
    id json = [((NSString*)data) JSONValue];
    if (json) {
        NSNumber *erroNo = [json valueForKey:KEY_CODE];
        *result = [NSMutableDictionary new];
        if (erroNo) {
            [*result setValue:erroNo forKey:KEY_STATUS];
            [*result setValue:[json valueForKey:@"errorMessage"] forKey:KEY_MESSAGE];
            return false;
        }else{
            [*result setValuesForKeysWithDictionary:json];
            return true;
        }
    }
    return false;
}

@end
