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
-(void) excuteLoginSuccess:(CallBackNetWorkHTTP) success json:(NSDataResult*) resulte {
    if (success) {
        EntityUser *user  = nil;
        if (resulte&&resulte.code==200) {
            NSDictionary *json = (NSDictionary*)resulte.data;
            NSNumber *shopId = [[json objectForKey:@"shop"] objectForKey:@"id"];
            NSMutableDictionary *customer = [NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"customer"]];
            [customer setObject:shopId forKey:KeyUserShopId];
            if (customer) {
                user = [EntityUser entityWithJson:customer];
            }
        }
        [ConfigManage setLoginUser:user];
        success(user,nil);
    }
}
-(void) loginWithUserName:(NSString*) userName password:(NSString*) password success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{
    id<NetWorkHTTPDelegate> nwh = [Common getNetWorkImpl];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_LOGIN];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if ([self isSuccessResult:&result data:data]) {
            NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
            [ConfigManage setConfigValueByUser:data Key:key];
        }
        [self excuteLoginSuccess:success json:result];
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        CallBackNetWorkHTTP faild = [userInfo objectForKey:@"faild"];
        NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
        NSDictionary *cache = [ConfigManage getConfigValueByUser:key];
        NSDataResult *result;
        if ([NSString isEnabled:cache]&&[self isSuccessResult:&result data:cache]) {
            [self excuteLoginSuccess:success json:result];
        }else{
            faild(data,userInfo);
            [[PopUpDialogView initWithTitle:NSLocalizedString(@"popup_default_title", nil) message:NSLocalizedString(@"net_faild", nil) TargetView:[UIApplication sharedApplication].keyWindow delegate:nil cancelButtonTitle:NSLocalizedString(@"popup_default_confirm_name", nil) otherButtonTitles:nil] show];
        }
        
    }];
    [nwh requestPOST:@{@"loginName":userName,@"plainPassword":password}];
}

-(void) regesiterWithUser:(EntityUser*) user success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{
    id<NetWorkHTTPDelegate> nwh = [Common getNetWorkImpl];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_REGESTER];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
    
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if ([self isSuccessResult:&result data:data]) {
            NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
            [ConfigManage setConfigValueByUser:[result JSONRepresentation] Key:key];
        }
        if (success) {
            success(result.data,userInfo);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        CallBackNetWorkHTTP faild = [userInfo objectForKey:@"faild"];
        NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
        NSString *cache = [ConfigManage getConfigValueByUser:key];
        NSDataResult *result;
        if ([NSString isEnabled:cache]&&[self isSuccessResult:&result data:[cache JSONValue]]) {
            success(result.data,userInfo);
        }else{
            faild(data,userInfo);
            [[PopUpDialogView initWithTitle:NSLocalizedString(@"popup_default_title", nil) message:NSLocalizedString(@"net_faild", nil) TargetView:[UIApplication sharedApplication].keyWindow delegate:nil cancelButtonTitle:NSLocalizedString(@"popup_default_confirm_name", nil) otherButtonTitles:nil] show];
        }
        
    }];
    [nwh requestPOST:[user toJson]];
    
}

@end
