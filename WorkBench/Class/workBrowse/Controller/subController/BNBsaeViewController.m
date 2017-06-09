//
//  BNBsaeViewController.m
//  WorkBench
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNBsaeViewController.h"
#import "BNRightViewController.h"
#import "CATransition+transition.h"
#import <MMDrawerBarButtonItem.h>
#import <MMDrawerVisualState.h>
#import "BNNavigationController.h"
#import "BNMenuModel.h"

@interface BNBsaeViewController ()

@end

@implementation BNBsaeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}


- (MMDrawerController *)setRootViewController{

    BNRightViewController *rightMenuVc = [[BNRightViewController alloc] init];
    
    BNNavigationController *navRight= [[BNNavigationController alloc] initWithRootViewController:rightMenuVc];
    
    //leftBarButtonItem
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setFrame:CGRectMake(0, 0,30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeCenter];
    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    //rightBarbuttonItem
    MMDrawerBarButtonItem *item = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(Move)];
    BNNavigationController *navLeft= [[BNNavigationController alloc] initWithRootViewController:self];
    self.navigationItem.rightBarButtonItem = item;
    

    MMDrawerController *rootView = [[MMDrawerController alloc] initWithCenterViewController:navLeft rightDrawerViewController:navRight];
   
    
    rootView.maximumRightDrawerWidth = 200;
    // 设置侧拉门开与关的动画
    [rootView setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [rootView setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeCustom];
    
    /**
     *  动画效果
     *  @param drawerController 主控制器
     *  @param drawerSide       左右控制器
     *  @param percentVisible   左右控制器在拉动过程中出现的百分比
     *
     */
    [rootView setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
            UIViewController *sideDrawerViewController = drawerController.rightDrawerViewController;
            CGFloat distance = MAX(drawerController.maximumRightDrawerWidth,drawerController.visibleRightDrawerWidth);
            CATransform3D  transform;
            if(percentVisible <= 1.f){
                transform = CATransform3DMakeTranslation(distance - distance * percentVisible, 0.0, 0.0);
            }
            else{
                transform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
                transform = CATransform3DTranslate(transform, -drawerController.maximumRightDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
            }
            
            [sideDrawerViewController.view.layer setTransform:transform];

        }];
    rightMenuVc.mmdrawer = rootView;
    //侧开内容展示效果
    self.rootVc = rootView;
    return rootView;
    
}

- (void)Move{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}



- (void)Back{
    
     CATransition *animation = [[CATransition alloc] transitionWithType:@"rippleEffect"
                                                             andSubType:kCATransitionFromRight];
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    
   [self dismissViewControllerAnimated:YES completion:nil];
    [self dealDate];
}
#pragma mark - 子类处理返回接口
- (void)dealDate{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
