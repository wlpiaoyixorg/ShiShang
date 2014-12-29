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
#import "EntityOrder.h"
#import "OrdersService.h"

#define SectionHeaderHeight 30.
#define SectionFooterHeight 80.

@interface OrdersViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_datas;
}
@property (nonatomic ,weak) UITableView *tableView;
@end

@implementation OrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView  = [[BaseTableView alloc] initWithFrame:self.view.frame];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsSelection = NO;
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frameHeight = appHeight()-SSCON_TOP-SSCON_BUTTOM - SSCON_TIT;
    
    OrdersService *ordersService = [OrdersService new];
    [ordersService queryOrdersForSuccess:^(id data, NSDictionary *userInfo) {
        if (data && ![data isEqualToString:@""]) {
            _datas = data;
            [self.tableView reloadData];
        }
        
    } faild:^(id data, NSDictionary *userInfo) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dict = _datas[section];
    NSArray *array = dict[KeyOrderItems];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建一个ILSettingCell
    OrdersViewCell *cell = [OrdersViewCell settingCellWithTableView:tableView];
    NSDictionary *dict = _datas[indexPath.section];
    NSArray *rowArray = dict[KeyOrderItems];
    NSDictionary *rowDict = rowArray[indexPath.row];
    cell.dict = rowDict;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = _datas[section];
    NSString *title = [NSString stringWithFormat:@"订单号:%@",dict[KeyOrderId]];
    
    HeaderView *headerView = [[HeaderView alloc] init];
    headerView.orderNo = title;
    headerView.dateTime = dict[KeyOrderDeliverTime];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary *dict = _datas[section];
    NSString *amount = [NSString stringWithFormat:@"合计: ¥%@",dict[KeyOrderTotalPay]];
    NSString *payable = [NSString stringWithFormat:@"应付: ¥%@",dict[KeyOrderNeedPay]];
    NSString *desc = [NSString stringWithFormat:@"选填: %@",dict[KeyOrderExtranInfo]];
    
    FooterView *footerView = [[FooterView alloc] init];
    footerView.amount = amount;
    footerView.payable = payable;
    footerView.desc = desc;
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionHeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SectionFooterHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = SectionHeaderHeight;
        if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
