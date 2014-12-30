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
#import "HttpUtilRequest.h"

@implementation UserService
-(void) excuteLoginSuccess:(CallBackHttpUtilRequest) success json:(NSDataResult*) resulte {
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
-(void) loginWithUserName:(NSString*) userName password:(NSString*) password success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_LOGIN];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if ([self isSuccessResult:&result data:data]) {
            NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
            [ConfigManage setConfigValueByUser:data Key:key];
        }
        [self excuteLoginSuccess:success json:result];
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
        NSDictionary *cache = [ConfigManage getConfigValueByUser:key];
        NSDataResult *result;
        if ([NSString isEnabled:cache]&&[self isSuccessResult:&result data:cache]) {
            [self excuteLoginSuccess:success json:result];
        }else{
            faild(data,userInfo);
            [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
        }
        
    }];
    [nwh requestPOST:@{@"loginName":userName,@"plainPassword":password}];
}

-(void) exitLogin{
    [ConfigManage setLoginUser:nil];
    [ConfigManage setPassword:nil];
    
}

-(void) regesiterWithUser:(EntityUser*) user success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_REGESTER];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
    
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
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
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        NSString *key = KEY_CACHE_HTTP_UEL(URL_LOGIN);
        NSString *cache = [ConfigManage getConfigValueByUser:key];
        NSDataResult *result;
        if ([NSString isEnabled:cache]&&[self isSuccessResult:&result data:[cache JSONValue]]) {
            success(result.data,userInfo);
        }else{
            faild(data,userInfo);
            [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
        }
        
    }];
    [nwh requestPOST:[user toJson]];
    
}

-(int) smsVerificationWithPhone:(NSString*) phone success:(CallBackHttpUtilRequest) success{
    
    [Utils showLoading:@"短信发送中..."];
    id<HttpUtilRequestDelegate> nwh = [HttpUtilRequest new];
    [nwh setHttpEncoding:NSUTF8StringEncoding];
    NSString *url = @"http://106.ihuyi.com/webservice/sms.php?method=Submit";
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            success(nil,nil);
        }
        
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        [Utils showAlert:NSLocalizedString(@"net_faild", nil) title:nil];
    }];
    int num = random()%1000000;
    NSString *content = [NSString stringWithFormat:NSLocalizedString(@"regesit_SMS_verification", ),num];
    [nwh requestPOST:@{@"account":@"cf_shang",@"password":@"20140818js",@"mobile":phone,@"content":content}];
    return num;
}

@end
