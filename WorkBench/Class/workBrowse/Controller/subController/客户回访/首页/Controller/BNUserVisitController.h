//
//  BNUserVisitController.h
//  WorkBench
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNBsaeViewController.h"
#import "BNVisitReprotView.h"
@interface BNUserVisitController : BNBsaeViewController
@property (nonatomic, strong) BNVisitReprotView *reprotView;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)getRequest:(NSDictionary *)param;

@end
