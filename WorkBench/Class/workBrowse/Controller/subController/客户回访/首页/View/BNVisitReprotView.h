//
//  BNVisitReprotView.h
//  WorkBench
//
//  Created by mac on 16/2/24.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNReprotView.h"
typedef void(^SENDDATA) (id,NSIndexPath *);
@interface BNVisitReprotView : BNReprotView
@property (nonatomic, strong) NSMutableArray *cellVisitArray;
@property (nonatomic, strong) SENDDATA sendData;

@end
