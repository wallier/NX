//
//  KHGroupModel.h
//  WorkBench
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHCellModel.h"

@interface KHGroupModel : NSObject
@property(nonatomic,strong)NSString *headView;
@property(nonatomic,strong)NSString *footView;
@property(nonatomic,strong)NSMutableArray *arrCellModel;
@end
