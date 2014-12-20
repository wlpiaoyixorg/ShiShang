//
//  FooterView.m
//  Data
//
//  Created by torin on 14/11/20.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "FooterView.h"

@interface FooterView()
@property(nonatomic,weak) UILabel *leftLabel;
@property(nonatomic,weak) UILabel *rightLabel;
@property(nonatomic,weak) UILabel *bottomLabel;
@property(nonatomic,weak) UIView *separatorView;
@end

@implementation FooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
//         self.backgroundColor = [UIColor redColor];
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
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:bottomLabel];
    self.bottomLabel = bottomLabel;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separatorView];
    self.separatorView = separatorView;
    
}

-(void)setAmount:(NSString *)amount
{
    _amount = amount;
    self.leftLabel.text = amount;
}

-(void)setPayable:(NSString *)payable
{
    _payable = payable;
    self.rightLabel.text = payable;
}

-(void)setDesc:(NSString *)desc
{
    _desc = desc;
    self.bottomLabel.text = desc;
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
    self.leftLabel.frame = CGRectMake(0, 0, LabelW, 25);
    
    self.rightLabel.frame = CGRectMake(LabelW, 0, LabelW, 25);
    
    self.bottomLabel.frame = CGRectMake(0, CGRectGetMaxY(self.leftLabel.frame)+10, 100, 25);
    
    self.separatorView.frame = CGRectMake(0, CGRectGetMaxY(self.bottomLabel.frame)+10, self.frame.size.width, 1);
}


@end
