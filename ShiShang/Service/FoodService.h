//
//  FoodService.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BaseService.h"
#import "FDEntityManager.h"
#import "EntityFood.h"


extern NSString *const KeyFoodProductVersion;

@interface FoodService : BaseService

@property (nonatomic,readonly) FDEntityManager *em;

-(void) queryAllFoodForSuccess:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild;
-(NSArray*) queryAllFoodFromDataBase;

-(void) presistType:(NSString*) type success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild;
-(void) mergeType:(NSString*) type oldType:(NSString*) oldType  success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild;
-(void) removeType:(NSString*) type success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild;

-(void) presistFood:(EntityFood*) food success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild;
-(void) mergeFood:(EntityFood*) type oldType:(NSString*) oldType  success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild;
-(void) removeFood:(EntityFood*) food success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild;




@end
