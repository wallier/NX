//
//  BNOtherNetModel.h
//  WorkBench
//
//  Created by wouenlone on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNOtherNetModel : NSObject
@property (nonatomic,copy) NSString *REDION_NAME;//小区名称
@property (nonatomic,copy) NSString *FIND_TIME;//发现时间
@property (nonatomic,copy) NSString *BUILDING_NO;//楼号
@property (nonatomic,copy) NSString *FIND_PERSON;//发现人
@property (nonatomic,copy) NSString *UNIT_NO;//用户所属单元编号
@property (nonatomic,copy) NSString *ROOT_NO;//用户门牌号

- (instancetype) initWithDictionary:(NSDictionary *)dic;

@end
