//
//  Tools.h
//  WorkBench
//
//  Created by wouenlone on 16/8/18.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+ (instancetype) sharedGestVisitTools;
//传入一个view 给view设置背景
- (void) setBackgroundImageWithView:(UIView*) view;
//给传入的view下边沿描边并返回
- (UIView *) marginOfViewAtBottm:(UIView *)view withColor:(UIColor *)color width:(NSInteger) width;

@end
