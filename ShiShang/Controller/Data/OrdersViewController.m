//
//  OrdersViewController.m
//  Data
//
//  Created by torin on 14/11/15.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrdersViewCell.h"
#import "HeaderView.h"
#import "FooterView.h"
#import "BaseTableView.h"
#import "ShiShangController.h"


static NSString *const OrderNo = @"roderNo";
static NSString *const OrderTime = @"dataTime";
static NSString *const OrderTitle = @"title";
static NSString *const OrderNum = @"num";
static NSString *const OrderAmount = @"amount";
static NSString *const OrderPayable = @"payable";
static NSString *const OrderInfo = @"info";
static NSString *const OrderPrice = @"price";
static NSString *const OrderDesc = @"desc";

@interface OrdersViewController ()
{
    NSArray *datas;
}
@end

@implementation OrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView  = [[BaseTableView alloc] init];
    datas = @[@{OrderNo:@"11000",OrderTime:@"2014-10-31 15:33",
                OrderInfo:@[@{OrderTitle:@"红烧肉",OrderPrice:@"29.3",OrderNum:@"1"}],
                OrderAmount:@"44.8",OrderPayable:@"44.8",OrderDesc:@""},
              @{OrderNo:@"11001",OrderTime:@"2014-10-22 11:33",
                OrderInfo:@[@{OrderTitle:@"鲍鱼",OrderPrice:@"29.3",OrderNum:@"1"},
                          @{OrderTitle:@"鱼刺",OrderPrice:@"229.3",OrderNum:@"2"}],
                OrderAmount:@"100.8",OrderPayable:@"100.8",OrderDesc:@""}];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frameHeight = APP_H-SSCON_TOP-SSCON_BUTTOM - SSCON_TIT;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dict = datas[section];
    NSArray *array = dict[OrderInfo];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建一个ILSettingCell
    OrdersViewCell *cell = [OrdersViewCell settingCellWithTableView:tableView];
    NSDictionary *dict = datas[indexPath.section];
    NSArray *rowArray = dict[OrderInfo];
    NSDictionary *rowDict = rowArray[indexPath.row];
    cell.dict = rowDict;
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = datas[section];
    NSString *title = [NSString stringWithFormat:@"订单号:%@",dict[OrderNo]];
    
    HeaderView *headerView = [[HeaderView alloc] init];
    headerView.orderNo = title;
    headerView.dateTime = dict[OrderTime];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *dict = datas[section];
    NSString *amount = [NSString stringWithFormat:@"合计: ¥%@",dict[OrderAmount]];
    NSString *payable = [NSString stringWithFormat:@"应付: ¥%@",dict[OrderPayable]];
    NSString *desc = [NSString stringWithFormat:@"选填: %@",dict[OrderDesc]];
    
    FooterView *footerView = [[FooterView alloc] init];
    footerView.amount = amount;
    footerView.payable = payable;
    footerView.desc = desc;
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
