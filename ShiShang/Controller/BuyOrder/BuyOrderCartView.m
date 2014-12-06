//
//  BuyOrderCartView.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-15.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BuyOrderCartView.h"
#import "BuyOrderMenuCell.h"
#import "BuyOrdersController.h"
#import "EntityFood.h"

@interface BuyOrderCartView()
@property (strong, nonatomic) IBOutlet UITableView *tableViewMenu;
@property (strong, nonatomic) IBOutlet UILabel *lableTotal;
@property (strong, nonatomic) IBOutlet UITextField *textFieldDesk;


@end

@implementation BuyOrderCartView
- (void)awakeFromNib {
    _tableViewMenu.delegate = self;
    _tableViewMenu.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"BuyOrderMenuCell" bundle:nil];
    [_tableViewMenu registerNib:nib forCellReuseIdentifier:@"BuyOrderMenuCell"];
}
-(void) setArrayData:(NSMutableArray *) arrayData{
    _arrayData = arrayData;
}
//==> UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34.0f;
}
//<==
//==>UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arrayData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EntityFood *food = [_arrayData objectAtIndex:indexPath.row];
    BuyOrderMenuCell *cell= [_tableViewMenu dequeueReusableCellWithIdentifier:@"BuyOrderMenuCell"];
    [cell setFood:food];
    __weak typeof(self) weakself = self;
    [cell setCallBackBuyOrderMenuCellOnclick:^(EntityFood *food) {
        [weakself reloadData];
    }];
    return cell;
}
//<==
-(void) reloadData{
    unsigned int totalPrice = 0;
    NSMutableArray *removearray = [NSMutableArray new];
    for (EntityFood *food in _arrayData) {
        if (food.amount.intValue<=0) {
            [removearray addObject:food];
            continue;
        }
        NSNumber *price = food.price;
        NSNumber *number =  food.amount;
        totalPrice += (price.floatValue*number.floatValue*100);
    }
    [_arrayData removeObjectsInArray:removearray];
    _totalPrice = [NSNumber numberWithFloat:(float)((totalPrice)/100.0f)];
    _lableTotal.text = [NSString stringWithFormat:@"￥%@",_totalPrice.stringValue];
    [self.tableViewMenu reloadData];
}
-(void) setDeskCode:(NSString *)deskCode{
    self.textFieldDesk.text = deskCode;
}
-(BOOL) resignFirstResponder{
    [_textFieldDesk resignFirstResponder];
    return [super resignFirstResponder];
}
@end
