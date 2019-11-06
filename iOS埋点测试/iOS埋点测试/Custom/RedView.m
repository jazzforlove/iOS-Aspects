//
//  RedView.m
//  iOS埋点测试
//
//  Created by 李国卿 on 2019/11/5.
//  Copyright © 2019 李国卿. All rights reserved.
//

#import "RedView.h"
#import "GreenView.h"

@interface RedView()
@property (nonatomic, strong) GreenView *greenView;
@end

@implementation RedView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        CGFloat redBtnY = frame.size.height/2-30;
        UIButton *redBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,redBtnY, 50, 30)];
        redBtn.backgroundColor = [UIColor whiteColor];
        [redBtn setTitle:@"按钮1" forState:UIControlStateNormal];
        [redBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [redBtn addTarget:self action:@selector(redViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:redBtn];
    }
    return self;
}


- (void)redViewAction:(UIButton *)sender{
    NSLog(@"-------redBtn-------");
    [self addSubview:self.greenView];
}
- (GreenView *)greenView{
    if (!_greenView) {
        _greenView = [[GreenView alloc]initWithFrame:CGRectMake(70, 10, self.frame.size.width-80, self.frame.size.height-20)];
    }
    return _greenView;
}

@end
