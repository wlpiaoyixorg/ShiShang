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
NSString *const KeyFoodUserId = @"userID";
NSString *const KeyFoodShopId = @"shopID";
NSString *const KeyFoodName = @"name";
NSString *const KeyFoodType = @"proType";
NSString *const KeyFoodPrice = @"price";
NSString *const KeyFoodPicturePath = @"picturePath";
NSString *const KeyFoodStatus = @"foodStatus";
NSString *const KeyFoodGeneratedTime = @"generatedTime";
NSString *const KeyFoodDescriptionInfo = @"descriptionInfo";
NSString *const KeyFoodAmount = @"amount";
NSString *const KeyFoodRemaining = @"remaining";

NSString *const SALE_PREPARED = @"SALE_PREPARED";

@implementation EntityFood
+(instancetype) entityWithJson:(NSDictionary*) json{
    EntityFood *ef = [EntityFood new];
    ef.keyId = [json objectForKey:KeyFoodId];
    ef.userId = [json objectForKey:KeyFoodUserId];
    ef.shopId = [json objectForKey:KeyFoodShopId];
    ef.name = [json objectForKey:KeyFoodName];
    ef.type = [json objectForKey:KeyFoodType];
    ef.price = [json objectForKey:KeyFoodPrice];
    ef.pricturePath = [json objectForKey:KeyFoodPicturePath];
    ef.stauts = [json objectForKey:KeyFoodStatus];
    ef.generatedTime = [json objectForKey:KeyFoodGeneratedTime];
    ef.descriptionInfo = [json objectForKey:KeyFoodDescriptionInfo];
    ef.amount = [json objectForKey:KeyFoodAmount];
    ef.remaining = [json objectForKey:KeyFoodRemaining];
    return ef;
}

-(NSMutableDictionary*) toJson{
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setObject:self.keyId forKey:KeyFoodId];
    [json setObject:self.name forKey:KeyFoodName];
    [json setObject:self.type forKey:KeyFoodType];
    [json setObject:self.price forKey:KeyFoodPrice];
    if([NSString isEnabled:self.userId])[json setObject:self.userId forKey:KeyFoodUserId];
    if([NSString isEnabled:self.shopId])[json setObject:self.shopId forKey:KeyFoodShopId];
    if([NSString isEnabled:self.pricturePath])[json setObject:self.pricturePath forKey:KeyFoodPicturePath];
    if(self.stauts)[json setObject:self.stauts forKey:KeyFoodStatus];
    if([NSString isEnabled:self.generatedTime])[json setObject:self.generatedTime forKey:KeyFoodGeneratedTime];
    if([NSString isEnabled:self.descriptionInfo])[json setObject:self.descriptionInfo forKey:KeyFoodDescriptionInfo];
    if(self.amount)[json setObject:self.amount forKey:KeyFoodAmount];
    if(self.remaining)[json setObject:self.remaining forKey:KeyFoodRemaining];
    return json;
}

+(NSString*) getKey{
    return @"keyId";
}
+ (NSArray*) getColums{
    return [NSArray arrayWithObjects: @"userId",@"shopId",@"name",@"type",@"price",@"pricturePath",@"stauts",@"generatedTime",@"descriptionInfo",@"amount",@"remaining",nil];
}
+(long long int) getTypes{
    return 113313333311;
}
+(NSString*) getTable{
    return @"EntityFood";
}

@end
