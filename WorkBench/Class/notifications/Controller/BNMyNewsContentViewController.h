//
//  BNMyNewsContentViewController.h
//  WorkBench
//
//  Created by wanwan on 16/10/21.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNMyNewsContentViewController : UIViewController
// 截止某天过期人数
@property (nonatomic, strong) NSString *deadLineNums;
// 日期
@property (nonatomic, strong) NSString *date;
@end
