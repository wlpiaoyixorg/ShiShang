//
//  ManagerHeadCell.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/21.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ManagerHeadCell.h"

@interface ManagerHeadCell()

@property (strong, nonatomic) IBOutlet UILabel *lableFoodType;

@end

@implementation ManagerHeadCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) setFoodType:(NSString *)foodType{
    _foodType = foodType;
    _lableFoodType.text = _foodType;
}

@end
