//
//  FoodService.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BaseService.h"
#import "FDEntityManager.h"

@interface FoodService : BaseService

@property (nonatomic,readonly) FDEntityManager *em;

-(NSArray*) queryAllFood;

@end
