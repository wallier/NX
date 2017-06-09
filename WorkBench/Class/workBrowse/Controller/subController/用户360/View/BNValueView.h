//
//  BNValueView.h
//  WorkBench
//
//  Created by mac on 16/1/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface BNValueView : UIView
@property (strong, nonatomic)  WKWebView *ValueWebView;   ///<价值目标-webviwe
@property (strong, nonatomic)  UITableView *ValueTableView; ///<价值目标- tableview

@end
