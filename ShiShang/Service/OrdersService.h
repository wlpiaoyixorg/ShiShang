//
//  OrdersService.h
//  ShiShang
//
//  Created by torin on 14/12/27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BaseService.h"

@interface OrdersService : BaseService
- (void)queryOrdersForSuccess:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
@end
