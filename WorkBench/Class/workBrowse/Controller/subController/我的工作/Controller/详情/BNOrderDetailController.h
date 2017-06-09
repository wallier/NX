//
//  BNOrderDetailController.h
//  WorkBench
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNOrderDetailController : UIViewController
@property (nonatomic, strong) NSMutableArray *arrModel;
@property (nonatomic, assign) int maxCout;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSString *url;

- (void)setNavLeftTitle:(NSString *)title;
@end
