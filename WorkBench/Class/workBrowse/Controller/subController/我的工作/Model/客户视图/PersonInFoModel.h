//
//  PersonInFoModel.h
//  WorkBench
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonInFoModel : NSObject
@property (nonatomic,strong)NSString *khmc;
@property (nonatomic,strong)NSString *zdph;
@property (nonatomic,strong)NSString *khfq;
@property (nonatomic,strong)NSString *fflx;
@property (nonatomic,strong)NSString *rwsj;
@property (nonatomic,strong)NSString *yhtc;
@property (nonatomic,strong)NSArray *arrItems;
@property (nonatomic,strong)NSArray *arrValues;

+ (instancetype)initWithPersonInFoModel:(id)dic;
@end
