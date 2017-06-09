//
//  BNNavigationController.m
//  WorkBench
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNNavigationController.h"

@interface BNNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BNNavigationController

+ (void)initialize{
    [self setNav];
}

+ (void)setNav{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:Colros(250,188,101)];
    [bar setTintColor:[UIColor whiteColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    bar.translucent = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 自定义返回按钮后滑动返回失效 */
    self.delegate = self;
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UINavigationControllerDelegate

/** 处理自定义返回按钮后的手势 */
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //是根控制器 关闭主界面的滑动返回
    if (viewController == self.viewControllers[0]) {
        
        self.interactivePopGestureRecognizer.enabled = NO;
    }else{
        //非根控制器 开启滑动返回
        if (!self.interactivePopGestureRecognizer.enabled) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}



@end
