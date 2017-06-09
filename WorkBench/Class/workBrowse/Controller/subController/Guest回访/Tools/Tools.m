//
//  Tools.m
//  WorkBench
//
//  Created by wouenlone on 16/8/18.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "Tools.h"

@implementation Tools
static Tools *tool = nil;
+ (instancetype)sharedGestVisitTools
{
    if (tool == nil) {
        tool = [[Tools alloc]init];
    }
    return tool;
}

- (void)setBackgroundImageWithView:(UIView *)view
{
   
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];

}

//给一个view 下边沿描边
- (UIView *) marginOfViewAtBottm:(UIView *)view withColor:(UIColor *)color width:(NSInteger) width
{
    CALayer *bottom = [CALayer layer];
    if (view.tag == 4) {
        bottom.frame = CGRectMake(20, view.frame.size.height-width, view.frame.size.width-90, width);
    }else{
    bottom.frame = CGRectMake(20, view.frame.size.height-width, view.frame.size.width-40, width);
    }
    bottom.backgroundColor = color.CGColor;
    [view.layer addSublayer:bottom];
    
    return view;
}
@end
