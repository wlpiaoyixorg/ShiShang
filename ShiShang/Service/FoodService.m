//
//  FoodService.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "FoodService.h"
#import "Common+Expand.h"
#import "EntityFood.h"

@implementation FoodService
-(id) init{
    if (self = [super init]) {
        self->_em = [Common getEntityManger];
    }
    
    EntityFood *food = [EntityFood entityWithJson:@{
                                                    KeyFoodId:@1,
                                                    KeyFoodName:@"萝卜",
                                                    KeyFoodPrice:@2.1,
                                                    KeyFoodPicturePath:@"static/pic/a.jpg",
                                                    KeyFoodAmount:@20,
                                                    KeyFoodType:@"vegetable",
                                                    KeyFoodStatus:SALE_PREPARED
                                                    }];
    EntityFood *food2 = [EntityFood entityWithJson:@{
                                                     KeyFoodId:@2,
                                                     KeyFoodName:@"白菜",
                                                     KeyFoodPrice:@1,
                                                     KeyFoodPicturePath:@"static/pic/a.jpg",
                                                     KeyFoodAmount:@10,
                                                     KeyFoodType:@"vegetable",
                                                     KeyFoodStatus:SALE_PREPARED
                                                     }];
    EntityFood *food3 = [EntityFood entityWithJson:@{
                                                     KeyFoodId:@3,
                                                     KeyFoodName:@"猪肉",
                                                     KeyFoodPrice:@6.6,
                                                     KeyFoodPicturePath:@"static/pic/a.jpg",
                                                     KeyFoodAmount:@10,
                                                     KeyFoodType:@"meat",
                                                     KeyFoodStatus:SALE_PREPARED
                                                     }];
    for (EntityFood *f in [self queryAllFood]) {
        [_em remove:f];
    }
    [_em persist:food];
    [_em persist:food2];
    [_em persist:food3];
    return self;
}
-(NSArray*) queryAllFood{
    NSString *sql = @"select * from EntityFood ef";
    return [_em queryBySql:sql Clazz:[EntityFood class] Params:nil];
}
@end
