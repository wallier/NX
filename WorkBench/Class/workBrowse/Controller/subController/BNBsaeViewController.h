//
//  BNBsaeViewController.h
//  WorkBench
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIViewController+MMDrawerController.h>
#import "BNMenuModel.h"
@interface BNBsaeViewController : UIViewController
@property (nonatomic, strong) BNMenuModel *menuModel;
@property (nonatomic, weak) MMDrawerController *rootVc;

- (MMDrawerController *)setRootViewController;
@end
