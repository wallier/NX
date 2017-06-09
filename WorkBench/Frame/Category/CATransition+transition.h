//
//  CATransition+transition.h
//  WorkBench
//
//  Created by mac on 16/1/21.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CATransition (transition)
- (CATransition *)transitionWithType:(NSString *)type andSubType:(NSString *)subType;
@end
