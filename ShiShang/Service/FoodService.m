//
//  FoodService.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//


#define URL_FOODGET @"restful/product/get"

#import "FoodService.h"
#import "Common+Expand.h"
#import "EntityFood.h"

@implementation FoodService
-(id) init{
    if (self = [super init]) {
        self->_em = [Common getEntityManger];
    }
    return self;
}
-(void) updateData:(NSDictionary*) result{
    
}
-(void) queryAllFoodByType:(EnumFoodQueryType) types success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{
    id<NetWorkHTTPDelegate> nwh = [Common getNetWorkImpl];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_FOODGET];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        NSObject *result;
        if ([self isSuccessResult:&result data:data]) {
            if (success) {
                NSArray *dics = [result valueForKey:@"foods"];
                [self.em beginTransation];
                for (NSDictionary *dic in dics) {
                    EntityFood *food = [EntityFood entityWithJson:dic];
                    [self.em merge:food];
                }
                [self.em commitTarnsation];
            }
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        CallBackNetWorkHTTP faild = [userInfo objectForKey:@"faild"];
        NSString *key = KEY_CACHE_HTTP_UEL(URL_FOODGET);
        NSString *cache = [ConfigManage getConfigValueByUser:key];
        if ([NSString isEnabled:cache]) {
            success([cache JSONValue],userInfo);
        }else{
            faild(data,userInfo);
        }
        
    }];
    [nwh requestGET:@{@"userID":[[ConfigManage getLoginUser].keyId stringValue],@"shopID":@"1"}];
    
}
@end
