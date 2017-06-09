//
//  BNHuaXiaoViewController.m
//  WorkBench
//
//  Created by wanwan on 16/9/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNQuanLiangXiaoQuViewController.h"
#import "BNQuanLiangView.h"
#import "BNGridCell.h"
#import <MJRefresh.h>
#import "BNGridRoleModel.h"
#import <AFNetworking.h>
#import "BNMetaDataTools.h"
#import "BNWangGeViewController.h"
#import "BNOneTimeIncreseProductViewController.h"
#import "BNWaterMark.h"
#import "BNHuaXiaoViewController.h"

#import "BNXiaoQuViewController.h"

@interface BNQuanLiangXiaoQuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
// 装网格模型数据的
@property (strong,nonatomic) NSMutableArray *gridArray;
//记录当前请求的page的值
@property (nonatomic, assign) int page;
// 请求返回的数据
@property (strong,nonatomic)id responseObject;
// 悬浮按钮
@property(strong,nonatomic)UIButton *flowButton;
@end
// 常量

@implementation BNQuanLiangXiaoQuViewController


- (void)viewWillAppear:(BOOL)animated {
    // 返回时刷新
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    // Title
    self.title = [LoginModel shareLoginModel].NAME;

    NSLog(@"--------%@",[LoginModel shareLoginModel].ORG_MANAGER_TYPE);
    // 判断是否添加一次性添加按钮（根据权限）
    if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]) {
        //  添加悬浮按钮

    }
    [self initView];

    
}

-(void)getUrlRequest
{
    //调用注销接口
    NSString* strUrl = [QuanLiangXiaoQuInfo stringByAppendingFormat:@"%@",[LoginModel shareLoginModel].ORG_ID];
    
    NSLog(@"strUrl333==%@", strUrl);
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view.window];
    [BNNetworkTool initWitUrl:strUrl andParameters:nil andStyle:NO].requestData = ^(id requestDate){
        NSLog(@"requestDate333==%@", requestDate);
        
        [self setRequestUrlData:requestDate];
        
        [hud setHidden:YES];
    };
}

-(void)setRequestUrlData:(id)responseObject
{
    _lab00.text = responseObject[@"RESULT"][0][@"REGION_ID_CNT"];
    _lab10.text = responseObject[@"RESULT"][0][@"BUILDING_ID_CNT"];
    _lab20.text = responseObject[@"RESULT"][0][@"ROOT_CNT"];
    
    
    _titleView0.text = [NSString stringWithFormat:@"电信产品数：%@",responseObject[@"RESULT"][0][@"BW_USER_CNT"]];
    _titleView1.text = [NSString stringWithFormat:@"全网产品数：%@",responseObject[@"RESULT"][0][@"ALL_USER_CNT"]];
    
    
    _persent00.text = responseObject[@"RESULT"][0][@"BW_USER_KD_CNT_PER"];
    _persent10.text = responseObject[@"RESULT"][0][@"BW_USER_ITV_CNT_PER"];
    _persent20.text = responseObject[@"RESULT"][0][@"ALL_USER_KD_CNT_PER"];
    _persent30.text = responseObject[@"RESULT"][0][@"ALL_USER_ITV_CNT_PER"];
    
    
    _persent02.text = responseObject[@"RESULT"][0][@"QQ_BW_USER_KD_CNT_PER"];
    _persent12.text = responseObject[@"RESULT"][0][@"QQ_BW_USER_ITV_CNT_PER"];
    _persent22.text = responseObject[@"RESULT"][0][@"QQ_ALL_USER_KD_CNT_PER"];
    _persent32.text = responseObject[@"RESULT"][0][@"QQ_ALL_USER_ITV_CNT_PER"];

}

