//
//  Test2ViewController.m
//  AopTestDemo
//
//  Created by ChenMan on 2018/4/25.
//  Copyright © 2018年 cimain. All rights reserved.
//

#import "Test2ViewController.h"

@interface Test2ViewController ()

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Test2ViewController";
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 80, 100, 80)];
    [btn1 setTitle:@"btn1" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor redColor];
    btn1.tag = 100;
    [btn1 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 180, 100, 80)];
    [btn2 setTitle:@"btn2" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor redColor];
    btn2.tag = 101;
    [btn2 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 280, 100, 80)];
    [btn3 setTitle:@"btn3" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor redColor];
    btn3.tag = 103;
    [btn3 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(100, 380, 100, 80)];
    [btn4 setTitle:@"btn4" forState:UIControlStateNormal];
    btn4.backgroundColor = [UIColor redColor];
    btn4.tag = 104;
    [btn4 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)action:(UIButton *)sender{
    switch (sender.tag) {
        case 100:
        {
            NSLog(@"----btn1-----");
            break;
        }
        case 101:
        {
            NSLog(@"----btn2-----");
            break;
        }
        case 102:
        {
            NSLog(@"----btn3-----");
            break;
        }
        case 103:
        {
            NSLog(@"----btn4-----");
            break;
        }
        default:
            break;
    }
}

@end
