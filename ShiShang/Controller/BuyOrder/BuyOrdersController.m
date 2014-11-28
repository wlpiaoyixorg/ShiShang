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
#import "EMAsyncImageView.h"
#import "VendorMoveView.h"
#import "BuyOrderCartView.h"
#import "EntityFood.h"
#import "FoodService.h"

NSString *const KeyBuyOrderDeskNum = @"orderDeskNum";
NSString *const KeyOrderHeadImage = @"headImage";

NSString *const KeyDatas = @"datas";

@interface BuyOrdersController (){
    CGRect rectViewCarts;
    FoodService *foodService;
}
@property (strong, nonatomic) IBOutlet VendorMoveView *viewCart;
@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewOrder;

@property (strong, nonatomic) ScrollViewOpt *viewHeadImage;

@property (strong, nonatomic) BuyOrderCartView *viewCarts;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureviewCarts;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureviewKeyBoradCarts;
@property  CGRect rectViewCart;

@property NSMutableArray *orderData;
@end

@implementation BuyOrdersController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"下单"];
    [self showReturnButton:NO];
    
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
    r.size.width = APP_W;
    _viewHeadImage.frame = r;
    [_viewHead addSubview:_viewHeadImage];
    
    _viewCart.exclusiveTouch = YES;
    [_viewCart addTarget:self action:@selector(onclickShowCart)];
    [_viewCart removeFromSuperview];
    [self.view addSubview:_viewCart];
    _viewCarts = [[[NSBundle mainBundle] loadNibNamed:@"BuyOrderCartView" owner:self options:nil] lastObject];
    
    _tapGestureviewCarts = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onclickHiddenCart)];
    
    _tapGestureviewKeyBoradCarts = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onclickResignFirstResponderViewCarts)];
    
    __weak typeof (self) weakself = self;
    [self setSELShowKeyBoardStart:^{
        [[weakself.view viewWithTag:9003] removeGestureRecognizer:weakself.tapGestureviewCarts];
        [[weakself.view viewWithTag:9003] addGestureRecognizer:weakself.tapGestureviewKeyBoradCarts];
    } End:^(CGRect keyBoardFrame) {
        float offy = weakself.viewCarts.frame.origin.y+weakself.viewCarts.frame.size.height-keyBoardFrame.origin.y;
        if (offy>0) {
           CGRect r = weakself.viewCarts.frame;
            r.origin.y-=offy;
            r.origin.x = (weakself.view.frame.size.width - weakself.rectViewCart.size.width)/2;
            weakself.viewCarts.frame = r;
        }
        
    }];
    [self setSELHiddenKeyBoardBefore:^{
        [[weakself.view viewWithTag:9003] addGestureRecognizer:weakself.tapGestureviewCarts];
        [[weakself.view viewWithTag:9003] removeGestureRecognizer:weakself.tapGestureviewKeyBoradCarts];
        
    } End:^(CGRect keyBoardFrame) {
        weakself.viewCarts.frame = weakself.rectViewCart;
    }];
    [self.view removeGestureRecognizer:super.tapGestureRecognizer];
    self.orderData = [NSMutableArray new];
    // Do any additional setup after loading the view from its nib.
}
-(void) reloadData{
    self.arrayHead = [NSMutableArray arrayWithArray:@[@{KeyOrderHeadImage:@"http://e.hiphotos.baidu.com/image/pic/item/6a600c338744ebf8a656dd46daf9d72a6059a7a0.jpg"},@{KeyOrderHeadImage:@"http://e.hiphotos.baidu.com/image/pic/item/6a600c338744ebf8a656dd46daf9d72a6059a7a0.jpg"}]];
    self.arrayData = [NSMutableArray arrayWithArray: [foodService queryAllFood]];
    [_collectionViewOrder reloadData];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect r = self.view.frame;
    r.size.height -=44;
    self.view.frame = r;
    [self reloadData];
}
-(void) onclickShowCart{
    CGRect r = _viewCart.frame;
    r.size = _viewCarts.frame.size;
    r.origin.x = r.origin.x-(r.size.width-_viewCart.frame.size.width);
    _viewCarts.frame = r;
    UIView *viewfloa = [UIView new];
    viewfloa.frame = self.view.frame;
    viewfloa.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [viewfloa addSubview:_viewCarts];
    _viewCart.alpha = 0;
    viewfloa.tag = 9003;
    [self.view addSubview:viewfloa];
    [viewfloa addGestureRecognizer:_tapGestureviewCarts];
    [viewfloa removeGestureRecognizer:_tapGestureviewKeyBoradCarts];
    [self.view addGestureRecognizer:super.tapGestureRecognizer];
    self.rectViewCart = self.viewCarts.frame;
    self.viewCarts.arrayData = self.orderData;
    [self.viewCarts reloadData];
}
-(void) onclickHiddenCart{
    _viewCart.alpha = 1;
    [[self.view viewWithTag:9003] removeFromSuperview];
    [self.view removeGestureRecognizer:super.tapGestureRecognizer];
}
-(void) onclickResignFirstResponderViewCarts{
    [_viewCarts resignFirstResponder];
}

-(void) setArrayData:(NSMutableArray *)arrayData{
    _arrayData = [NSMutableArray new];
    [self setCategroyArrayData:arrayData];
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
    [arrayData removeObjectsInArray:array];
//    NSMutableArray *arrayAdd = [NSMutableArray new];
//    for (EntityFood *ef in array) {
//        [arrayAdd addObject:[ef toJson]];
//    }
    [_arrayData addObject:array];
    if ([arrayData count]) {
        [self setCategroyArrayData:arrayData];
    }
}

-(void) setArrayHead:(NSMutableArray *)arrayHead{
    _arrayHead = arrayHead;
    [_viewHeadImage removeAllViews];
    for (NSDictionary *json in _arrayHead) {
        NSString *imageUrl = [json objectForKey:KeyOrderHeadImage];
        EMAsyncImageView *imageview = [EMAsyncImageView new];
        imageview.frame = CGRectMake(0, 0, _viewHeadImage.frame.size.width, _viewHeadImage.frame.size.height);
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.imageUrl = imageUrl;
        [_viewHeadImage addSubview:imageview];
    }
}

//==>UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![self isHead:indexPath.section]) {
        NSArray *array = [_arrayData objectAtIndex:indexPath.section];
        EntityFood *food = [array objectAtIndex:indexPath.row];
        NSNumber *idKey = food.keyId;
        BOOL hasParams = false;
        for (EntityFood *_food_ in _orderData) {
            NSNumber *idKeyDic =_food_.keyId;
            if (idKey.intValue == idKeyDic.intValue) {
                hasParams = true;
                if (_food_.amount.intValue>=food.amount.intValue) {
                    goto br;
                }
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
    return APP_W<400?3.0f:4.0f;
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
