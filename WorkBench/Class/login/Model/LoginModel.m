//
//  LoginModel.m
//  text_pch
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "LoginModel.h"
#import <objc/runtime.h>
@interface LoginModel()

@property (nonatomic,strong) NSMutableDictionary *dic;

@end
@implementation LoginModel

static LoginModel *model = nil;

+ (instancetype)shareLoginModel{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[super allocWithZone:NULL] init];
    });
    return model;
}

+ (id) allocWithZone:(struct _NSZone *)zone
{
    return [LoginModel shareLoginModel];
}

- (id) copyWithZone:(struct _NSZone *)zone
{
    return [LoginModel shareLoginModel];
}
- (NSString *)judjeParams{
    NSString *model = [[NSUserDefaults standardUserDefaults] valueForKey:@"model"];
    if ([model isEqualToString:@"fz"]) {
        return   @"DP_WORKORDER_TYPE_DEVCHANCE";
        
    }else if ([model isEqualToString:@"sx"]){
        
        return  @"DP_WORKORDER_TYPE_SAN";
        
    }else{
        return  @"DP_WORKORDER_TYPE_SAN_ITEM";
    }
    
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self.dic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [self setValuesForKeysWithDictionary:dictionary];
 
    return self;
}
@end
