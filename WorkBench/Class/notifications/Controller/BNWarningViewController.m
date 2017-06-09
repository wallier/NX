//
//  BNWarningViewController.m
//  WorkBench
//
//  Created by wanwan on 16/10/19.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNWarningViewController.h"
#import "BNWarningTitle.h"
#import <AFNetworking.h>
#import "BNNewsModel.h"
#import "BNWaterMark.h"
#import "HMDatePickView.h"

@interface BNWarningViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIScrollView *scrollView;
// 时间
@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSArray *packageArray;
// 悬浮表头
@property (nonatomic, strong) UIView *titleView;


@end

static int titleViewY;

@implementation BNWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"到期预警";
    UIBarButtonItem *choseDate = [[UIBarButtonItem alloc]initWithTitle:@"日期" style:UIBarButtonItemStylePlain target:self action:@selector(choseDate)];
    self.navigationItem.rightBarButtonItem = choseDate;
      // 水印背景
    UIImage *img = [BNWaterMark getwatermarkImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];

    // 获取当前时间hh:mm:ss SS
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    self.dateStr = dateString;
    NSLog(@"dateString:%@",dateString);
    [self request];
}

// 选择日期
- (void)choseDate {
        /** 自定义日期选择器 */
    HMDatePickView *datePickVC = [[HMDatePickView alloc] initWithFrame:self.view.frame];
    //距离当前日期的年份差（设置最大可选日期）
    datePickVC.maxYear = -1;
    //设置最小可选日期(年分差)
    //    _datePickVC.minYear = 10;
    datePickVC.date = [NSDate date];
    //设置字体颜色
    datePickVC.fontColor = [UIColor whiteColor];
    //日期回调
    WS
    datePickVC.completeBlock = ^(NSString *selectDate) {
        
               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:selectDate];
        
        NSDateFormatter *matter = [[NSDateFormatter alloc] init];
        [matter setDateFormat:@"YYYYMMdd"];
        NSString *str = [matter stringFromDate:date];
        NSLog(@"---selectDate---%@",selectDate);
        weakSelf.dateStr = str;
        NSLog(@"---selectDate---%@",self.dateStr);

        // 移除视图
        [weakSelf.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
         [weakSelf request];
        
    };
    //配置属性
    [datePickVC configuration];
    
    [self.view addSubview:datePickVC];

}

- (void)addScrollViewWithNums:(NSInteger)nums {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    // 30*nums+60+60
    _scrollView.contentSize = CGSizeMake(590,30*nums+60+60);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _titleView = [[[NSBundle mainBundle] loadNibNamed:@"BNWarningTitle" owner:self options:nil]firstObject];
    _titleView.frame = CGRectMake(0, 0, 590, 60);
    [_scrollView addSubview:_titleView];
    [self.view addSubview:_scrollView];
    titleViewY=(int)_titleView.frame.origin.y;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%d",(int)_titleView.frame.origin.y);
    _titleView.frame = CGRectMake(_titleView.frame.origin.x, titleViewY+self.scrollView.contentOffset.y , _titleView.frame.size.width, _titleView.frame.size.height);
}


- (void)request {
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.margin = 10.0f;
    self.hud.removeFromSuperViewOnHide = YES;
    self.hud.labelText = @"数据加载中...";
    
    NSLog(@"-----URL-----%@",[self getURL]);
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:[self getURL] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self.hud setHidden: YES];
        _packageArray = [BNNewsModel getPackageArray:responseObject[@"RESULT"]];
        NSLog(@"--数组长度--%lu",(unsigned long)_packageArray.count);
        [self addScrollViewWithNums:_packageArray.count];
        [self showPackageMeal:_packageArray.count];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hud setHidden: YES];
        NSLog(@"失败-%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        //停止刷新控件动画
     //   [self endRefresh];
        
    }];


}

- (NSString *)getURL {
   
    return [[[[[WARNINGURL stringByAppendingString:self.dateStr]stringByAppendingString:@"/"]stringByAppendingString:[LoginModel shareLoginModel].ORG_MANAGER_TYPE]stringByAppendingString:@"/"]stringByAppendingString:[LoginModel shareLoginModel].ORG_ID];

}

- (void)showPackageMeal:(NSInteger)nums {
   // static NSInteger packageView_y = 30;
    for (int i = 0; i < nums; i++) {
        BNWarningTitle *titleView = [[[NSBundle mainBundle] loadNibNamed:@"BNWarningTitle" owner:self options:nil]firstObject];
        
        titleView.frame = CGRectMake(0, 30*i+60, 590, 30);
        titleView.backgroundColor = [UIColor clearColor];
        BNNewsModel *newsModel = _packageArray[i];
        if ([newsModel.OPERATOR_TYPE isEqualToString:@"1"]) {
            titleView.operator_type.text = @"电信";
        } else if ([newsModel.OPERATOR_TYPE isEqualToString:@"2"]){
            titleView.operator_type.text = @"移动";
        }else if ([newsModel.OPERATOR_TYPE isEqualToString:@"3"]){
            titleView.operator_type.text = @"联通";
        }else if ([newsModel.OPERATOR_TYPE isEqualToString:@"4"]){
            titleView.operator_type.text = @"广电";
        } else {
            titleView.operator_type.text = @"未知";
        }
       
        titleView.package_meal.text = newsModel.PACKAGE_MEAL;
        titleView.package_meal.adjustsFontSizeToFitWidth = YES;
        titleView.user_address.text = [[[newsModel.REDION_NAME stringByAppendingString:newsModel.BUILDING_NO]stringByAppendingString:newsModel.UNIT_NO]stringByAppendingString:newsModel.ROOT_NO];
        titleView.user_address.adjustsFontSizeToFitWidth = YES;
        titleView.deadline.text = newsModel.EXPIRE;
        titleView.cust_name.text = newsModel.CUST_NAME ;
        titleView.cust_name.adjustsFontSizeToFitWidth = YES;
        titleView.cust_phone.text = newsModel.REL_PHONE;
        
        
        [_scrollView addSubview:titleView];
        // 表头显示到最前面
        [self.scrollView bringSubviewToFront:_titleView];
    }



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
