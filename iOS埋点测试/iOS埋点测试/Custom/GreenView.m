//
//  GreenView.m
//  iOS埋点测试
//
//  Created by 李国卿 on 2019/11/6.
//  Copyright © 2019 李国卿. All rights reserved.
//

#import "GreenView.h"
#import "YellowView.h"

@interface GreenView()
@property (nonatomic, strong) YellowView *yellowView;
@end

@implementation GreenView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        CGFloat greenBtnY = frame.size.height/2-30;
        UIButton *greenBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,greenBtnY, 50, 30)];
        greenBtn.backgroundColor = [UIColor whiteColor];
        [greenBtn setTitle:@"按钮1" forState:UIControlStateNormal];
        [greenBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [greenBtn addTarget:self action:@selector(greenViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:greenBtn];
    }
    return self;
}
- (void)greenViewAction:(UIButton *)sender{
    NSLog(@"-----greenView------");
    [self addSubview:self.yellowView];
}
- (YellowView *)yellowView{
    if (!_yellowView) {
        _yellowView = [[YellowView alloc]initWithFrame:CGRectMake(70, 10, self.frame.size.width-70, self.frame.size.height-20)];
    }
    return _yellowView;
}



@end
