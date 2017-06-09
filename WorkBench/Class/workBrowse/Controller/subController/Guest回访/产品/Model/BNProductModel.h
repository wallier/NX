//
//  BNProductModel.h
//  WorkBench
//
//  Created by wouenlone on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNProductModel : NSObject
@property (nonatomic,copy) NSString *OPERATOR_TYPE;//运营商
@property (nonatomic,copy) NSString *PRODUCT_ID;//用户产品信息编号
@property (nonatomic,copy) NSString *PACKAGE_MEAL;//套餐
@property (nonatomic,copy) NSString *EXPIRE;//到期时间
@property (nonatomic,copy) NSString *PRODUCT_RATE;//速率
@property (nonatomic,copy) NSString *PRODUCT_TYPE;//产品类别 固话、移动、宽带、ITV
@property (nonatomic,copy) NSString *USER_NUMBER;//用户号码
@property (nonatomic,copy) NSString *note;//备注
@property (nonatomic,copy) NSString *IS_OCCUPY;//他网占我网

+ (NSArray *)getProductModelFromDic:(NSDictionary *)dic;


@end
