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

typedef enum{
    foodAutoQuery,
    foodNetQuery,
    foodDatabaseQuery
    
} EnumFoodQueryType;


@interface FoodService : BaseService

@property (nonatomic,readonly) FDEntityManager *em;

-(void) queryAllFoodByType:(EnumFoodQueryType) types success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild;

@end
