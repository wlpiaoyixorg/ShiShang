//
//  MessageViewController.m
//  Data
//
//  Created by torin on 14/11/27.
//  Copyright (c) 2014年 tt_lin. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController()<UISearchBarDelegate>
{
    
}

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frameHeight = appHeight()-SSCON_TOP-SSCON_BUTTOM - SSCON_TIT;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"消 息"];
//    self.view.backgroundColor = [UIColor whiteColor];
//    UISearchBar *search = [[UISearchBar alloc] init];
//    search.delegate = self;
//    search.frame = CGRectMake(0, 64, 320, 44);
//    [self.view addSubview:search];
}

@end
