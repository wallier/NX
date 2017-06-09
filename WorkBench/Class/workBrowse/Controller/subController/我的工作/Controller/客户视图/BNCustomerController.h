//
//  BNCustomerController.h
//  WorkBench
//
//  Created by mac on 16/2/1.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNLDModel.h"
#import <MessageUI/MessageUI.h>
#import <WebKit/WebKit.h>
@interface BNCustomerController : UIViewController<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong) NSMutableDictionary *params;
@property(nonatomic,strong) NSArray *arr_data;
@property(nonatomic,strong) NSString *stt_rh;
@property(nonatomic,strong) UILabel *lab_tele,*lab_khmc,*lab_zdah,*lab_swrs,*lab_rwsj,*lab_tc;
@property(nonatomic,assign) BOOL isFlag;
@property(nonatomic,strong) UIImageView *img;
@property(nonatomic,strong) UIWebView *repView;
@property(nonatomic,strong) UIButton *btn_tele,*btn_msg;
@property(nonatomic,strong) NSString *str_msg;
@property(nonatomic,strong) NSDictionary *dic_data_lastview;
@property (nonatomic, strong) BNLDModel *model;

@end
