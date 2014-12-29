//
//  OrderCollectionViewCell.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-13.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "OrderCollectionViewCell.h"
#import "AsyncImageView.h"
#import "Common+Expand.h"
#import "EntityFood.h"




@interface OrderCollectionViewCell()
@property (strong, nonatomic) IBOutlet UILabel *lableName;
@property (strong, nonatomic) IBOutlet UILabel *lablePrice;
@property (strong, nonatomic) IBOutlet AsyncImageView *imageViewOrder;
@end
@implementation OrderCollectionViewCell

- (void)awakeFromNib {
}
-(void) setFood:(EntityFood *)food{
    _food = food;
    _imageViewOrder.imageUrl = _food.pricturePath;
    _lableName.text = _food.name;
    _lablePrice.text = [NSString stringWithFormat:@"￥%@",_food.price.stringValue];
    
    
    [_lableName automorphismHeight];
    CGRect r = _lableName.frame;
    r.origin.y = self.frame.size.height-r.size.height-_lablePrice.frame.size.height;
    _lableName.frame = r;
}
-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGRect r = _imageViewOrder.frame;
    r.origin.x = r.origin.y = 0;
    r.size = frame.size;
    _imageViewOrder.frame = r;
    
    r = _lablePrice.frame;
    r.size.width = frame.size.width;
    r.origin.y = frame.size.height-r.size.height;
    _lablePrice.frame = r;
    
    r = _lableName.frame;
    r.size.width = frame.size.width;
    r.origin.y = frame.size.height-r.size.height-_lablePrice.frame.size.height;
    _lableName.frame = r;
}

@end
