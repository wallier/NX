//
//  BNBaseSetCell.m
//  WorkBench
//
//  Created by mac on 16/2/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNBaseSetCellModel.h"

@implementation BNBaseSetCellModel

- (instancetype)initwithTitle:(NSString *)title Image:(NSString *)Img andTypt:(int)type{

    BNBaseSetCellModel *model = [[BNBaseSetCellModel alloc] init];
    model.title = title;
    model.type = type;
    model.ImgName = Img;

    return model;
}

@end