- (void)initView
{
    UIView* view0 = [[UIView alloc]init];
    view0.frame = CGRectMake(10, 14, (SCREEN_W-40)/3, (SCREEN_W-40)/3);
    view0.backgroundColor = UIColorFromRGB(0xfeb51b);
    
    UIImageView* img0 = [[UIImageView alloc] init];
    img0.image = [UIImage imageNamed:@"new_ico1.png"];
    img0.frame = CGRectMake((SCREEN_W-40)/9, 8, (SCREEN_W-40)/9, (SCREEN_W-40)/9);
    
    _lab00 = [[UILabel alloc]init];
    _lab00.frame = CGRectMake(0, img0.frame.origin.y+(SCREEN_W-40)/9, (SCREEN_W-40)/3, (SCREEN_W-40)/12);
    _lab00.text = @"";
    _lab00.font = [UIFont systemFontOfSize:18.0f];
    _lab00.textColor = [UIColor whiteColor];
    _lab00.textAlignment = NSTextAlignmentCenter;
    
    UILabel* lab01 = [[UILabel alloc]init];
    lab01.frame = CGRectMake(0, _lab00.frame.origin.y+(SCREEN_W-40)/12, (SCREEN_W-40)/3, (SCREEN_W-40)/12);
    lab01.text = @"小区";
    lab01.textColor = [UIColor whiteColor];
    lab01.font = [UIFont systemFontOfSize:14.0f];
    lab01.textAlignment = NSTextAlignmentCenter;
    
    UIView* navline0 = [[UIView alloc]init];
    navline0.frame = CGRectMake(0, view0.frame.origin.y+(SCREEN_W-40)/3+14, SCREEN_W, 1);
    navline0.backgroundColor = UIColorFromRGB(0xfeb51b);
    
    [self.view addSubview:view0];
    [view0 addSubview:img0];
    [view0 addSubview:_lab00];
    [view0 addSubview:lab01];
    
    [self.view addSubview:navline0];
    
    
    ////////////////////////////////////////////////////////////
    
    UIView* view1 = [[UIView alloc]init];
    view1.frame = CGRectMake(20+(SCREEN_W-40)/3, 14, (SCREEN_W-40)/3, (SCREEN_W-40)/3);
    view1.backgroundColor = UIColorFromRGB(0xfeb51b);
    
    UIImageView* img1 = [[UIImageView alloc] init];
    img1.image = [UIImage imageNamed:@"new_ico2.png"];
    img1.frame = CGRectMake((SCREEN_W-40)/9, 8, (SCREEN_W-40)/9, (SCREEN_W-40)/9);
    
    _lab10 = [[UILabel alloc]init];
    _lab10.frame = CGRectMake(0, img1.frame.origin.y+(SCREEN_W-40)/9, (SCREEN_W-40)/3, (SCREEN_W-40)/12);
    _lab10.text = @"";
    _lab10.font = [UIFont systemFontOfSize:18.0f];
    _lab10.textColor = [UIColor whiteColor];
    _lab10.textAlignment = NSTextAlignmentCenter;
    
    UILabel* lab11 = [[UILabel alloc]init];
    lab11.frame = CGRectMake(0, _lab10.frame.origin.y+(SCREEN_W-40)/12, (SCREEN_W-40)/3, (SCREEN_W-40)/12);
    lab11.text = @"楼宇数";
    lab11.textColor = [UIColor whiteColor];
    lab11.font = [UIFont systemFontOfSize:14.0f];
    lab11.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:view1];
    [view1 addSubview:img1];
    [view1 addSubview:_lab10];
    [view1 addSubview:lab11];
    
    ////////////////////////////////////////////////////////////
    
    
    UIView* view2 = [[UIView alloc]init];
    view2.frame = CGRectMake(30+(SCREEN_W-40)*2/3, 14, (SCREEN_W-40)/3, (SCREEN_W-40)/3);
    view2.backgroundColor = UIColorFromRGB(0xfeb51b);
    
    UIImageView* img2 = [[UIImageView alloc] init];
    img2.image = [UIImage imageNamed:@"new_ico3.png"];
    img2.frame = CGRectMake((SCREEN_W-40)/9, 8, (SCREEN_W-40)/9, (SCREEN_W-40)/9);
    
    _lab20 = [[UILabel alloc]init];
    _lab20.frame = CGRectMake(0, img2.frame.origin.y+(SCREEN_W-40)/9, (SCREEN_W-40)/3, (SCREEN_W-40)/12);
    _lab20.text = @"";
    _lab20.font = [UIFont systemFontOfSize:18.0f];
    _lab20.textColor = [UIColor whiteColor];
    _lab20.textAlignment = NSTextAlignmentCenter;
    
    UILabel* lab21 = [[UILabel alloc]init];
    lab21.frame = CGRectMake(0, _lab20.frame.origin.y+(SCREEN_W-40)/12, (SCREEN_W-40)/3, (SCREEN_W-40)/12);
    lab21.text = @"户数";
    lab21.textColor = [UIColor whiteColor];
    lab21.font = [UIFont systemFontOfSize:14.0f];
    lab21.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:view2];
    [view2 addSubview:img2];
    [view2 addSubview:_lab20];
    [view2 addSubview:lab21];
    
    ////////////////////////////////////////////////////////////
    
    
    _titleView0 = [[UILabel alloc] init];
    
    _titleView0.frame = CGRectMake(SCREEN_W/4, navline0.frame.origin.y+10, SCREEN_W/2, 26);
    _titleView0.backgroundColor = UIColorFromRGB(0xfeb51b);
    
    //设置圆角边框
    _titleView0.layer.cornerRadius = 13;
    _titleView0.layer.masksToBounds = YES;
    _titleView0.text = @"电信产品数：";
    _titleView0.textColor = [UIColor whiteColor];
    _titleView0.font = [UIFont systemFontOfSize:14.0f];
    _titleView0.textAlignment = NSTextAlignmentCenter;

