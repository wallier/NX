//
//  BNApartmentTableViewHeaderView.h
//  WorkBench
//
//  Created by wouenlone on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNApartmentTableViewHeaderView : UIView
//传入一个地址(必须是带有空格 符合显示格式的参数) 参数 得到头部视图
+ (UIView *) getApartmentTableViewHeadViewWithAddress:(NSString *)address;
@end
