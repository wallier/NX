//
//  PersonInFoModel.m
//  WorkBench
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "PersonInFoModel.h"
#import "BNLDModel.h"
@implementation PersonInFoModel
+ (instancetype)initWithPersonInFoModel:(id)dic{
    BNLDModel *model = dic;
    PersonInFoModel *person = [[PersonInFoModel alloc] init];
    person.arrItems = @[@"客户名称",@"终端偏好",@"客户分群",@"付费类型",@"入网时间",@"用户套餐"];
    person.khmc = model.USER_NAME;
    person.zdph = model.TERMINAL_INTEREST;
    person.khfq = [model.USER_KIND substringFromIndex :5];
    person.fflx = [model.USER_INTEREST substringFromIndex:5];;
    person.rwsj = model.START_DATE;
    person.yhtc = model.OFFER_BRAND;
    person.arrValues = @[person.khmc,person.zdph,person.khfq,person.fflx,person.rwsj,person.yhtc];
    return person;
}


@end
