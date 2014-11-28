//
//  RegeditController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-7.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "RegeditController.h"

@interface RegeditController (){
}
@property (nonatomic) CGRect rectVBI;
@property (nonatomic) CGRect rectVVD;
@property (strong, nonatomic) IBOutlet UIView *viewBaseInfo;
@property (strong, nonatomic) IBOutlet UIView *viewValidate;
@property (strong, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword2;
@property (strong, nonatomic) IBOutlet UITextField *textFieldValidate;
@property (strong, nonatomic) IBOutlet UIButton *buttonValidate;
@property (strong, nonatomic) IBOutlet UIButton *buttonRegedit;

@end

@implementation RegeditController

- (void)viewDidLoad {
    [super setTitle:@"注 册"];
    [super viewDidLoad];
    
    [_viewBaseInfo setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [_viewValidate setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [_textFieldPassword setCornerRadiusAndBorder:0 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    
    
    _viewValidate.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    _viewBaseInfo.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    
    __weak typeof(self) weakself = self;
    [super setSELShowKeyBoardStart:^{
        weakself.viewBaseInfo.frame = weakself.rectVBI;
        weakself.viewValidate.frame = weakself.rectVVD;
    } End:^(CGRect keyBoardFrame) {
        CGRect r = weakself.rectVBI;
        CGRect r2 = weakself.rectVVD;
        float offy = r2.origin.y+r2.size.height-keyBoardFrame.origin.y;
        if (offy > 0) {
            r.origin.y -= offy;
            r2.origin.y -= offy;
        }
        weakself.viewBaseInfo.frame = r;
        weakself.viewValidate.frame = r2;
    }];
    [super setSELHiddenKeyBoardBefore:^{
        
    } End:^(CGRect keyBoardFrame) {
        weakself.viewBaseInfo.frame = weakself.rectVBI;
        weakself.viewValidate.frame = weakself.rectVVD;
        
    }];
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.rectVBI = self.viewBaseInfo.frame;
    self.rectVVD = self.viewValidate.frame;
    
}

-(void) onclickRegedit{
    NSString *userName = _textFieldUserName.text;
    NSString *passowrd = _textFieldPassword.text;
    NSString *passowrd2 = _textFieldPassword2.text;
    
    if (![NSString isEnabled:userName]) {
        PopUpDialogView *pdv = [PopUpDialogView initWithTitle:@"提示" message:@"请输入手机号!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [pdv show];
        return;
    }
    if (![NSString isEnabled:passowrd]) {
        PopUpDialogView *pdv = [PopUpDialogView initWithTitle:@"提示" message:@"请输入密码!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [pdv show];
        return;
    }
    if (![NSString isEnabled:passowrd2]) {
        PopUpDialogView *pdv = [PopUpDialogView initWithTitle:@"提示" message:@"请确认密码!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [pdv show];
        return;
    }
    if(![passowrd isEqualToString:passowrd2]){
        PopUpDialogView *pdv = [PopUpDialogView initWithTitle:@"提示" message:@"两次密码出入不一致!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [pdv show];
        return;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) resignFirstResponder{
    [_textFieldUserName resignFirstResponder];
    [_textFieldPassword resignFirstResponder];
    [_textFieldPassword2 resignFirstResponder];
    [_textFieldValidate resignFirstResponder];
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
