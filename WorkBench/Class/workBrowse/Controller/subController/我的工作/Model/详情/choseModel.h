//
//  choseModel.h
//  WorkBench
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface choseModel : NSObject
@property (nonatomic,strong)NSString *cellName;
@property (nonatomic,strong)NSString *cellID;
@property (nonatomic,assign)BOOL flag;
@property (nonatomic,strong) UIButton *btnSelect;
+(instancetype)initWithObject:(NSObject *)obj;
@end
