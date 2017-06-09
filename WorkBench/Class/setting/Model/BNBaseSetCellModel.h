//
//  BNBaseSetCell.h
//  WorkBench
//
//  Created by mac on 16/2/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^FUNCTION)(void);

@interface BNBaseSetCellModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *ImgName;
@property (nonatomic, assign) int type;
@property (nonatomic, strong) FUNCTION function;

- (instancetype)initwithTitle:(NSString *)title Image:(NSString *)Img andTypt:(int)type;

@end
