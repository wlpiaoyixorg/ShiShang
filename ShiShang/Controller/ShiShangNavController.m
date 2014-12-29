//
//  ShiShangNavController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ShiShangNavController.h"

float navigationBarHeight = 44;

@interface ShiShangNavController ()

@end

@implementation ShiShangNavController

- (void)viewDidLoad {
    _dicskin = [SkinDictionary getSingleInstance];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:[[SkinDictionary getSingleInstance] getSkinImage:@"global_topbar_bg.png"] forBarMetrics:UIBarMetricsDefault];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
