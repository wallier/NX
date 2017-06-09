//
//  BNNetworkTool.m
//  WorkBench
//
//  Created by mac on 16/1/21.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNNetworkTool.h"
#import <AFNetworking.h>
#import <UIView+Toast.h>

@implementation BNNetworkTool

+ (instancetype)initWitUrl:(NSString *)url andParameters:(NSDictionary *)patameters
                  andStyle:(BOOL)flag{
    
//    if (![self checkWorkState]){
//        return nil;
//    }
    __block NSString *strurl = url;
    
    BNNetworkTool *request = [[BNNetworkTool alloc] init];
    
    NSURLSessionConfiguration *confing = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil
                                                             sessionConfiguration:confing];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/json", @"text/javascript",
                                                         @"text/html",@"text/plain", nil];
    
    if (!flag) {
        [manager GET:strurl parameters:patameters success:^(NSURLSessionDataTask * _Nonnull task,
                                                            id  _Nonnull responseObject) {
            if (request.requestData) {
                request.requestData(responseObject);
                strurl = nil;
                task = nil;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (request.requestData) {
                [[UIApplication sharedApplication].keyWindow makeToast:@"请求数据失败"
                                                              duration:0.5 position:CSToastPositionCenter];
            }
            request.requestData(nil);
            NSLog(@"Get网络请求失败error：%@",error);
            
        }];
        
    } else {
        [manager POST:strurl parameters:patameters success:^(NSURLSessionDataTask * _Nonnull task,
                                                             id  _Nonnull responseObject) {
            if (request.requestData) {
                request.requestData(responseObject);
                strurl = nil;
                task = nil;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (request.requestData) {
                [[UIApplication sharedApplication].keyWindow makeToast:@"请求数据失败"
                                                              duration:0.5 position:CSToastPositionCenter];
            }
            request.requestData(nil);
            NSLog(@"网络post请求失败error：%@",error);
            
        }];
    }
    return request;
}

+ (instancetype)initWitUrl:(NSString *)url andJSonParameters:(NSDictionary *)patameters
           andParmeterName:(NSString *)parmeterName{
    
    
    
    __block NSString *strurl = url;
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:patameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *paramStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *param = @{parmeterName:paramStr};
    
    
    BNNetworkTool *request = [[BNNetworkTool alloc] init];
    NSURLSessionConfiguration *confing = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil
                                                             sessionConfiguration:confing];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/json", @"text/javascript",
                                                         @"text/html",@"text/plain", nil];
    
    [manager POST:strurl parameters:param success:^(NSURLSessionDataTask * _Nonnull task,
                                                    id  _Nonnull responseObject) {
        if (request.requestData) {
            request.requestData(responseObject);
            task = nil;
            strurl = nil;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (request.requestData) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"请求数据失败"
                                                          duration:0.5 position:CSToastPositionCenter];
        }
        request.requestData(nil);
        
    }];
    
    return  request;
}


+ (BOOL)checkWorkState {
    BOOL State = NetWorkState;
    if (!State) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"您的网络已经断开"
                                                      duration:0.5 position:CSToastPositionCenter];
    }
    return State;
}

- (void)dealloc{
    NSLog(@"---tool--dealloc");
}

@end
