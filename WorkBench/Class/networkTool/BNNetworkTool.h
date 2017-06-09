//
//  BNNetworkTool.h
//  WorkBench
//
//  Created by mac on 16/1/21.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^RequestData)(id);

@interface BNNetworkTool : NSObject

@property (nonatomic,copy) RequestData requestData;

//参数为字典的请求
+ (instancetype)initWitUrl:(NSString *)url andParameters:(NSDictionary *)patameters andStyle:(BOOL)flag;

//参数为json的请求
+ (instancetype)initWitUrl:(NSString *)url andJSonParameters:(NSDictionary *)patameters andParmeterName:(NSString *)parmeterName;

@end
