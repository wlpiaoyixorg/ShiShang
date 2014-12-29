//
//  OrdersService.m
//  ShiShang
//
//  Created by torin on 14/12/16.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "StatisticService.h"
#import "Common+Expand.h"

#define URL_STATISGET @"restful/order/getStatis"

@implementation StatisticService

- (void)queryStatisForSuccess:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-ddHH:mm:ss";
    NSString *curretnDate = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary *dict = @{@"userID":[[ConfigManage getLoginUser].keyId stringValue],@"shopID":[[ConfigManage getLoginUser].shopId stringValue],@"currentTime":curretnDate};
    [nwh requestGET:dict];
}
@end
