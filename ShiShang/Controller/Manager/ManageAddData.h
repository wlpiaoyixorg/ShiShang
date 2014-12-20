//
//  ManageAddData.h
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/18.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VendorMoveView.h"
#import "EntityFood.h"

@interface ManageAddData : UIView<UITextFieldDelegate>
@property (nonatomic,strong) EntityFood *food;
@end
