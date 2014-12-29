//
//  ShiShangController.h
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-3.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "VertivalController.h"
#import "ShiShangTopView.h"
#import "Common+Expand.h"
#import "SkinDictionary.h"

#define SSCON_TOP 44.0f
#define SSCON_BUTTOM 44.0f
#define SSCON_TIT 30.0f

@interface ShiShangController : VertivalController
@property (nonatomic,strong,readonly) ShiShangTopView *topView;
@property (nonatomic,assign,readonly) SkinDictionary *dicskin;
-(void) setHiddenCloseButton:(BOOL) hidden;
-(void) setHiddenTopView:(BOOL) hidden;
@end
