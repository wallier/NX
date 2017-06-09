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



// PRODUCT_TYPE --> 产品类别（固话：1，宽带：2，手机：3，IPTV：4）
//OPERATOR_TYPE --> 运营商（电信：1，移动：2，联通：3，未知：4）
- (NSString *)getOperatorNameByOPERATOR_TYPEinParam:(NSString *)OPERATOR_TYPE;

- (NSString *)getOPERATOR_TYPEinParamByOperatorName:(NSString *)operatorName;

- (NSString *)getProductNameByPRODUCT_TYPEinParam:(NSString *)PRODUCT_TYPE;

- (NSString *)getPRODUCT_TYPEinParamByProductName:(NSString *)ProductName;

- (void) testSpendTimeWithFunctionName:(NSString *)functionName;
@end
