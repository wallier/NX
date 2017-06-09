//
//  ResultModel.m
//  WorkBench
//
//  Created by xiaos on 15/12/3.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "ResultModel.h"

#import "NSDate+YYAdd.h"

@implementation ResultModel

- (void)setPUBLISH_TIME:(NSString *)PUBLISH_TIME
{
    _PUBLISH_TIME = PUBLISH_TIME;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat       = @"yyyy/MM/dd HH:mm";
    formatter.locale           = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *date               = [formatter dateFromString:PUBLISH_TIME];
    _PUBLISH_TIME              = [date timeAgo];
}
@end
