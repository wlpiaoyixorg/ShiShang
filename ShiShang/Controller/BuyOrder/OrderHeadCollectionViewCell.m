//
//  OrderHeadCollectionViewCell.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-15.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "OrderHeadCollectionViewCell.h"
#import "EntityFood.h"
@interface OrderHeadCollectionViewCell()
@property (strong, nonatomic) IBOutlet UILabel *lableCategory;
@end

@implementation OrderHeadCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void) setParam:(id)value forKey:(NSString *)key{
    if (key&&[key isEqualToString:KeyFoodType]) {
        _lableCategory.text = value;
    }
}
-(void) setParams:(NSDictionary*) json{
    for (NSString *key in [json allKeys]) {
        id value = [json objectForKey:key];
        [self setParam:value forKey:key];
    }
}

@end
