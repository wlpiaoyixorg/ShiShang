//
//  DataController.m
//  ShiShang
//
//  Created by torin on 14/12/20.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "DataController.h"
#import "NavigationScrollView.h"
#import "ScrollButtonOpt.h"

#import "OrdersViewController.h"
#import "SettingViewController.h"
#import "StatisticViewController.h"
#import "AccountViewController.h"

@interface DataController ()
@property (weak, nonatomic) IBOutlet NavigationScrollView *scrollView;
@property (nonatomic,strong) NSArray *controllers;
@property (nonatomic, strong) ScrollButtonOpt *viewButton;
@end

@implementation DataController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"数 据"];
    [super showReturnButton:NO];
    self.scrollView.parsentController = self;
    OrdersViewController *orders = [[OrdersViewController alloc] init];
    SettingViewController *setting = [[SettingViewController alloc] init];
    StatisticViewController *statistic = [[StatisticViewController alloc] init];
    AccountViewController *account = [[AccountViewController alloc] init];
    _controllers = @[orders,setting,statistic,account];
    
    _viewButton = [ScrollButtonOpt new];
    _viewButton.frame = CGRectMake(0, SSCON_TOP, APP_W, SSCON_TIT);
    _viewButton.backgroundColor = [UIColor lightGrayColor];
    _viewButton.normaltextColor = [UIColor blackColor];
    _viewButton.selectedtextColor = [UIColor redColor];
    _viewButton.values = @[@"下单",@"管理",@"消息",@"数据"];
    
    __weak typeof(self) weakself =self;
    [_scrollView setCallBackScrollEnd:^int(int showIndex, id userInfo) {
        weakself.viewButton.showIndex = showIndex;
        return 1;
    }];
    [_viewButton setCallBackScrollEnd:^int(int showIndex, id userInfo) {
        [weakself.scrollView setShowIndex:showIndex];
        return 1;
    }];
    [self.view addSubview:_viewButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scrollView setArrayControllers:_controllers];
    _scrollView.showIndex = 1;
    _viewButton.showIndex = 1;
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height = APP_H-SSCON_TOP-SSCON_BUTTOM-SSCON_TIT;
    self.scrollView.contentSize = contentSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
