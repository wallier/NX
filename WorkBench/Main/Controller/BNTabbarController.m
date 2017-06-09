//
//  BNTabbarController.m
//  WorkBench
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNTabbarController.h"

@implementation BNTabbarController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTabbar];
    
}
- (void)setTabbar{
     self.tabBar.translucent = NO;
  //  [self.tabBar setBarTintColor:RGB(255,170,50)];//Colros(215, 233, 244)
    self.tabBar.tintColor = RGB(255,170,50);
    self.tabBar.barTintColor = [UIColor whiteColor];
    
}
@end
