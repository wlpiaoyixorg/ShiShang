//
//  MainController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-8.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "MainController.h"
#import "ScrollButtonOpt.h"
#import "NavigationScrollView.h"
#import "BuyOrdersController.h"
#import "ManagerController.h"
#import "MessageViewController.h"
#import "DataController.h"


@interface MainController ()
@property (strong, nonatomic) IBOutlet UIView *viewMain;
@property (strong, nonatomic) NavigationScrollView *viewOpt;
@property (nonatomic,strong) ScrollButtonOpt *viewButtom;
@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewButtom = [ScrollButtonOpt new];
    _viewButtom.frame = CGRectMake(0, 0, APP_W, 44);
    _viewButtom.values = @[@"下单",@"管理",@"消息",@"数据"];
    _viewButtom.backgroundColor = [UIColor redColor];
    [_viewButtom autoresizingMask_TLR];
    [self.viewMain addSubview:_viewButtom];
    _viewOpt = [NavigationScrollView new];
    _viewOpt.backgroundColor = [UIColor clearColor];
    _viewOpt.frame = CGRectMake(0, 0, APP_W, APP_H-44);
    [self.viewMain addSubview:_viewOpt];
    // Do any additional setup after loading the view from its nib.
    
    BuyOrdersController *epc = [[BuyOrdersController alloc] initWithNibName:@"BuyOrdersController" bundle:nil];
    ManagerController *mc = [[ManagerController alloc] initWithNibName:@"ManagerController" bundle:nil];
    MessageViewController *msg = [[MessageViewController alloc] init];
    DataController *data = [[DataController alloc] init];
    
    _viewOpt.parsentController = self;
    _viewOpt.arrayControllers = [NSArray arrayWithObjects:epc,mc,msg,data,nil];
    
    __weak typeof(self) weakself =self;
    [_viewOpt setCallBackScrollEnd:^int(int showIndex, id userInfo) {
        weakself.viewButtom.showIndex = showIndex;
        return 1;
    }];
    [_viewButtom setCallBackScrollEnd:^int(int showIndex, id userInfo) {
        [weakself.viewOpt setShowIndex:showIndex];
        return 1;
    }];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect r = _viewButtom.frame;
    r.origin.y = self.viewMain.frame.size.height - r.size.height;
    _viewButtom.frame = r;
    _viewButtom.showIndex = 4;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setArrayControllers:(NSMutableArray *)arrayControllers{
    _arrayControllers = arrayControllers;
    for (id target in _arrayControllers) {
        if ([target isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = target;
            UIView *view = vc.view;
            CGRect r = _viewOpt.frame;
            view.frame = r;
            [_viewOpt addSubview:view];
        }
    }
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
