//
//  StatisticViewController.m
//  Data
//
//  Created by torin on 14/11/15.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "StatisticViewController.h"
#import "ShiShangController.h"

static NSString *const DataHeader = @"header";
static NSString *const DataDetail = @"detail";
static NSString *const DataTitle = @"title";
static NSString *const DataPtice = @"price";

@interface StatisticViewController ()
{
    NSArray *datas;
}
@end

@implementation StatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 30;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //封装数据
    datas = @[@{DataHeader:@"收入",
                DataDetail:@[@{DataTitle:@"2014-10-22",DataPtice:@"1789.1"},@{DataTitle:@"2014-11-10",DataPtice:@"1789.1"}]},
              @{DataHeader:@"商品日排名",
                DataDetail:@[@{DataTitle:@"粉蒸牛肉",DataPtice:@"17.1"},@{DataTitle:@"青椒肉丝",DataPtice:@"15.5"}]},
              @{DataHeader:@"商品月排名",
                DataDetail:@[@{DataTitle:@"猴脑",DataPtice:@"110.1"},@{DataTitle:@"佛跳墙",DataPtice:@"211.1"}]}];
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
    NSArray *array = dict[DataDetail];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = datas[indexPath.section];
    NSArray *rowArray = dict[DataDetail];
    cell.textLabel.text = rowArray[indexPath.row][DataTitle];
    cell.detailTextLabel.text = rowArray[indexPath.row][DataPtice];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = datas[section];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = dict[DataHeader];
    [titleLabel setBackgroundColor:[UIColor whiteColor]];
    return titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
