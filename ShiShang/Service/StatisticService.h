//
//  OrdersService.h
//  ShiShang
//
//  Created by torin on 14/12/16.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BaseService.h"

@interface StatisticService : BaseService
- (void)queryStatisForSuccess:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
@end
