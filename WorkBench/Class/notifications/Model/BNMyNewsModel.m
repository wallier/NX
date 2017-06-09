//
//  BNMyNewsModel.m
//  WorkBench
//
//  Created by wanwan on 16/10/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNMyNewsModel.h"

@implementation BNMyNewsModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.image forKey:@"news_image"];
    [aCoder encodeObject:self.title forKey:@"news_title"];
    [aCoder encodeObject:self.deadlineNums forKey:@"news_deadlineNums"];
    [aCoder encodeObject:self.times forKey:@"news_times"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isShowRedpoint] forKey:@"news_isShowRedpoint"];

}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.image = [aDecoder decodeObjectForKey:@"news_image"];
        self.title = [aDecoder decodeObjectForKey:@"news_title"];
        self.deadlineNums = [aDecoder decodeObjectForKey:@"news_deadlineNums"];
        self.times = [aDecoder decodeObjectForKey:@"news_times"];
        NSNumber *isShowRedpoint = [aDecoder decodeObjectForKey:@"news_isShowRedpoint"];
        self.isShowRedpoint = isShowRedpoint.boolValue;
    }

    return self;

}



@end
