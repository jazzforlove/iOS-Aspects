//
//  YellowView.m
//  iOS埋点测试
//
//  Created by 李国卿 on 2019/11/6.
//  Copyright © 2019 李国卿. All rights reserved.
//

#import "YellowView.h"


@implementation YellowView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        CGFloat yellowBtnY = frame.size.height/2-30;
        UIButton *yellowBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, yellowBtnY, 50, 30)];
        yellowBtn.backgroundColor = [UIColor whiteColor];
        [yellowBtn setTitle:@"按钮1" forState:UIControlStateNormal];
        [yellowBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [yellowBtn addTarget:self action:@selector(yellowViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:yellowBtn];
    }
    return self;
}

- (void)yellowViewAction:(UIButton *)sender{
    NSLog(@"------yellowBtn-------");
}

@end
