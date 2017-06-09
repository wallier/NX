//
//  BNAllCommunityModel.h
//  WorkBench
//
//  Created by wanwan on 16/8/23.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNAllCommunityModel : NSObject
/** 小区唯一编码 */
@property (nonatomic, strong) NSString *REGION_ID;
/** 小区名称 */
@property (nonatomic, strong) NSString *REDION_NAME;
/** 小区地址 */
@property (nonatomic, strong) NSString *REDION_ADDRESS;
@end
