//
//  FoodService.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//




#define URL_FOODGET @"restful/product/get"
#define URL_FOODTYPEADD @"restful/product/add_type"
#define URL_FOODTYPEUPDATE @"restful/product/update_type"
#define URL_FOODTYPEDELETE @"restful/product/delete_type"
#define URL_FOODADD @"/restful/product/add"
#define URL_FOODUPDATE @"/restful/product/update"
#define URL_FOODDELETE @"/restful/product/delete"
#import "FoodService.h"
#import "Common+Expand.h"
#import "EntityFood.h"

static id synquery;

NSString *const KeyFoodProductVersion = @"KeyFoodProductVersion";

@implementation FoodService
+(void) initialize{
    synquery = [NSObject new];
}
-(id) init{
    if (self = [super init]) {
        self->_em = [Common getEntityManger];
    }
    return self;
}
-(BOOL) updateAllFood:(NSDictionary*) result{
    if (result) {
        NSNumber *shopId = [ConfigManage getLoginUser].shopId;
        NSString *versionKey = [NSString stringWithFormat:@"version_id_%d",shopId.intValue];
        NSString *versionId = [result valueForKey:@"version_id"];
        NSArray *dics = [result valueForKey:@"products"];
        NSString *configerVersionId = [ConfigManage getConfigValue:versionKey];
        if (![versionId isEqualToString:configerVersionId]) {
            [self.em excuSql:@"DELETE FROM EntityFood  where shopId = ?" Params:@[shopId]];
            [self.em beginTransation];
            for (NSDictionary *dic in dics) {
                EntityFood *food = [EntityFood entityWithJson:dic];
                [self.em persist:food];
            }
            [self.em commitTarnsation];
            [ConfigManage setConfigValue:configerVersionId Key:versionKey];
            return true;
        }
    }
    return false;
}
-(void) excuteQuerySuccess:(CallBackNetWorkHTTP) success result:(NSDictionary*) result {
    @synchronized(synquery){
        NSArray *datas = nil;
        if([self updateAllFood:result]){
            datas =  [self queryAllFoodFromDataBase];
        }
        if (success) {
            success (datas,nil);
        }
    }
    
}
-(void) queryAllFoodForSuccess:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{
    NSArray *datas = [self queryAllFoodFromDataBase];
    if (datas&&[datas count]) {
        if (success) {
            success (datas,nil);
        }
    }
    id<NetWorkHTTPDelegate> nwh = [Common getNetWorkImpl];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_FOODGET];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        if([self isSuccessResult:&result data:data]){
        }
        [self excuteQuerySuccess:success result:(NSDictionary*)result.data];
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        CallBackNetWorkHTTP faild = [userInfo objectForKey:@"faild"];
        NSArray *datas =  [self queryAllFoodFromDataBase];
        if (datas&&[datas count]) {
            success(datas,userInfo);
        }else{
            faild(data,userInfo);
            [[PopUpDialogView initWithTitle:NSLocalizedString(@"popup_default_title", nil) message:NSLocalizedString(@"net_faild", nil) TargetView:[UIApplication sharedApplication].keyWindow delegate:nil cancelButtonTitle:NSLocalizedString(@"popup_default_confirm_name", nil) otherButtonTitles:nil] show];
        }
    }];
    [nwh requestGET:@{@"userID":[[ConfigManage getLoginUser].keyId stringValue],@"shopID":[[ConfigManage getLoginUser].shopId stringValue]}];
}
-(NSArray*) queryAllFoodFromDataBase{
    NSNumber *shopId = [ConfigManage getLoginUser].shopId;
    if (!shopId) {
        return nil;
    }
    NSArray *datas =  [self.em queryBySql:@"select * from EntityFood f where f.shopId = ?" Clazz:[EntityFood class] Params:@[shopId]];
    return datas;
}


