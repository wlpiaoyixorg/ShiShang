//
//  BuyOrderCartView.h
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-15.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "PopUpMovableView.h"

@interface BuyOrderCartView : PopUpMovableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) NSString *deskCode;
@property (nonatomic,readonly) NSNumber *totalPrice;
-(void) reloadData;
@end
