//
//  NSString+BNDate__String.m
//  WorkBench
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "NSString+BNDate__String.h"

@implementation NSString (BNDate__String)

+ (NSDate *)ChangeStringToDate:(NSString *)string andFromater:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
}

+ (NSString *)ChangeDateToString:(NSDate *)date andFormater:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
    
}


- (NSString *)dateJudgeIsDay:(BOOL)flay{
    NSMutableString *str = [NSMutableString stringWithString:self];
    [str insertString:@"/" atIndex:4];
    
    if (flay) {
        
        [str insertString:@"/" atIndex:7];
    }
    
    return str;
}

- (NSString *)datajudgeIsNull{
    if (!self) {
        return @"0";
    }
    return self;
}
@end
