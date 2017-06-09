//
//  BNMetaDataTools.h
//  WorkBench
//
//  Created by wanwan on 16/8/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNMetaDataTools : NSObject
/** 返回所有的网格角色数据数组 */
+ (NSArray *)getGridRoleModelArray:(NSArray *)dicArr;
/** 返回所有的网格数据数组 */
//+ (NSArray *)getAllGridModelArray:(NSArray *)dicArr;
/** 返回所有的网格下小区数据数组 */
+ (NSArray *)getCommunityModelArray:(NSArray *)dicArr;
/** 返回所有小区数据数组 */
+ (NSArray *)getAllCommunityModelArray:(NSArray *)dicArr;
/** 返回所有单元楼梗概信息 */
+ (NSArray *)getUnitSummaryModelArray:(NSArray *)dicArr;
/** 返回所有单元楼梗概信息 */
+ (NSArray *)getUnitDetailModelArray:(NSArray *)dicArr;

@end
