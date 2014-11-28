//
//  UserService.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#define LOGIN @"/restful/customer/login"

#import "UserService.h"
#import "Common+Expand.h"



@implementation UserService

-(void) loginWithUserName:(NSString*) userName password:(NSString*) password success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{
    id<NetWorkHTTPDelegate> nwh = [Common getNetWorkImpl];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,LOGIN];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh requestGET:@{@"userName":userName,@"password":password}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        NSString *url = [userInfo objectForKey:@"url"];
        NSDictionary *json = @{@"a":@"k"};
        NSObject *result;
        if ([self isSuccessResult:&result data:json]) {
        }else{
            result = nil;
        }
        if (success) {
            success(result,userInfo);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        CallBackNetWorkHTTP faild = [userInfo objectForKey:@"faild"];
        NSString *url = [userInfo objectForKey:@"url"];
        NSDictionary *json = @{@"a":@"k"};
        NSObject *result;
        if ([self isSuccessResult:&result data:json]) {
            
        };
        if (faild) {
            faild(result,userInfo);
        }
        
    }];
    [nwh startAsynRequest];
}

@end
