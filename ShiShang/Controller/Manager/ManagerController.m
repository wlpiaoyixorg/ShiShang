//
//  ManagerController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/21.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ManagerController.h"
#import "EntityFood.h"
#import "FoodService.h"
#import "ManagerDataCell.h"
#import "ManagerHeadCell.h"
#import "ManagerOptCell.h"
#import "ManagerAddType.h"
#import "ObserverListner.h"
#import "BuyOrdersController.h"
#import "ManageAddData.h"
#import "ShiShangDataPickerView.h"

@interface ManagerController ()
@property (strong, nonatomic) IBOutlet UIButton *buttionShowType;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionManager;
@property (strong, nonatomic) PopUpDialogVendorView *dialogShow;
@property (strong, nonatomic) FoodService *foodService;
@end

@implementation ManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"管 理"];
    
    _foodService = [FoodService new];
    
    UINib *nib = [UINib nibWithNibName:@"ManagerDataCell" bundle:nil];
    [_collectionManager registerNib:nib forCellWithReuseIdentifier:@"ManagerDataCell"];
    
    nib = [UINib nibWithNibName:@"ManagerHeadCell" bundle:nil];
    [_collectionManager registerNib:nib forCellWithReuseIdentifier:@"ManagerHeadCell"];
    
    nib = [UINib nibWithNibName:@"ManagerOptCell" bundle:nil];
    [_collectionManager registerNib:nib forCellWithReuseIdentifier:@"ManagerOptCell"];
    _collectionManager.delegate = self;
    _collectionManager.dataSource = self;
    [_buttionShowType addTarget:self action:@selector(showTypeView)];
    __weak typeof(self) weakself = self;
    [self setSELShowKeyBoardStart:^{
        if(weakself.dialogShow){
            weakself.dialogShow.viewShow.flagShouldTouchMove = NO;
            [weakself.dialogShow addGestureRecognizer:weakself.tapGestureRecognizer];
        }
    } End:^(CGRect keyBoardFrame) {
        if (weakself.dialogShow) {
            float offy = (weakself.dialogShow.frameHeight-weakself.dialogShow.viewShow.frameHeight)/2+weakself.dialogShow.viewShow.frameHeight-(boundsHeight()-keyBoardFrame.size.height);
            if (offy>0) {
                weakself.dialogShow.viewShow.frameY = (weakself.dialogShow.frameHeight-weakself.dialogShow.viewShow.frameHeight)/2 - offy;
            }
        }
    }];
    [self setSELHiddenKeyBoardBefore:^{
        if(weakself.dialogShow){
            weakself.dialogShow.viewShow.flagShouldTouchMove = YES;
            [weakself.dialogShow removeGestureRecognizer:weakself.tapGestureRecognizer];
        }
        
    } End:^(CGRect keyBoardFrame) {
        weakself.dialogShow.viewShow.frameY = (weakself.dialogShow.frameHeight-weakself.dialogShow.viewShow.frameHeight)/2;
    }];
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect r = self.view.frame;
    r.size.height = appHeight()-SSCON_BUTTOM;
    self.view.frame = r;
    [self reloadData];
