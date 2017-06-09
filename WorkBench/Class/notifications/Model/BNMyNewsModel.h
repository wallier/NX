//
//  BNMyNewsModel.h
//  WorkBench
//
//  Created by wanwan on 16/10/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNMyNewsModel : NSObject<NSCoding>
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *deadlineNums;
@property (nonatomic, strong) NSString *times;
@property (nonatomic, assign) BOOL isShowRedpoint;
@end
