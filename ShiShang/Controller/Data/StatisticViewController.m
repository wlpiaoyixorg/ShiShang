//
//  StatisticViewController.m
//  Data
//
//  Created by torin on 14/11/15.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "StatisticViewController.h"
#import "StatisticService.h"

static NSString *const KeyStatisCharSet = @"charSet";
static NSString *const KeyStatisPrice = @"price";
static NSString *const KeyStatisFlag = @"flag";

static NSString *const KeyStatisHeader = @"StatisHeader";
static NSString *const KeyStatisDetail = @"StatisDetail";

#define SectionHeaderHeight 30

@interface StatisticViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_datas;
}

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSString *time;
@end


@implementation StatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = SectionHeaderHeight;
    tableView.allowsSelection = NO;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    _datas = [NSMutableArray array];
    
    self.tableView = tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frameHeight = appHeight()-SSCON_TOP-SSCON_BUTTOM;
    
    StatisticService *statisService = [StatisticService new];
    [statisService queryStatisForSuccess:^(id data, NSDictionary *userInfo) {
        if (data && ![data isEqualToString:@""]) {
            id json = [((NSString*)data) JSONValue];
            [self settingDatas:json];
        }
    } faild:^(id data, NSDictionary *userInfo) {
    }];
}

//拼接数据
- (void)settingDatas:(NSMutableArray *)data
{
    self.time = data[0][KeyStatisCharSet];
    [data insertObject:@{@"flag":@"title"} atIndex:data.count];
    NSUInteger count = data.count;
    NSMutableArray *tempArray;
    NSMutableDictionary *dict ;
    for (int i = 1; i < count; i++) {
        if ([@"title" isEqualToString:data[i][KeyStatisFlag]]) {
            if ( i != 1) {
                NSDictionary *childDict = @{KeyStatisDetail:tempArray};
                [dict addEntriesFromDictionary:childDict];
                [_datas addObject:dict];
            }
            if (data[i][KeyStatisCharSet]) {
                tempArray = [NSMutableArray array];
                dict = [NSMutableDictionary dictionaryWithObject:data[i][KeyStatisCharSet] forKey:KeyStatisHeader];
            }
        }else{
            [tempArray addObject:data[i]];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = _datas[section];
    NSArray *array = dict[KeyStatisDetail];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = _datas[indexPath.section];
    NSArray *rowArray = dict[KeyStatisDetail];
    cell.textLabel.text = rowArray[indexPath.row][KeyStatisCharSet];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@.0",rowArray[indexPath.row][KeyStatisPrice]];
    return cell;
}

//headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = _datas[section];
    if (section == 0) {
        UIView *contentView = [[UIView alloc] initWithFrame:tableView.frame];
        CGRect rect = contentView.frame;
        rect.size.height = SectionHeaderHeight;
        contentView.frame = rect;
        contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *firstLabel = [[UILabel alloc] init];
        firstLabel.textAlignment = NSTextAlignmentCenter;
        firstLabel.font = [UIFont systemFontOfSize:13.];
        firstLabel.frame = CGRectMake(0, 5, contentView.frame.size.width, 15);
        firstLabel.text = self.time;
        [firstLabel setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *secondLabel = [[UILabel alloc] init];
        secondLabel.font = [UIFont systemFontOfSize:13.];
        secondLabel.frame = CGRectMake(0, CGRectGetMaxY(firstLabel.frame)+3, contentView.frame.size.width, 15);
        secondLabel.textAlignment = NSTextAlignmentCenter;
        secondLabel.text = dict[KeyStatisHeader];
        [secondLabel setBackgroundColor:[UIColor whiteColor]];
        
        [contentView addSubview:firstLabel];
        [contentView addSubview:secondLabel];
        return contentView;
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = dict[KeyStatisHeader];
    [titleLabel setBackgroundColor:[UIColor whiteColor]];
    return titleLabel;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = SectionHeaderHeight;
        if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