//    ShiShangDataPickerView *typeView= [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShiShangDataPickerView class]) owner:self options:nil].firstObject;
//    [self.view addSubview:typeView];
}
-(void) showTypeView{
     ManagerAddType *typeView= [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ManagerAddType class]) owner:self options:nil].firstObject;
    CGRect r = typeView.frame;
    if (appWidth()<400) {
        r.size = CGSizeMake(260, 260*r.size.height/r.size.width);
    }
    typeView.frame = r;
    __weak typeof(self) weakself = self;
    _dialogShow = [PopUpDialogVendorView dialogWithView:typeView onclickBlock:^(PopUpDialogVendorView *dialogView, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:{
                [weakself persistType];
            }
                break;
                
            default:{
            }
                break;
        }
        _dialogShow = nil;
        
    } buttonNames:@"确定",@"取消",nil];
    [_dialogShow show];
}
-(void) showTypeView:(NSString*) type{
    ManagerAddType *typeView= [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ManagerAddType class]) owner:self options:nil].firstObject;
    CGRect r = typeView.frame;
    if (appWidth()<400) {
        r.size = CGSizeMake(260, 260*r.size.height/r.size.width);
    }
    typeView.typeLast  = type;
    typeView.frame = r;
    
    __weak typeof(self) weakself = self;
    _dialogShow = [PopUpDialogVendorView dialogWithView:typeView onclickBlock:^(PopUpDialogVendorView *dialogView, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:{
                [weakself mergType];
            }
                break;
            case 1:{
                
                PopUpDialogVendorView *alert =[PopUpDialogVendorView alertWithMessage:@"要删除当前类型吗？" title:nil onclickBlock:^(PopUpDialogVendorView *dialogView, NSInteger buttonIndex) {
                    switch (buttonIndex) {
                        case 0:
                            [weakself removeType:[dialogView.userDic objectForKey:@"type"]];
                            break;
                            
                        default:
                            break;
                    }
                    
                } buttonNames:@"删除",@"取消",nil];
                NSString *oldType = ((ManagerAddType*)_dialogShow.dialogContext).typeLast;
                alert.userDic = @{@"type":oldType};
                [alert show];
            }
                break;
            default:{
            }
                break;
        }
        _dialogShow = nil;
        
    } buttonNames:@"确定",@"删除",@"取消",nil];
    [_dialogShow show];
}
-(void) showDataViewWithFood:(EntityFood*) food{
    ManageAddData *dataView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ManageAddData class]) owner:self options:nil].firstObject;
    CGRect r = dataView.frame;
    if (appWidth()<400) {
        r.size = CGSizeMake(260, 260*r.size.height/r.size.width);
    }
    dataView.frame = r;
    dataView.food = food;
    
    __weak typeof(self) weakself = self;
    _dialogShow = [PopUpDialogVendorView dialogWithView:dataView onclickBlock:^(PopUpDialogVendorView *dialogView, NSInteger buttonIndex) {
        _dialogShow = nil;
        switch (buttonIndex) {
            case 0:{
                [weakself mergeFood:[((ManageAddData*)dialogView.dialogContext) getFood]];
            }
                break;
            case 1:{
                [weakself removeFood:[((ManageAddData*)dialogView.dialogContext) getFood]];
            }
                break;
                
            default:{
            }
                break;
        }
    } buttonNames:@"确定",@"删除",@"取消",nil];
    [_dialogShow show];
    
}
-(void) showDataViewWithType:(NSString*) type{
    ManageAddData *dataView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ManageAddData class]) owner:self options:nil].firstObject;
    CGRect r = dataView.frame;
    if (appWidth()<400) {
        r.size = CGSizeMake(260, 260*r.size.height/r.size.width);
    }
    dataView.frame = r;
    EntityFood *food = [EntityFood entityWithJson:@{KeyFoodType:type}];
    dataView.food = food;
    
    __weak typeof(self) weakself = self;
    _dialogShow = [PopUpDialogVendorView dialogWithView:dataView onclickBlock:^(PopUpDialogVendorView *dialogView, NSInteger buttonIndex) {
        _dialogShow = nil;
        switch (buttonIndex) {
            case 0:{
                [weakself persistFood:[((ManageAddData*)dialogView.dialogContext) getFood]];
            }
                break;
                
            default:{
            }
                break;
        }
    } buttonNames:@"确定",@"取消",nil];
    [_dialogShow show];
    
}
-(void) persistType{
   NSString *type = ((ManagerAddType*)_dialogShow.dialogContext).textFieldFoodType.text;
    if (![NSString isEnabled:type]) {
        [Utils showAlert:NSLocalizedString(@"foodtype_opt_null", nil) title:nil];
        return;
    }
    [Utils showLoading:NSLocalizedString(@"foodtype_opt_msg", nil)];
    [_foodService presistType:type success:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        [self reloadData];
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
    }];
}
-(void) mergType{
    NSString *type = ((ManagerAddType*)_dialogShow.dialogContext).textFieldFoodType.text;
    NSString *oldType = ((ManagerAddType*)_dialogShow.dialogContext).typeLast;
    if (![NSString isEnabled:type]) {
        [Utils showAlert:NSLocalizedString(@"foodtype_opt_null", nil) title:nil];
        return;
    }
    [Utils showLoading:NSLocalizedString(@"foodtype_opt_msg", nil)];
    [_foodService mergeType:type oldType:oldType success:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        [self reloadData];
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
    }];
}
-(void) removeType:(NSString*) oldType{
    if (![NSString isEnabled:oldType]) {
        [Utils showAlert:NSLocalizedString(@"foodtype_opt_null", nil) title:nil];
        return;
    }
    [Utils showLoading:NSLocalizedString(@"foodtype_opt_msg", nil)];
    [_foodService removeType:oldType success:^(id data, NSDictionary *userInfo) {
       [Utils hiddenLoading];
        [self reloadData];
    } faild:^(id data, NSDictionary *userInfo) {
       [Utils hiddenLoading];
        
    }];
}
-(void) persistFood:(EntityFood*) food{
    @try {
        [_foodService presistFood:food success:^(id data, NSDictionary *userInfo) {
           [Utils hiddenLoading];
            [self reloadData];
        } faild:^(id data, NSDictionary *userInfo) {
           [Utils hiddenLoading];
        }];
        [Utils showLoading:NSLocalizedString(@"foodtype_opt_msg", nil)];
    }
    @catch (NSException *exception) {
        [Utils showAlert:exception.reason title:nil];
    }
    
}
-(void) mergeFood:(EntityFood*) food{
    @try {
        [_foodService mergeFood:food success:^(id data, NSDictionary *userInfo) {
           [Utils hiddenLoading];
            [self reloadData];
        } faild:^(id data, NSDictionary *userInfo) {
           [Utils hiddenLoading];
        }];
        [Utils showLoading:NSLocalizedString(@"foodtype_opt_msg", nil)];
    }
    @catch (NSException *exception) {
        [Utils showAlert:exception.reason title:nil];
    }
}
-(void) removeFood:(EntityFood*) food{
    @try {
        [_foodService removeFood:food success:^(id data, NSDictionary *userInfo) {
           [Utils hiddenLoading];
            [self reloadData];
        } faild:^(id data, NSDictionary *userInfo) {
           [Utils hiddenLoading];
        }];
        [Utils showLoading:NSLocalizedString(@"foodtype_opt_msg", nil)];
    }
    @catch (NSException *exception) {
        [Utils showAlert:exception.reason title:nil];
    }
}


