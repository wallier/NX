//
//  NSString+BNDate__String.h
//  WorkBench
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BNDate__String)

+ (NSDate *)ChangeStringToDate:(NSString *)string andFromater:(NSString *)format;
+ (NSString *)ChangeDateToString:(NSDate *)date andFormater:(NSString *)format;
- (NSString *)dateJudgeIsDay:(BOOL)flay;
- (NSString *)datajudgeIsNull;
@end
