//
//  EditPasswordController.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-7.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EditPasswordController.h"
#import "UserService.h"
#import "EntityUser.h"

@interface EditPasswordController ()
@property (nonatomic) CGRect rectKeyBorde;
@property (strong, nonatomic) UserService *userService;
@property (strong, nonatomic) IBOutlet UIView *viewValidate;
@property (strong, nonatomic) IBOutlet UITextField *textFiledPhone;
@property (strong, nonatomic) IBOutlet UITextField *textFiledValidate;
@property (strong, nonatomic) IBOutlet UIButton *buttonValidate;
@property (strong, nonatomic) IBOutlet UIView *viewPassowrd;
@property (strong, nonatomic) IBOutlet UITextField *textFiledPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFiledPassword2;
@property (strong, nonatomic) IBOutlet UIButton *buttonConfirm;

@end

@implementation EditPasswordController

- (void)viewDidLoad {
    [super setTitle:@"重置/修改密码"];
    [super viewDidLoad];
    _userService = [UserService new];
    
    [_viewValidate setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [_textFiledValidate setCornerRadiusAndBorder:0 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [_textFiledPhone setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    
    [_viewPassowrd setCornerRadiusAndBorder:5 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    [_textFiledPassword setCornerRadiusAndBorder:0 BorderWidth:0.5 BorderColor:[self.dicskin getSkinColor:@"bordercolordefault"]];
    
    
    _textFiledPhone.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    _viewPassowrd.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    _viewValidate.backgroundColor = [[SkinDictionary getSingleInstance] getSkinColor:@"textfiledview_bg_color"];
    
    [_buttonConfirm addTarget:self action:@selector(onclickEdit)];
    
    _textFiledPassword.delegate =
    _textFiledPassword2.delegate =
    _textFiledPhone.delegate =
    _textFiledValidate.delegate = self;
    
    __weak typeof(self) weakself = self;
    [super setSELShowKeyBoardStart:^{
        
    } End:^(CGRect keyBoardFrame) {
        weakself.rectKeyBorde = keyBoardFrame;
        
        UITextField *tf = [weakself getResonderTextField];
        if (!tf) {
            return ;
        }
        CGPoint p = [tf getAbsoluteOrigin:weakself.view];
        float offy = p.y+tf.frame.size.height+keyBoardFrame.size.height-weakself.view.frame.size.height;
        if (offy>0) {
            CGRect r = weakself.view.frame;
            r.origin.y = -offy;
            weakself.view.frame = r;
        }
    }];
    [super setSELHiddenKeyBoardBefore:^{
        
    } End:^(CGRect keyBoardFrame) {
        CGRect r = weakself.view.frame;
        r.origin.y = 0;
        weakself.view.frame = r;
        
    }];
    // Do any additional setup after loading the view from its nib.
}

-(void) onclickEdit{
    [self resignFirstResponder];
    
}

#pragma ==> <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_textFiledPhone.isFirstResponder) {
        [_textFiledValidate becomeFirstResponder];
    }else if (_textFiledValidate.isFirstResponder) {
        [_textFiledPassword becomeFirstResponder];
    }else if (_textFiledPassword.isFirstResponder) {
        [_textFiledPassword2 becomeFirstResponder];
    }else if (_textFiledPassword2.isFirstResponder) {
        [self onclickEdit];
    }
    [UIView animateWithDuration:0.3f animations:^{
        self->showEnd(self.rectKeyBorde);
    }];
    return YES;
}
#pragma <==


-(UITextField*) getResonderTextField{
    if (_textFiledPhone.isFirstResponder) {
        return _textFiledPhone;
    }
    if (_textFiledValidate.isFirstResponder) {
        return _textFiledValidate;
    }
    if (_textFiledPassword.isFirstResponder) {
        return _textFiledPassword;
    }
    if (_textFiledPassword2.isFirstResponder) {
        return _textFiledPassword2;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    [self resignFirstResponder];
}

-(BOOL) resignFirstResponder{
    [_textFiledPhone resignFirstResponder];
    [_textFiledValidate resignFirstResponder];
    [_textFiledPassword resignFirstResponder];
    [_textFiledPassword2 resignFirstResponder];
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
