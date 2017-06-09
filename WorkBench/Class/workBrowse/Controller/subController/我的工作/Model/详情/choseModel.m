//
//  choseModel.m
//  WorkBench
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "choseModel.h"

@implementation choseModel
+(instancetype)initWithObject:(NSObject *)obj{

    choseModel *model = [[self alloc] init];
    if ([obj isKindOfClass:[NSString class]]) {
        model.cellName = (NSString *)obj;
        model.cellID = @"-1";
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        model.cellName = [(NSDictionary *)obj valueForKey:@"NAME"];
        model.cellID = [(NSDictionary *)obj valueForKey:@"GRID_ID"];
    }
    return model;
}



- (void)setFlag:(BOOL)flag{
    _flag = flag;
}
@end
