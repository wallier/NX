//
//  BNAddRecordModel.h
//  WorkBench
//
//  Created by mac on 16/3/1.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNEveryVisitModel.h"
#import "BNProOneModel.h"
#import "BNVisitModel.h"

@interface BNAddRecordModel : NSObject
@property (nonatomic, strong) BNEveryVisitModel *model1;
@property (nonatomic, strong) BNProOneModel *model2;
@property (nonatomic, strong) BNVisitModel *model3;
+(instancetype)shareInstance;
@end
