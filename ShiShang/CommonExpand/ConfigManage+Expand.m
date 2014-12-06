//
//  ConfigManage+Expand.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//
#import "NSString+Convenience.h"
#import "ConfigManage+Expand.h"

#define KEYUSERNAME @"adfasdfdf"
#define KEYPASSWORD @"adsfasdfafd"
static NSString *userName;
static NSString *password;
static EntityUser *loginUser;
@implementation ConfigManage(Expand)
+(NSString*) getUserName{
    return userName;
}
+(NSString*) getPassword{
    return password;
}
+(void) setUserName:(NSString*) _userName_{
    userName = _userName_;
}
+(void) setPassword:(NSString*) _passowrd_{
    password = _passowrd_;
}
+(void) setLoginUser:(EntityUser*) user{
    loginUser = user;
}
+(EntityUser*) getLoginUser{
    return loginUser;
}
+(void) setConfigValueByUser:(id)value Key:(NSString *)key{
    NSString *username = [ConfigManage getUserName];
    if ([NSString isEnabled:username]) {
        [ConfigManage setConfigValue:value Key:[NSString stringWithFormat:@"%@_%@",username,key]];
    }
}
+(id) getConfigValueByUser:(NSString *)key{
    NSString *username = [ConfigManage getUserName];
    if ([NSString isEnabled:username]) {
        return [ConfigManage getConfigValue:[NSString stringWithFormat:@"%@_%@",username,key]];
    }
    return nil;
    
}

@end
