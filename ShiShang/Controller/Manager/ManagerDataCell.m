//
//  ManagerDataCell.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/21.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ManagerDataCell.h"
@interface ManagerDataCell()
@property (strong, nonatomic) IBOutlet UILabel *lableFoodName;
@end

@implementation ManagerDataCell

- (void)awakeFromNib {
    // Initialization code
}
-(void) setFood:(EntityFood *)food{
    _food = food;
    _lableFoodName.text = _food.name;
}

@end
