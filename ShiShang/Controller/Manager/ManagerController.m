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
#import "PopUpVendorView.h"
#import "ObserverListner.h"
#import "BuyOrdersController.h"
#import "ManageAddData.h"
#import "PopUpDialogVendorView.h"

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
    [self showReturnButton:NO];
    
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
            CGRect r = weakself.dialogShow.viewShow.frame;
            float offy = r.origin.y+r.size.height-keyBoardFrame.origin.y;
            if (offy>0) {
                weakself.dialogShow.frameY = -offy;
            }
        }
    }];
    [self setSELHiddenKeyBoardBefore:^{
        if(weakself.dialogShow){
            weakself.dialogShow.viewShow.flagShouldTouchMove = YES;
            [weakself.dialogShow removeGestureRecognizer:weakself.tapGestureRecognizer];
        }
        
    } End:^(CGRect keyBoardFrame) {
        weakself.dialogShow.frameY = 0;
    }];
    
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect r = self.view.frame;
    r.size.height = APP_H-SSCON_BUTTOM;
    self.view.frame = r;
    [self reloadData];
}
-(void) showTypeView{
     ManagerAddType *typeView= [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ManagerAddType class]) owner:self options:nil].firstObject;
    CGRect r = typeView.frame;
    if (APP_W<400) {
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
    if (APP_W<400) {
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
                [weakself removeType];
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
-(void) showDataView:(EntityFood*) food{
    ManageAddData *dataView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ManageAddData class]) owner:self options:nil].firstObject;
    CGRect r = dataView.frame;
    if (APP_W<400) {
        r.size = CGSizeMake(260, 260*r.size.height/r.size.width);
    }
    dataView.frame = r;
    
    
    _dialogShow = [PopUpDialogVendorView dialogWithView:dataView onclickBlock:^(PopUpDialogVendorView *dialogView, NSInteger buttonIndex) {
        _dialogShow = nil;
        switch (buttonIndex) {
            case 0:{
            }
                break;
            case 1:{
            }
                break;
                
            default:{
            }
                break;
        }
    } buttonNames:@"确定",@"删除",@"取消",nil];
    [_dialogShow show];
    
}
-(void) persistType{
   NSString *type = ((ManagerAddType*)_dialogShow.dialogContext).textFieldFoodType.text;
    if (![NSString isEnabled:type]) {
        [Common showMessage:NSLocalizedString(@"foodtype_opt_null", nil) Title:nil];
        return;
    }
    [ActivityIndicatorView showActivityIndicator:NSLocalizedString(@"foodtype_opt_msg", nil)];
    [_foodService presistType:type success:^(id data, NSDictionary *userInfo) {
        [ActivityIndicatorView hideActivityIndicator];
        [self reloadData];
    } faild:^(id data, NSDictionary *userInfo) {
        [ActivityIndicatorView hideActivityIndicator];
    }];
}
-(void) mergType{
    NSString *type = ((ManagerAddType*)_dialogShow.dialogContext).textFieldFoodType.text;
    NSString *oldType = ((ManagerAddType*)_dialogShow.dialogContext).typeLast;
    if (![NSString isEnabled:type]) {
        [Common showMessage:NSLocalizedString(@"foodtype_opt_null", nil) Title:nil];
        return;
    }
    [ActivityIndicatorView showActivityIndicator:NSLocalizedString(@"foodtype_opt_msg", nil)];
    [_foodService mergeType:type oldType:oldType success:^(id data, NSDictionary *userInfo) {
        [ActivityIndicatorView hideActivityIndicator];
        [self reloadData];
    } faild:^(id data, NSDictionary *userInfo) {
        [ActivityIndicatorView hideActivityIndicator];
    }];
}
-(void) removeType{
    NSString *oldType = ((ManagerAddType*)_dialogShow.dialogContext).typeLast;
    if (![NSString isEnabled:oldType]) {
        [Common showMessage:NSLocalizedString(@"foodtype_opt_null", nil) Title:nil];
        return;
    }
    [ActivityIndicatorView showActivityIndicator:NSLocalizedString(@"foodtype_opt_msg", nil)];
    [_foodService removeType:oldType success:^(id data, NSDictionary *userInfo) {
        [ActivityIndicatorView hideActivityIndicator];
        [self reloadData];
    } faild:^(id data, NSDictionary *userInfo) {
        [ActivityIndicatorView hideActivityIndicator];
        
    }];
    
}


-(void) setArrayData:(NSMutableArray *)arrayData{
    _arrayData = [NSMutableArray new];
    if(!arrayData||![arrayData count]){
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
            [_arrayData addObject:@{KeyFoodType:type}];
        }
        if ([ef.type isEqualToString:type]) {
            [array addObject:ef];
        }
    }
    [array addObject:type];
    [arrayData removeObjectsInArray:array];
    [_arrayData addObject:array];
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
            [self showDataView:[array objectAtIndex:indexPath.row]];
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
                [Common showMessage:foodType Title:nil];
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
    return APP_W<400?3.0f:4.0f;
}
-(void) reloadData{
    [_foodService queryAllFoodForSuccess:^(id data, NSDictionary *userInfo) {
        if (data) {
            self.arrayData = data;
        }
    } faild:^(id data, NSDictionary *userInfo) {
        
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