//    //设置边框及边框颜色
//    titleView0.layer.borderWidth = 1;
//    titleView0.layer.borderColor =[ [UIColor grayColor] CGColor];
    
    [self.view addSubview:_titleView0];
    
    //圆形0
    UIView *circleView0 = [[UIView alloc] init];
    circleView0.frame = CGRectMake((SCREEN_W)/8, _titleView0.frame.origin.y+34, (SCREEN_W)/4, (SCREEN_W)/4);
    circleView0.backgroundColor = [UIColor whiteColor];
    //设置圆角边框
    circleView0.layer.cornerRadius = (SCREEN_W)/8;
    circleView0.layer.masksToBounds = YES;
    //设置边框及边框颜色
    circleView0.layer.borderWidth = 2;
    circleView0.layer.borderColor = UIColorFromRGB(0xfeb51b).CGColor;
    
    [self.view addSubview:circleView0];
    
    _persent00 = [[UILabel alloc]init];
    _persent00.frame = CGRectMake(0, circleView0.frame.size.height/4, circleView0.frame.size.width, circleView0.frame.size.height/4);
    _persent00.text = @"";
//    persent00.backgroundColor = [UIColor redColor];
    _persent00.font = [UIFont systemFontOfSize:18.0f];
    _persent00.textColor = UIColorFromRGB(0xfeb51b);
    _persent00.textAlignment = NSTextAlignmentCenter;
    [circleView0 addSubview:_persent00];
    
    UILabel* persent01 = [[UILabel alloc]init];
    persent01.frame = CGRectMake(0, _persent00.frame.origin.y+_persent00.frame.size.height, circleView0.frame.size.width, circleView0.frame.size.height/6);
    persent01.text = @"全区平均:";
//    persent01.backgroundColor = [UIColor greenColor];
    persent01.font = [UIFont systemFontOfSize:12.0f];
    persent01.textColor = UIColorFromRGB(0xb6bcc3);
    persent01.textAlignment = NSTextAlignmentCenter;
    [circleView0 addSubview:persent01];
    
    
    
    _persent02 = [[UILabel alloc]init];
    _persent02.frame = CGRectMake(0, persent01.frame.origin.y+persent01.frame.size.height, circleView0.frame.size.width, circleView0.frame.size.height/4);
    _persent02.text = @"";
//    persent02.backgroundColor = [UIColor purpleColor];
    _persent02.font = [UIFont systemFontOfSize:14.0f];
    _persent02.textColor = UIColorFromRGB(0xb6bcc3);
    _persent02.textAlignment = NSTextAlignmentCenter;
    [circleView0 addSubview:_persent02];
    
    UILabel* persent03 = [[UILabel alloc]init];
    persent03.frame = CGRectMake(circleView0.frame.origin.x, circleView0.frame.origin.y+circleView0.frame.size.height+4, circleView0.frame.size.width, circleView0.frame.size.height/4);
    persent03.text = @"宽带渗透率";
