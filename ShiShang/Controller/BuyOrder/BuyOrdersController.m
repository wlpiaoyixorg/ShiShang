//
//  BuyOrdersController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-14.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "BuyOrdersController.h"
#import "OrderCollectionViewCell.h"
#import "OrderHeadCollectionViewCell.h"
#import "ScrollViewOpt.h"
#import "AsyncImageView.h"
#import "BuyOrderCartView.h"
#import "EntityFood.h"
#import "FoodService.h"
#import "ObserverListner.h"

NSString *const KeyBuyOrderDeskNum = @"orderDeskNum";
NSString *const KeyOrderHeadImage = @"headImage";

NSString *const KeyDatas = @"datas";

@interface BuyOrdersController (){
    FoodService *foodService;
}
@property (strong, nonatomic) IBOutlet MovableView *viewCart;
@property (strong, nonatomic) BuyOrderCartView *viewCartOpt;
@property (nonatomic) CGRect *rectCartOpt;
@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewOrder;

@property (strong, nonatomic) ScrollViewOpt *viewHeadImage;

@property NSMutableArray *orderData;
@end

@implementation BuyOrdersController
- (void)viewDidLoad {
    
    [[ObserverListner getNewInstance] mergeWithTarget:self action:@selector(reloadData) arguments:nil key:NSStringFromClass([self class])];
    
    [super viewDidLoad];
    [self setTitle:@"下单"];
    
    foodService = [FoodService new];
    
    UINib *nib = [UINib nibWithNibName:@"OrderCollectionViewCell" bundle:nil];
    [_collectionViewOrder registerNib:nib forCellWithReuseIdentifier:@"OrderCollectionViewCell"];

    nib = [UINib nibWithNibName:@"OrderHeadCollectionViewCell" bundle:nil];
    [_collectionViewOrder registerNib:nib forCellWithReuseIdentifier:@"OrderHeadCollectionViewCell"];
    
    _collectionViewOrder.dataSource = self;
    _collectionViewOrder.delegate = self;
    
    
    _viewHeadImage = [ScrollViewOpt new];
    CGRect r = _viewHead.frame;
    r.origin.x = r.origin.y = 0;
    r.size.width = appWidth();
    _viewHeadImage.frame = r;
    [_viewHead addSubview:_viewHeadImage];
    
    [_viewCart addTarget:self action:@selector(onclickShowCart)];
    [_viewCart removeFromSuperview];
    [self.view addSubview:_viewCart];
    
    
    
    __weak typeof (self) weakself = self;
    [self setSELShowKeyBoardStart:^{
    } End:^(CGRect keyBoardFrame) {
        CGPoint p = [weakself.viewCartOpt.viewShow getAbsoluteOrigin:weakself.view];
        float offy = appHeight()-keyBoardFrame.size.height-(p.y+weakself.viewCartOpt.viewShow.frameHeight);
        if (offy<0) {
            CGRect r = weakself.view.frame;
            r.origin.x = 0;
            r.origin.y = offy;
            [UIView animateWithDuration:0.25f animations:^{
                weakself.view.frame = r;
            }];
        }
        
    }];
    [self setSELHiddenKeyBoardBefore:^{
        if (weakself.view.frame.origin.y<0) {
            [UIView animateWithDuration:0.25f animations:^{
                CGRect r = weakself.view.frame;
                r.origin.y = 0;
                weakself.view.frame = r;
            }];
        }
    } End:^(CGRect keyBoardFrame) {
    }];
    [self.viewCartOpt.viewShow setCallBackVendorTouchEnd:^(CGRect frame) {
//        weakself.rectViewCartOpt = frame;
    }];
    
    [self.view removeGestureRecognizer:super.tapGestureRecognizer];
    self.orderData = [NSMutableArray new];
    // Do any additional setup after loading the view from its nib.
}
-(void) reloadData{
    self.arrayHead = [NSMutableArray arrayWithArray:@[@{KeyOrderHeadImage:@"http://e.hiphotos.baidu.com/image/pic/item/6a600c338744ebf8a656dd46daf9d72a6059a7a0.jpg"},@{KeyOrderHeadImage:@"http://e.hiphotos.baidu.com/image/pic/item/6a600c338744ebf8a656dd46daf9d72a6059a7a0.jpg"}]];
    self.arrayData = [NSMutableArray arrayWithArray:[foodService queryAllFoodFromDataBase]];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect r = self.view.frame;
    r.size.height = appHeight()-SSCON_BUTTOM;
    self.view.frame = r;
    [self reloadData];
}
-(void) onclickShowCart{
    _viewCartOpt = [[[NSBundle mainBundle] loadNibNamed:@"BuyOrderCartView" owner:self options:nil] lastObject];
    [_viewCartOpt setBackgroundColor:[UIColor clearColor]];
    [_viewCartOpt setViewSuper:self.view];
    [_viewCartOpt setAnimation:PopUpMovableViewAnimationNone];
    [_viewCartOpt setFlagTouchHidden:NO];
    [_viewCartOpt setFlagBackToCenter:NO];
    CGRect r = self.viewCart.frame;
    r.size = self.viewCartOpt.viewShow.frame.size;
    r.origin.x -= (r.size.width-self.viewCart.frame.size.width);
    _viewCartOpt.pointShow = r.origin;
    
    
    __weak typeof(self) weakself = self;
    [_viewCartOpt setAfterShow:^(PopUpMovableView *vmv) {
        weakself.viewCart.alpha = 0;
        CGRect r = weakself.viewCartOpt.viewShow.frame;
        if (r.origin.x<0||r.origin.y<0||r.origin.x>weakself.view.frame.size.width-r.size.width||r.origin.y>weakself.view.frame.size.height-r.size.height) {
            [UIView animateWithDuration:0.25f animations:^{
                CGRect r = weakself.viewCartOpt.viewShow.frame;
                r.origin.x = r.origin.x<0?0:r.origin.x;
                r.origin.y = r.origin.y<0?0:r.origin.y;
                r.origin.y = r.origin.y>(weakself.view.frame.size.height-r.size.height)?(weakself.view.frame.size.height-r.size.height):r.origin.y;
                r.origin.x = r.origin.x>(weakself.view.frame.size.width-r.size.width)?(weakself.view.frame.size.width-r.size.width):r.origin.x;
                weakself.viewCartOpt.viewShow.frame = r;
            }];
        }
    }];
    [_viewCartOpt setBeforeClose:^(PopUpMovableView *vmv) {
        weakself.viewCart.alpha = 1;
        CGRect r = weakself.viewCartOpt.viewShow.frame;
        r.size = weakself.viewCart.frame.size;
        r.origin.x += (weakself.viewCartOpt.viewShow.frame.size.width - r.size.width);
        weakself.viewCart.frame = r;
    }];
    
    self.viewCartOpt.arrayData = self.orderData;
    [self.viewCartOpt addOrderTarget:self action:@selector(onclickOrderAdd)];
    [self.viewCartOpt reloadData];
    [self.viewCartOpt show];
    
//    [_viewCart removeGestureRecognizer:_tapGestureviewKeyBoradCarts];
//    [self.view addGestureRecognizer:super.tapGestureRecognizer];
    
}

