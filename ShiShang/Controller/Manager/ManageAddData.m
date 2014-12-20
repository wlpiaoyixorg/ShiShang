//
//  ManageAddData.m
//  ShiShang
//
//  Created by wlpiaoyi on 14/12/18.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ManageAddData.h"

@interface ManageAddData()
@property (assign,nonatomic) id target;
@property (nonatomic) SEL action;
@property (strong, nonatomic) IBOutlet UILabel *lableTitle;
@property (strong, nonatomic) IBOutlet UITextField *textFieldName;
@property (strong, nonatomic) IBOutlet UITextField *textFiledPrice;

@end

@implementation ManageAddData

- (void)awakeFromNib{
    _textFieldName.delegate = _textFiledPrice.delegate = self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField==_textFieldName) {
        [_textFiledPrice becomeFirstResponder];
    }else if(textField==_textFiledPrice){
        if (_target&&_action&&[_target respondsToSelector:_action]) {
            [_target respondsToSelector:_action];
        }
    }
    
    return YES;
}


-(BOOL) resignFirstResponder{
    [self.textFieldName resignFirstResponder];
    [self.textFiledPrice resignFirstResponder];
    return [super resignFirstResponder];
}
-(void) dealloc{
    [self resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
