//
//  UIBarButtonItem+BNBarItems.h
//  WorkBench
//
//  Created by wanwan on 16/8/23.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BNBarItems)

+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName withHighLightedImage:(NSString *)hlImageName withTarget:(id)target withAction:(SEL)action;

@end
