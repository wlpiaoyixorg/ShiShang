//
//  ManagerController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/11/21.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ManagerController.h"

@interface ManagerController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionManager;

@end

@implementation ManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"管 理"];
    [self showReturnButton:NO];
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect r = self.view.frame;
    r.size.height-=44;
    self.view.frame = r;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
