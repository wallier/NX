//
//  PersonView.h
//  WorkBench
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 com.bonc. All rights reserved.
//
#import "PersonInFoModel.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface PersonView : UIView
@property(nonatomic,strong) NSDictionary *dicPerson;
@property(nonatomic,strong) PersonInFoModel *person;
@property(nonatomic,strong) WKWebView *webView;
@end
