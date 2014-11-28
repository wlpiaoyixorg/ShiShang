//
//  EntityUser.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/22.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityUser.h"

NSString *const KeyUserId = @"id";
NSString *const KeyUserName = @"name";
NSString *const KeyUserLoginName  = @"loginName";
NSString *const KeyUserPlainPassword = @"plainPassword";
NSString *const KeyUserPassword = @"password";
NSString *const KeyUserSalt = @"salt";
NSString *const KeyUserRoles = @"roles";
NSString *const KeyUserRegisterDate = @"registerDate";
NSString *const KeyUserPhoneNumber = @"phoneNumber";
NSString *const KeyUserVoucher = @"voucher";
NSString *const KeyUserBalance = @"balance";
NSString *const KeyUserTotalConsumed = @"totalConsumed";

@implementation EntityUser
+(instancetype) entityWithJson:(NSDictionary*) json{
    EntityUser *user = [EntityUser new];
    user.keyId = [json objectForKey:KeyUserId];
    user.name = [json objectForKey:KeyUserName];
    user.loginName = [json objectForKey:KeyUserLoginName];
    user.plainPassword = [json objectForKey:KeyUserPlainPassword];
    user.password = [json objectForKey:KeyUserPassword];
    user.salt = [json objectForKey:KeyUserSalt];
    user.roles = [json objectForKey:KeyUserRoles];
    user.registerDate = [json objectForKey:KeyUserRegisterDate];
    user.phoneNumber = [json objectForKey:KeyUserPhoneNumber];
    user.voucher = [json objectForKey:KeyUserVoucher];
    user.balance = [json objectForKey:KeyUserBalance];
    user.totalConsumed = [json objectForKey:KeyUserTotalConsumed];
    return user;
}
-(NSMutableDictionary*) toJson{
    NSMutableDictionary *json = [NSMutableDictionary new];
    [json setObject:self.keyId forKey:KeyUserId];
    [json setObject:self.name forKey:KeyUserName];
    [json setObject:self.loginName forKey:KeyUserLoginName];
    [json setObject:self.plainPassword forKey:KeyUserPlainPassword];
    [json setObject:self.password forKey:KeyUserPassword];
    [json setObject:self.salt forKey:KeyUserSalt];
    [json setObject:self.roles forKey:KeyUserRoles];
    [json setObject:self.registerDate forKey:KeyUserRegisterDate];
    [json setObject:self.phoneNumber forKey:KeyUserPhoneNumber];
    [json setObject:self.voucher forKey:KeyUserVoucher];
    [json setObject:self.balance forKey:KeyUserBalance];
    [json setObject:self.totalConsumed forKey:KeyUserTotalConsumed];
    return json;
}

+(NSString*) getKey{
    return @"keyId";
}
+ (NSArray*) getColums{
    return [NSArray arrayWithObjects:@"name",@"loginName",@"plainPassword",@"password",@"salt",@"roles",@"registerDate",@"phoneNumber",@"voucher",@"balance",@"totalConsumed",nil];
}
+(long long int) getTypes{
    return 133333333111;
}
+(NSString*) getTable{
    return @"EntityUser";
}

@end
