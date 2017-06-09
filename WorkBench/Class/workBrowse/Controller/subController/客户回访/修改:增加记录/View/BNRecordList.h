//
//  BNRecordList.h
//  WorkBench
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNProductLists.h"
typedef void (^SendList) (NSDictionary *);
@interface BNRecordList : BNProductLists
@property (nonatomic, strong) SendList sendList;

@end
