//
//  LoginController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-4.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "LoginController.h"
#import "RegeditController.h"
#import "UserService.h"
#import "EditPasswordController.h"
#import "MainController.h"

@interface LoginController (){
    
}

@property (nonatomic) CGRect rectViewFiled;;

@property (strong, nonatomic) IBOutlet UIView *viewField;
@property (strong, nonatomic) IBOutlet UITextField *textFieldAccount;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (strong, nonatomic) IBOutlet UIView *viewButton;
@property (strong, nonatomic) IBOutlet UIButton *buttonRegedit;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;
@property (strong, nonatomic) IBOutlet UIButton *buttonEditPassword;


@end

@implementation LoginController

- (void)viewDidLoad {
    [self setTitle:@"登  录"];
    [super viewDidLoad];
    [super showReturnButton:NO];
    
    
    
    [self.viewField setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [self.textFieldAccount setCornerRadiusAndBorder:0 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [self.textFieldPassword setCornerRadiusAndBorder:0 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    self.viewField.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    
    
    [_buttonLogin addTarget:self action:@selector(onclickLogin)];
    [_buttonRegedit addTarget:self action:@selector(onclickRegedit)];
    [_buttonEditPassword addTarget:self action:@selector(onclickEditPassword)];
    
    __weak typeof(self) weakself = self;
    [super setSELShowKeyBoardStart:^{
        weakself.viewField.frame = weakself.rectViewFiled;
    } End:^(CGRect keyBoardFrame) {
        CGRect r = weakself.rectViewFiled;
        float offy = r.origin.y+r.size.height-keyBoardFrame.origin.y;
        if (offy > 0) {
            r.origin.y -= offy;
        }
        weakself.viewField.frame = r;
    }];
    [super setSELHiddenKeyBoardBefore:^{
        
    } End:^(CGRect keyBoardFrame) {
        weakself.viewField.frame = weakself.rectViewFiled;
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _rectViewFiled = _viewField.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onclickRegedit{
    RegeditController *rc = [[RegeditController alloc] initWithNibName:@"RegeditController" bundle:nil];
    [super goNextController:rc];
}

-(void) onclickLogin{
    
    
    NSString *userName = self.textFieldAccount.text;
    NSString *password = self.textFieldPassword.text;
    
    
    if (![NSString isEnabled:userName]) {
        PopUpDialogView *pdv = [PopUpDialogView initWithTitle:@"提示" message:@"请输入手机号!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [pdv show];
        return;
    }
    if (![NSString isEnabled:password]) {
        PopUpDialogView *pdv = [PopUpDialogView initWithTitle:@"提示" message:@"请输入密码!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [pdv show];
        return;
    }
    [ActivityIndicatorView showActivityIndicator:nil];
    [[UserService new] loginWithUserName:userName password:password success:^(id data, NSDictionary *userInfo) {
        [ActivityIndicatorView hideActivityIndicator];
    } faild:^(id data, NSDictionary *userInfo) {
        
        [Common setNavigationController: [[MainController alloc] initWithNibName:@"MainController" bundle:nil] window:[Common getWindow]];
        [Common setNavigationBarHidden:NO];
        [Common getWindow].backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"window_bg_color"];
        [ActivityIndicatorView hideActivityIndicator];
    }];
}
-(void) onclickEditPassword{
    EditPasswordController *epc = [[EditPasswordController alloc] initWithNibName:@"EditPasswordController" bundle:nil];
    [super goNextController:epc];
}
-(BOOL) resignFirstResponder{
    [_textFieldAccount resignFirstResponder];
    [_textFieldPassword resignFirstResponder];
    return [super resignFirstResponder];
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