-(void) setArrayData:(NSMutableArray *)arrayData{
    
    _arrayData = [NSMutableArray new];
    if(!arrayData){
        return;
    }
    [self setCategroyArrayData:arrayData];
    [self.collectionViewOrder reloadData];
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
        [_arrayData addObject:@{KeyFoodType:type}];
        [_arrayData addObject:array];
    }
    if ([arrayData count]) {
        [self setCategroyArrayData:arrayData];
    }
}

-(void) setArrayHead:(NSMutableArray *)arrayHead{
    _arrayHead = arrayHead;
    [_viewHeadImage removeAllViews];
    for (NSDictionary *json in _arrayHead) {
        NSString *imageUrl = [json objectForKey:KeyOrderHeadImage];
        AsyncImageView *imageview = [AsyncImageView new];
        imageview.frame = CGRectMake(0, 0, _viewHeadImage.frame.size.width, _viewHeadImage.frame.size.height);
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.imageUrl = imageUrl;
        [_viewHeadImage addSubview:imageview];
    }
}
-(void) onclickOrderAdd{
    [self.viewCartOpt close];
}

//==>UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CGPoint p = [[collectionView cellForItemAtIndexPath:indexPath] getAbsoluteOrigin:self.view];
    p.y = p.y-collectionView.contentOffset.y;
    
    if (![self isHead:indexPath.section]) {
        NSArray *array = [_arrayData objectAtIndex:indexPath.section];
        EntityFood *food = [array objectAtIndex:indexPath.row];
        NSNumber *idKey = food.keyId;
        BOOL hasParams = false;
        for (EntityFood *_food_ in _orderData) {
            NSNumber *idKeyDic =_food_.keyId;
            if (idKey.intValue == idKeyDic.intValue) {
                hasParams = true;
//                if (_food_.amount.intValue>=food.amount.intValue) {
//                    goto br;
//                }
                _food_.amount = [NSNumber numberWithInt:_food_.amount.intValue+1];
                goto br;
            }
        }
    br:if (!hasParams) {
            EntityFood *foodAdd = [EntityFood entityWithJson:[food toJson]];
            foodAdd.amount = @1;
            [_orderData addObject:foodAdd];
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
        OrderHeadCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"OrderHeadCollectionViewCell" forIndexPath:indexPath];
        [cell setParam:category forKey:KeyFoodType];
        return cell;
    }else{
        NSArray *array = [_arrayData objectAtIndex:indexPath.section];
        EntityFood *food = [array objectAtIndex:indexPath.row];
        OrderCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"OrderCollectionViewCell" forIndexPath:indexPath];
        cell.food = food;
        CGRect r = cell.frame;
        r.size = [self getOrderSize];
        cell.frame = r;
        return cell;
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

-(BOOL) isHead:(NSInteger) section{
    return section%2?NO:YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGSize) getHeadSize{
    float off = [self getOffValue];
    CGSize size = CGSizeMake(_collectionViewOrder.frame.size.width-off*2, 30);
    return size;
}
-(CGSize) getOrderSize{
    float off = [self getOffValue];
    float avg = [self getAvgValue];
    CGSize size = CGSizeMake((_collectionViewOrder.frame.size.width-(avg+1)*off)/avg, (_collectionViewOrder.frame.size.width-(avg+1)*off)/avg);
    return size;
}
-(float) getOffValue{
    float off = self.collectionViewOrder.frame.size.width*0.05;
    return off;
}
-(float) getAvgValue{
    return appWidth()<400?3.0f:4.0f;
}

-(BOOL) resignFirstResponder{
    if (_viewCartOpt) {
        [_viewCartOpt resignFirstResponder];
    }
    return [super resignFirstResponder];
}
-(void) dealloc{
    [[ObserverListner getNewInstance] removeWithKey:NSStringFromClass([self class])];
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
