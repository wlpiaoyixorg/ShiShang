//
//  HeaderView.m
//  Data
//
//  Created by torin on 14/11/18.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView()
@property(nonatomic,weak) UILabel *leftLabel;
@property(nonatomic,weak) UILabel *rightLabel;

@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)setupUI
{
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:leftLabel];
    self.leftLabel = leftLabel;
    
    UILabel *rightLabel = [[UILabel alloc] init];
    leftLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:rightLabel];
    self.rightLabel = rightLabel;
}

-(void)setOrderNo:(NSString *)orderNo
{
    _orderNo = orderNo;
    self.leftLabel.text = orderNo;
}

-(void)setDateTime:(NSString *)dateTime
{
    _dateTime = dateTime;
    self.rightLabel.text = dateTime;
}


-(void)layoutSubviews
{
    
    [super layoutSubviews];
    CGFloat margin = 15;
    CGFloat w = [UIScreen mainScreen].applicationFrame.size.width;
    CGRect rect = self.frame;
    rect.origin.x = margin;
    rect.size.width = w - margin * 2;
    self.frame = rect;
    
    CGFloat LabelW = 150.0;
//    CGFloat temp  = w - margin * 2 - LabelW;
//    CGFloat labelX = w - temp + margin * 2;
    self.leftLabel.frame = CGRectMake(0, 0, LabelW, 25);
    
    self.rightLabel.frame = CGRectMake(LabelW, 0, LabelW, 25);
}

@end
