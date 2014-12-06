//
//  ShiShangController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-3.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ShiShangController.h"
@interface ShiShangController ()
@end

@implementation ShiShangController

- (void)viewDidLoad {
    _dicskin = [SkinDictionary getSingleInstance];
    [super viewDidLoad];
    if ([NSString isEnabled:super.title]) {
        [self setTitle:super.title];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [_topView.buttonReback addTarget:self action:@selector(backPreviousController)];
}
-(void) setTitle:(NSString *)title{
    [super setTitle:title];
    if (!_topView) {
        _topView = [ShiShangTopView new];
        [_topView.buttonReback addTarget:self action:@selector(backPreviousController)];
        [self.view addSubview:_topView];
    }
    if ([NSString isEnabled:title]) {
        _topView.lableTitle.text = title;
    }
}
-(void) showReturnButton:(BOOL) flag{
    _topView.buttonReback.alpha = flag;
    _topView.buttonReback.userInteractionEnabled  = flag;
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