//        persent03.backgroundColor = [UIColor purpleColor];
    persent03.font = [UIFont systemFontOfSize:12.0f];
    persent03.textColor = [UIColor blackColor];
    persent03.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:persent03];
    
    
    //圆形0
    UIView *circleView1 = [[UIView alloc] init];
    circleView1.frame = CGRectMake((SCREEN_W)*5/8, _titleView0.frame.origin.y+34, (SCREEN_W)/4, (SCREEN_W)/4);
    circleView1.backgroundColor = [UIColor whiteColor];
    //设置圆角边框
    circleView1.layer.cornerRadius = (SCREEN_W)/8;
    circleView1.layer.masksToBounds = YES;
    //设置边框及边框颜色
    circleView1.layer.borderWidth = 2;
    circleView1.layer.borderColor = UIColorFromRGB(0xfeb51b).CGColor;
    
    [self.view addSubview:circleView1];
    
    _persent10 = [[UILabel alloc]init];
    _persent10.frame = CGRectMake(0, circleView1.frame.size.height/4, circleView1.frame.size.width, circleView1.frame.size.height/4);
    _persent10.text = @"";
    //    persent00.backgroundColor = [UIColor redColor];
    _persent10.font = [UIFont systemFontOfSize:18.0f];
    _persent10.textColor = UIColorFromRGB(0xfeb51b);
    _persent10.textAlignment = NSTextAlignmentCenter;
    [circleView1 addSubview:_persent10];
    
    UILabel* persent11 = [[UILabel alloc]init];
    persent11.frame = CGRectMake(0, _persent10.frame.origin.y+_persent10.frame.size.height, circleView1.frame.size.width, circleView1.frame.size.height/6);
    persent11.text = @"全区平均:";
    //    persent01.backgroundColor = [UIColor greenColor];
    persent11.font = [UIFont systemFontOfSize:12.0f];
    persent11.textColor = UIColorFromRGB(0xb6bcc3);
    persent11.textAlignment = NSTextAlignmentCenter;
    [circleView1 addSubview:persent11];
    
    
    
    _persent12 = [[UILabel alloc]init];
    _persent12.frame = CGRectMake(0, persent11.frame.origin.y+persent11.frame.size.height, circleView1.frame.size.width, circleView1.frame.size.height/4);
    _persent12.text = @"";
    //    persent02.backgroundColor = [UIColor purpleColor];
    _persent12.font = [UIFont systemFontOfSize:14.0f];
    _persent12.textColor = UIColorFromRGB(0xb6bcc3);
    _persent12.textAlignment = NSTextAlignmentCenter;
    [circleView1 addSubview:_persent12];
    
    UILabel* persent13 = [[UILabel alloc]init];
    persent13.frame = CGRectMake(circleView1.frame.origin.x, circleView1.frame.origin.y+circleView1.frame.size.height+4, circleView1.frame.size.width, circleView1.frame.size.height/4);
    persent13.text = @"ITV渗透率";
    //        persent03.backgroundColor = [UIColor purpleColor];
    persent13.font = [UIFont systemFontOfSize:12.0f];
    persent13.textColor = [UIColor blackColor];
    persent13.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:persent13];
    
    
    UIView* navline1 = [[UIView alloc]init];
    navline1.frame = CGRectMake(0, persent13.frame.origin.y+persent13.frame.size.height+14, SCREEN_W, 1);
    navline1.backgroundColor = UIColorFromRGB(0xfeb51b);
    [self.view addSubview:navline1];
    
    
    ///////////////////////////////////////////////////////////
    _titleView1 = [[UILabel alloc] init];
    
    _titleView1.frame = CGRectMake(SCREEN_W/4, navline1.frame.origin.y+10, SCREEN_W/2, 26);
    _titleView1.backgroundColor = UIColorFromRGB(0x41a6e8);
    
    //设置圆角边框
    _titleView1.layer.cornerRadius = 13;
    _titleView1.layer.masksToBounds = YES;
    _titleView1.text = @"全网产品数：";
    _titleView1.textColor = [UIColor whiteColor];
    _titleView1.font = [UIFont systemFontOfSize:14.0f];
    _titleView1.textAlignment = NSTextAlignmentCenter;
    
    //    //设置边框及边框颜色
    //    titleView0.layer.borderWidth = 1;
    //    titleView0.layer.borderColor =[ [UIColor grayColor] CGColor];
    
    [self.view addSubview:_titleView1];
    
    //圆形0
    UIView *circleView2 = [[UIView alloc] init];
    circleView2.frame = CGRectMake((SCREEN_W)/8, _titleView1.frame.origin.y+34, (SCREEN_W)/4, (SCREEN_W)/4);
    circleView2.backgroundColor = [UIColor whiteColor];
    //设置圆角边框
    circleView2.layer.cornerRadius = (SCREEN_W)/8;
    circleView2.layer.masksToBounds = YES;
    //设置边框及边框颜色
    circleView2.layer.borderWidth = 2;
    circleView2.layer.borderColor = UIColorFromRGB(0x41a6e8).CGColor;
    
    [self.view addSubview:circleView2];
    
    _persent20 = [[UILabel alloc]init];
    _persent20.frame = CGRectMake(0, circleView2.frame.size.height/4, circleView2.frame.size.width, circleView2.frame.size.height/4);
    _persent20.text = @"";
    //    persent00.backgroundColor = [UIColor redColor];
    _persent20.font = [UIFont systemFontOfSize:18.0f];
    _persent20.textColor = UIColorFromRGB(0x41a6e8);
    _persent20.textAlignment = NSTextAlignmentCenter;
    [circleView2 addSubview:_persent20];
    
    UILabel* persent21 = [[UILabel alloc]init];
    persent21.frame = CGRectMake(0, _persent20.frame.origin.y+_persent20.frame.size.height, circleView2.frame.size.width, circleView2.frame.size.height/6);
    persent21.text = @"全区平均:";
    //    persent01.backgroundColor = [UIColor greenColor];
    persent21.font = [UIFont systemFontOfSize:12.0f];
    persent21.textColor = UIColorFromRGB(0xb6bcc3);
    persent21.textAlignment = NSTextAlignmentCenter;
    [circleView2 addSubview:persent21];
    
    
    
    _persent22 = [[UILabel alloc]init];
    _persent22.frame = CGRectMake(0, persent21.frame.origin.y+persent21.frame.size.height, circleView2.frame.size.width, circleView2.frame.size.height/4);
    _persent22.text = @"";
    //    persent02.backgroundColor = [UIColor purpleColor];
    _persent22.font = [UIFont systemFontOfSize:14.0f];
    _persent22.textColor = UIColorFromRGB(0xb6bcc3);
    _persent22.textAlignment = NSTextAlignmentCenter;
    [circleView2 addSubview:_persent22];
    
    UILabel* persent23 = [[UILabel alloc]init];
    persent23.frame = CGRectMake(circleView2.frame.origin.x, circleView2.frame.origin.y+circleView2.frame.size.height+4, circleView2.frame.size.width, circleView2.frame.size.height/4);
    persent23.text = @"宽带入户率";
    //        persent03.backgroundColor = [UIColor purpleColor];
    persent23.font = [UIFont systemFontOfSize:12.0f];
    persent23.textColor = [UIColor blackColor];
    persent23.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:persent23];
    
    
    //圆形3
    UIView *circleView3 = [[UIView alloc] init];
    circleView3.frame = CGRectMake((SCREEN_W)*5/8, _titleView1.frame.origin.y+34, (SCREEN_W)/4, (SCREEN_W)/4);
    circleView3.backgroundColor = [UIColor whiteColor];
    //设置圆角边框
    circleView3.layer.cornerRadius = (SCREEN_W)/8;
    circleView3.layer.masksToBounds = YES;
    //设置边框及边框颜色
    circleView3.layer.borderWidth = 2;
    circleView3.layer.borderColor = UIColorFromRGB(0x41a6e8).CGColor;
    
    [self.view addSubview:circleView3];
    
    _persent30 = [[UILabel alloc]init];
    _persent30.frame = CGRectMake(0, circleView3.frame.size.height/4, circleView3.frame.size.width, circleView3.frame.size.height/4);
    _persent30.text = @"";
    //    persent00.backgroundColor = [UIColor redColor];
    _persent30.font = [UIFont systemFontOfSize:18.0f];
    _persent30.textColor = UIColorFromRGB(0x41a6e8);
    _persent30.textAlignment = NSTextAlignmentCenter;
    [circleView3 addSubview:_persent30];
    
    UILabel* persent31 = [[UILabel alloc]init];
    persent31.frame = CGRectMake(0, _persent30.frame.origin.y+_persent30.frame.size.height, circleView3.frame.size.width, circleView3.frame.size.height/6);
    persent31.text = @"全区平均:";
    //    persent01.backgroundColor = [UIColor greenColor];
    persent31.font = [UIFont systemFontOfSize:12.0f];
    persent31.textColor = UIColorFromRGB(0xb6bcc3);
    persent31.textAlignment = NSTextAlignmentCenter;
    [circleView3 addSubview:persent31];
    
    
    
    _persent32 = [[UILabel alloc]init];
    _persent32.frame = CGRectMake(0, persent31.frame.origin.y+persent31.frame.size.height, circleView3.frame.size.width, circleView3.frame.size.height/4);
    _persent32.text = @"";
    //    persent02.backgroundColor = [UIColor purpleColor];
    _persent32.font = [UIFont systemFontOfSize:14.0f];
    _persent32.textColor = UIColorFromRGB(0xb6bcc3);
    _persent32.textAlignment = NSTextAlignmentCenter;
    [circleView3 addSubview:_persent32];
    
    UILabel* persent33 = [[UILabel alloc]init];
    persent33.frame = CGRectMake(circleView3.frame.origin.x, circleView3.frame.origin.y+circleView3.frame.size.height+4, circleView3.frame.size.width, circleView3.frame.size.height/4);
    persent33.text = @"电视入户率";
    //        persent03.backgroundColor = [UIColor purpleColor];
    persent33.font = [UIFont systemFontOfSize:12.0f];
    persent33.textColor = [UIColor blackColor];
    persent33.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:persent33];
    
    
    UIView* navline2 = [[UIView alloc]init];
    navline2.frame = CGRectMake(0, persent33.frame.origin.y+persent33.frame.size.height+14, SCREEN_W, 1);
    navline2.backgroundColor = UIColorFromRGB(0xfeb51b);
    [self.view addSubview:navline2];
    
    
    UIButton *buttonleft = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonleft.frame = CGRectMake(SCREEN_W/8,navline2.frame.origin.y+10,SCREEN_W/4,34);
    buttonleft.backgroundColor = [UIColor whiteColor];
    buttonleft.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [buttonleft setTitle:@"查看网格" forState:UIControlStateNormal];
    [buttonleft setTitleColor:UIColorFromRGB(0xfeb51b) forState:UIControlStateNormal];
    //关键语句
    buttonleft.layer.cornerRadius = 2.0;//2.0是圆角的弧度，根据需求自己更改
    buttonleft.layer.borderColor = UIColorFromRGB(0xfeb51b).CGColor;//设置边框颜色
    [buttonleft addTarget:self action:@selector(buttonleft)
     forControlEvents:UIControlEventTouchUpInside];
    buttonleft.layer.borderWidth = 2.0f;//设置边框颜色
    [self.view addSubview:buttonleft];
    
    
    UIButton *buttonright = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonright.frame = CGRectMake(SCREEN_W*5/8,navline2.frame.origin.y+10,SCREEN_W/4,34);
    buttonright.backgroundColor = [UIColor whiteColor];
    buttonright.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [buttonright setTitle:@"查看小区" forState:UIControlStateNormal];
    [buttonright setTitleColor:UIColorFromRGB(0xfeb51b) forState:UIControlStateNormal];
    //关键语句
    buttonright.layer.cornerRadius = 2.0;//2.0是圆角的弧度，根据需求自己更改
    buttonright.layer.borderColor = UIColorFromRGB(0xfeb51b).CGColor;//设置边框颜色
    [buttonright addTarget:self action:@selector(buttonright)
         forControlEvents:UIControlEventTouchUpInside];
    buttonright.layer.borderWidth = 2.0f;//设置边框颜色
    [self.view addSubview:buttonright];
    
    
    
    // 请求数据
    [self getUrlRequest];

}

- (void)buttonleft
{
    NSLog(@"left");
    BNHuaXiaoViewController *huaXiaoVC = [BNHuaXiaoViewController new];
    [self.navigationController pushViewController:huaXiaoVC animated:YES];
}

- (void)buttonright
{
    NSLog(@"right");
    BNXiaoQuViewController *xiaoQuVC = [BNXiaoQuViewController new];
    xiaoQuVC.org_id = [LoginModel shareLoginModel].ORG_ID;
    [self.navigationController pushViewController:xiaoQuVC animated:YES];
}



#pragma mark -- 界面部分


/**
 *  停止刷新
 */
-(void)endRefresh{
//    [self.tableView.header endRefreshing];
//    [self.tableView.footer endRefreshing];
}



#pragma mark -- UITableViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
