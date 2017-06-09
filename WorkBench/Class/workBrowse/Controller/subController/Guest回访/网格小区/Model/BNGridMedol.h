//
//  BNGridMedol.h
//  WorkBench
//
//  Created by wanwan on 16/8/13.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNGridMedol : NSObject
/** 网格ID */
@property (nonatomic, strong) NSString *WG_ID;
/** 网格名称 */
@property (nonatomic, strong) NSString *WG_DESC;
/** 网格经理名字 */
@property (nonatomic, strong) NSString *WG_COMMANDER;
/** 网格下小区数 */
@property (nonatomic, strong) NSNumber *REGION_NUM;

@end
