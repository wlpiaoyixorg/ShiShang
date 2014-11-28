//
//  EntityFood.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/24.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityFood.h"
#import "Common+Expand.h"

NSString *const KeyFoodId = @"id";
NSString *const KeyFoodName = @"name";
NSString *const KeyFoodType = @"foodType";
NSString *const KeyFoodPrice = @"price";
NSString *const KeyFoodPicturePath = @"picturePath";
NSString *const KeyFoodStatus = @"foodStatus";
NSString *const KeyFoodGeneratedTime = @"generatedTime";
NSString *const KeyFoodDescriptionInfo = @"descriptionInfo";
NSString *const KeyFoodAmount = @"amount";

NSString *const SALE_PREPARED = @"SALE_PREPARED";

@implementation EntityFood
+(instancetype) entityWithJson:(NSDictionary*) json{
    EntityFood *ef = [EntityFood new];
    ef.keyId = [json objectForKey:KeyFoodId];
    ef.name = [json objectForKey:KeyFoodName];
    ef.type = [json objectForKey:KeyFoodType];
    ef.price = [json objectForKey:KeyFoodPrice];
    ef.pricturePath = [json objectForKey:KeyFoodPicturePath];
    ef.stauts = [json objectForKey:KeyFoodStatus];
    ef.generatedTime = [json objectForKey:KeyFoodGeneratedTime];
    ef.descriptionInfo = [json objectForKey:KeyFoodDescriptionInfo];
    ef.amount = [json objectForKey:KeyFoodAmount];
    return ef;
}
-(NSMutableDictionary*) toJson{
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setObject:self.keyId forKey:KeyFoodId];
    [json setObject:self.name forKey:KeyFoodName];
    [json setObject:self.type forKey:KeyFoodType];
    [json setObject:self.price forKey:KeyFoodPrice];
    if([NSString isEnabled:self.pricturePath])[json setObject:self.pricturePath forKey:KeyFoodPicturePath];
    [json setObject:self.stauts forKey:KeyFoodStatus];
    if([NSString isEnabled:self.generatedTime])[json setObject:self.generatedTime forKey:KeyFoodGeneratedTime];
    if([NSString isEnabled:self.descriptionInfo])[json setObject:self.descriptionInfo forKey:KeyFoodDescriptionInfo];
    [json setObject:self.amount forKey:KeyFoodAmount];
    return json;
}

+(NSString*) getKey{
    return @"keyId";
}
+ (NSArray*) getColums{
    return [NSArray arrayWithObjects: @"name",@"type",@"price",@"pricturePath",@"stauts",@"generatedTime",@"descriptionInfo",@"amount",nil];
}
+(long long int) getTypes{
    return 331333331;
}
+(NSString*) getTable{
    return @"EntityFood";
}

@end
