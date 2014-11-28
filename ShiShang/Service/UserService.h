//
//  UserService.h
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

@interface UserService : BaseService

-(void) loginWithUserName:(NSString*) userName password:(NSString*) password success:(CallBackNetWorkHTTP) success faild:(CallBackNetWorkHTTP) faild;
@end
