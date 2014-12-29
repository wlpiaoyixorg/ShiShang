//
//  MerchantViewController.m
//  Data
//
//  Created by torin on 14/11/22.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "AccountViewController.h"
#import "Common+Expand.h"

@interface AccountViewController ()
{
}
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *merchantName;
@property (weak, nonatomic) IBOutlet UILabel *telephoneNum;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *ticket;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end

@implementation AccountViewController

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userName.text = [ConfigManage getLoginUser].phoneNumber;
    self.nickName.text = [ConfigManage getLoginUser].phoneNumber;
    self.merchantName.text = [ConfigManage getLoginUser].phoneNumber;
    self.telephoneNum.text = [ConfigManage getLoginUser].phoneNumber;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frameHeight = appHeight()-SSCON_TOP-SSCON_BUTTOM - SSCON_TIT;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
