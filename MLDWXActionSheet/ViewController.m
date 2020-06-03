//
//  ViewController.m
//  MLDWXActionSheet
//
//  Created by MoliySDev on 2020/6/3.
//  Copyright © 2020 MoliySDev. All rights reserved.
//

#import "ViewController.h"
#import "MLDWXActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button];
    button.backgroundColor = UIColor.redColor;
    button.frame = CGRectMake(100, 100, 100, 100);
    [button addTarget:self
               action:@selector(showAction)
     forControlEvents:UIControlEventTouchUpInside];
}

- (void)showAction {
    MLDWXActionSheet *action = [MLDWXActionSheet actionSheetWithTitle:@""
                                                             confirms:@[@"拍摄",@"从手机相册选择"]
                                                               cancel:@"取消"
                                                                style:MLDWXActionSheetStyleDestructive click:^(NSInteger index) {
        
    }
                                                                hiden:^{
        
    }];
    [action showInView:self.view];
}




@end