-(void) setArrayData:(NSMutableArray *)arrayData{
    _arrayData = [NSMutableArray new];
    if(!arrayData){
        return;
    }
    [self setCategroyArrayData:arrayData];
    [self.collectionManager reloadData];
    [ObserverListner getNewInstance].valueListner = @"BuyOrdersController";
}

-(void) setCategroyArrayData:(NSMutableArray *)arrayData{
    NSMutableArray *array = [NSMutableArray new];
    NSString *type = nil;
    for (EntityFood *ef in arrayData) {
        if (!type) {
            type = (ef.type?ef.type:@"unkwon");
        }
        if ([ef.type isEqualToString:type]) {
            [array addObject:ef];
        }
    }
    [arrayData removeObjectsInArray:array];
    if (type) {
        [array addObject:type];
        [_arrayData addObject:@{KeyFoodType:type}];
        [_arrayData addObject:array];
    }
    if ([arrayData count]) {
        [self setCategroyArrayData:arrayData];
    }
}

//==>UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isHead:indexPath.section]) {
        NSDictionary *json = [_arrayData objectAtIndex:indexPath.section];
        NSString *category = [json objectForKey:KeyFoodType];
        [self showTypeView:category];
    }else{
        NSArray *array = [_arrayData objectAtIndex:indexPath.section];
        if (indexPath.row==[array count]-1) {
        }else{
            [self showDataViewWithFood:[array objectAtIndex:indexPath.row]];
        }
    }
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
//<==

//==>UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!_arrayData) {
        return 0;
    }
    if ([self isHead:section]) {
        return 1;
    }else{
        NSArray *array = [_arrayData objectAtIndex:section];
        return [array count];
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_arrayData count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isHead:indexPath.section]) {
        NSDictionary *json = [_arrayData objectAtIndex:indexPath.section];
        NSString *category = [json objectForKey:KeyFoodType];
        ManagerHeadCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ManagerHeadCell" forIndexPath:indexPath];
        cell.foodType = category;
        return cell;
    }else{
        NSArray *array = [_arrayData objectAtIndex:indexPath.section];
        if (indexPath.row==[array count]-1) {
            NSString *foodtype = [array objectAtIndex:indexPath.row];
            ManagerOptCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ManagerOptCell" forIndexPath:indexPath];
            cell.foodType = foodtype;
            [cell setCallBackManagerOptReturn:^(NSString *foodType) {
                [self showDataViewWithType:foodType];
            }];
            return cell;
        }else{
            EntityFood *food = [array objectAtIndex:indexPath.row];
            ManagerDataCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ManagerDataCell" forIndexPath:indexPath];
            cell.food = food;
            CGRect r = cell.frame;
            r.size = [self getOrderSize];
            cell.frame = r;
            return cell;
        }
    }
    
}
//<==


//==>UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    float off = [self getOffValue];
    return UIEdgeInsetsMake(off/2, off, 0, off);
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self isHead:indexPath.section]?[self getHeadSize]:[self getOrderSize];
}
//<==

-(BOOL) resignFirstResponder{
    if (self.dialogShow) {
        [self.dialogShow.dialogContext resignFirstResponder];
    }
    return [super resignFirstResponder];
}
-(void) dealloc {
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) isHead:(NSInteger) section{
    return section%2?NO:YES;
}
-(CGSize) getHeadSize{
    float off = [self getOffValue];
    CGSize size = CGSizeMake(_collectionManager.frame.size.width-off*2, 30);
    return size;
}
-(CGSize) getOrderSize{
    float off = [self getOffValue];
    float avg = [self getAvgValue];
    CGSize size = CGSizeMake((_collectionManager.frame.size.width-(avg+1)*off)/avg, (_collectionManager.frame.size.width-(avg+1)*off)/avg/2);
    return size;
}
-(float) getOffValue{
    float off = self.collectionManager.frame.size.width*0.05;
    return off;
}
-(float) getAvgValue{
    return appWidth()<400?3.0f:4.0f;
}
-(void) reloadData{
    [Utils showLoading:nil];
    [_foodService queryAllFoodForSuccess:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        if (data) {
            self.arrayData = data;
        }
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
    }];
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