-(void) presistType:(NSString*) type success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{
    id<NetWorkHTTPDelegate> nwh = [Common getNetWorkImpl];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@&newType=%@",BASEURL,URL_FOODTYPEADD,[[ConfigManage getLoginUser].keyId stringValue],[[ConfigManage getLoginUser].shopId stringValue],type];
    [nwh setRequestString:url];
    EntityFood *food = [EntityFood new];
    food.keyId = @0;
    food.name = @"样品";
    food.price = @0;
    food.type = type;
    food.shopId = [ConfigManage getLoginUser].shopId;
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url,@"food":food}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        BOOL flag = false;
        if ([self isSuccessResult:&result data:data]) {
            flag = [self updateAllFood:(NSDictionary*)result.data];
        }
        if (success) {
            success(flag?@"":nil,nil);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [[PopUpDialogView initWithTitle:NSLocalizedString(@"popup_default_title", nil) message:NSLocalizedString(@"net_faild", nil) TargetView:[UIApplication sharedApplication].keyWindow delegate:nil cancelButtonTitle:NSLocalizedString(@"popup_default_confirm_name", nil) otherButtonTitles:nil] show];
    }];
    [nwh requestPOST:[food toJson]];
}

-(void) mergeType:(NSString*) type oldType:(NSString*) oldType  success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{
    id<NetWorkHTTPDelegate> nwh = [Common getNetWorkImpl];
    NSString *url = [NSString stringWithFormat:@"%@/%@?userID=%@&shopID=%@&oldType=%@&newType=%@",BASEURL,URL_FOODTYPEUPDATE,[[ConfigManage getLoginUser].keyId stringValue],[[ConfigManage getLoginUser].shopId stringValue],oldType,type];
    [nwh setRequestString:url];
    EntityFood *food = [EntityFood new];
    food.keyId = @0;
    food.name = @"样品";
    food.price = @0;
    food.type = type;
    food.shopId = [ConfigManage getLoginUser].shopId;
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url,@"food":food}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        NSDataResult *result;
        BOOL flag = false;
        if ([self isSuccessResult:&result data:data]) {
            flag = [self updateAllFood:(NSDictionary*)result.data];
        }
        if (success) {
            success(flag?@"":nil,nil);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [[PopUpDialogView initWithTitle:NSLocalizedString(@"popup_default_title", nil) message:NSLocalizedString(@"net_faild", nil) TargetView:[UIApplication sharedApplication].keyWindow delegate:nil cancelButtonTitle:NSLocalizedString(@"popup_default_confirm_name", nil) otherButtonTitles:nil] show];
    }];
    [nwh requestPUT:[food toJson]];
}

-(void) removeType:(NSString*) type success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{
    id<NetWorkHTTPDelegate> nwh = [Common getNetWorkImpl];
    NSString *url = [NSString stringWithFormat:@"%@/%@",BASEURL,URL_FOODTYPEDELETE];
    [nwh setRequestString:url];
    [nwh setUserInfo:@{@"success":success,@"faild":faild,@"url":url}];
    [nwh setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP success = [userInfo objectForKey:@"success"];
        if (success) {
            success(nil,nil);
        }
    }];
    [nwh setFaildCallBack:^(id data, NSDictionary *userInfo) {
        CallBackNetWorkHTTP faild = [userInfo objectForKey:@"faild"];
        faild(data,userInfo);
        [[PopUpDialogView initWithTitle:NSLocalizedString(@"popup_default_title", nil) message:NSLocalizedString(@"net_faild", nil) TargetView:[UIApplication sharedApplication].keyWindow delegate:nil cancelButtonTitle:NSLocalizedString(@"popup_default_confirm_name", nil) otherButtonTitles:nil] show];
    }];
    [nwh requestDELETE:@{@"userID":[ConfigManage getLoginUser].keyId.stringValue,@"shopID":[ConfigManage getLoginUser].shopId.stringValue,@"proType":type}];

}

-(void) presistFood:(EntityFood*) food success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{

}
-(void) mergeFood:(EntityFood*) type oldType:(NSString*) oldType  success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{
}
-(void) removeFood:(EntityFood*) food success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild{
}

@end
