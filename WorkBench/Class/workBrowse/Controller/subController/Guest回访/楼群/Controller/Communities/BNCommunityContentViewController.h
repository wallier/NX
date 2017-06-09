//
//  BNCommunityContentViewController.h
//  WorkBench
//
//  Created by wouenlone on 16/8/13.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNCommunityContentViewController : UIViewController
// 传入小区编码 和网格编码
@property (nonatomic, strong) NSDictionary *params;
/** 小区Name */
@property (nonatomic,copy) NSString *name;


@end
