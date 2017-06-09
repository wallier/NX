//
//  KHCellModel.h
//  WorkBench
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KHCellModel : NSObject
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) NSString *text_head;
@property (nonatomic,strong) NSString *text_top;
@property (nonatomic,strong) NSString *text_bottom;
@property (nonatomic,strong) NSString *isused;
@property (nonatomic,strong) NSString *unit;

@property (nonatomic,strong) NSString *text_right;
+(instancetype)initKHCellModel:(NSDictionary *)dic;
@end
