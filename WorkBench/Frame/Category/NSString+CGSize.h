//
//  NSString+CGSize.h
//  发微博界面1
//
//  Created by xiaos on 15/11/3.
//  Copyright © 2015年 com.xsdota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (CGSize)

/** 计算字符串在一定宽度下的rect */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
/** 计算字符串在最大宽度下的rect */
- (CGSize)sizeWithFont:(UIFont *)font;
/** 返回字符串的字数（支持中英数字混排） */
+ (NSUInteger)convertToInt:(NSString*)strtemp;
/** 返回手机型号 */
+ (NSString *)phoneType;
/** 返回时间戳 */

- (NSString *)md5String;

@end
