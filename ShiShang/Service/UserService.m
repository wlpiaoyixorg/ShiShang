//
//  UserService.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#define URL_LOGIN @"restful/customer/login"
#define URL_REGESTER @"restful/customer/register"
#import "UserService.h"
#import "Common+Expand.h"


@implementation UserService

-(void) loginWithUserName:(NSString*) userName password:(NSString*) password success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{
    id<NetWorkHTTPDelegate> nwh = [Common getNetWorkImpl];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_LOGIN];
    [ConfigManage setUserName:userName];
    [ConfigManage setPassword:password];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        data = [@{@"id": @101,@"loginName": @"liudonghua",@"name":@"liudonghua",@"plainPassword": @"",@"password":@"2c5f1aef26f38abe8714536a6ba0164e2e680689",@"salt":@"39190ed6f235bf04",@"roles":@"customer",@"registerDate":@"2013-11-11 22:26:17",@"phoneNumber": @"110",@"voucher": @2,@"balance": @4,@"totalConsumed": @0.0} JSONRepresentation];
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        NSObject *result;
        if ([self isSuccessResult:&result data:data]) {
            NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
            [ConfigManage setConfigValueByUser:[result JSONRepresentation] Key:key];
        }
        if (success) {
            EntityUser *user = [EntityUser entityWithJson:(NSDictionary*)result];
            success(user,userInfo);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        CallBackNetWorkHTTP faild = [userInfo objectForKey:@"faild"];
        NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
        NSString *cache = [ConfigManage getConfigValueByUser:key];
        if ([NSString isEnabled:cache]) {
            EntityUser *user = [EntityUser entityWithJson:[cache JSONValue]];
            success(user,userInfo);
        }else{
            faild(data,userInfo);
        }
        
    }];
    [nwh requestPOST:@{@"username":userName,@"password":password}];
}

-(void) regesiterWithUser:(EntityUser*) user success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{
    id<NetWorkHTTPDelegate> nwh = [Common getNetWorkImpl];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,@"restful/product/get?version_id=1&userID=101&shopID=1"];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        NSObject *result;
        if ([self isSuccessResult:&result data:data]) {
            NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
            [ConfigManage setConfigValueByUser:[result JSONRepresentation] Key:key];
        }
        if (success) {
            success(result,userInfo);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        CallBackNetWorkHTTP faild = [userInfo objectForKey:@"faild"];
        NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
        NSString *cache = [ConfigManage getConfigValueByUser:key];
        if ([NSString isEnabled:cache]) {
            success([cache JSONValue],userInfo);
        }else{
            faild(data,userInfo);
        }
        
    }];
    [nwh requestPOST:[user toJson]];
    
}

@end
