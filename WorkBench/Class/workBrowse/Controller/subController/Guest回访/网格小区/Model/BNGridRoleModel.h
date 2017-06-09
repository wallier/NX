//
//  BNGridRoleModel.h
//  WorkBench
//
//  Created by wanwan on 16/9/21.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNGridRoleModel : NSObject
/** 当前组织机构类型ORG_MANAGER_TYPE */
@property (nonatomic, strong) NSString *ORG_MANAGER_TYPE;
/** 当前组织机构编码ID */
@property (nonatomic, strong) NSString *ID;
/** 当前组织机构名称 */
@property (nonatomic, strong) NSString *NAME;
/** 组织机构负责人 */
@property (nonatomic, strong) NSString *USER_NAME;
/** 组织机构下小区数量 */
@property (nonatomic, strong) NSNumber *REGION_NUM;

@end
