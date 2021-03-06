//
//  OrdersService.m
//  ShiShang
//
//  Created by torin on 14/12/27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "OrdersService.h"
#import "Common+Expand.h"

#define URL_STATISGET @"/restful/order/get"

@implementation OrdersService
- (void)queryOrdersForSuccess:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild
{
    id<HttpUtilRequestDelegate> nwh = [Utils getHttpUtilRequest];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_STATISGET];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        //        NSDataResult *result;
        //        if([self isSuccessResult:&result data:data]){
        //            success(result.data,nil);
        //        }
        success(data,nil);
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
    }];
    
    NSDictionary *dict = @{@"userID":[[ConfigManage getLoginUser].keyId stringValue],@"shopID":[[ConfigManage getLoginUser].shopId stringValue]};
    [nwh requestGET:dict];
}
@end
