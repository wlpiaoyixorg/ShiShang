//
//  Common+Expand.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-5.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "Common+Expand.h"
#import "NetWorkHTTP.h"
#import "SkinDictionary.h"
#import "FDEntityManager.h"
#import "EntityFood.h"

static FDEntityManager *em;

@interface Common()
@end
@implementation Common(Expand)
+(void) initialize{
    [self initParams];
    em = [[FDEntityManager alloc] initWithDBName:@"sqllit"];
    [em excuSql:[FDObject getCreateSqlByEntity:[EntityFood class]] Params:nil];
}
+(id) getNetWorkImpl{
    NetWorkHTTP *nwh = [NetWorkHTTP new];
    [nwh setHttpEncoding:NSUTF8StringEncoding];
    [nwh addRequestHeadValue:@{@"Content-Type":@"application/json"}];
    [nwh addRequestHeadValue:@{@"Connection":@"keep-alive"}];
    [nwh addRequestHeadValue:@{@"Charset":@"UTF-8"}];
//    [nwh addRequestHeadValue:@{@"content-type":@"application/x-www-form-urlencoded"}];
    return nwh;
}
+(void) setRootController:(UIViewController*) c window:(UIWindow*) window{
    UIWindow *w = window?window:[Common getWindow];
    [Common setNavigationController: c window:w];
    [Common setNavigationBarHidden:NO];
    w.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"window_bg_color"];
    [w makeKeyAndVisible];
}
+(id) getEntityManger{
    return em;
}


@end
