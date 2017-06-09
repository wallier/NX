//
//  CATransition+transition.m
//  WorkBench
//
//  Created by mac on 16/1/21.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "CATransition+transition.h"

@implementation CATransition (transition)
- (CATransition *)transitionWithType:(NSString *)type andSubType:(NSString *)subType{
    CATransition *animation = [[CATransition alloc] init];
    animation.duration = 1.0f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = type;
    animation.subtype = subType;
    
    return animation;
}

@end
