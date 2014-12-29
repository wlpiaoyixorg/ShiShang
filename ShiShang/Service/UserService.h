//
//  UserService.h
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"
#import "EntityUser.h"

@interface UserService : BaseService

-(void) loginWithUserName:(NSString*) userName password:(NSString*) password success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
-(void) exitLogin;
-(void) regesiterWithUser:(EntityUser*) user success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild;
@end
