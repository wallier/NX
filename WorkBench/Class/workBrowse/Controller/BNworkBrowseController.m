//
//  BNworkBrowseController.m
//  WorkBench
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "CATransition+transition.h"
#import "BNworkBrowseController.h"
#import "BNCollectionViewCell.h"
#import "BNBsaeViewController.h"
//#import "BNUserVisitController.h"// 旧用户回访
// 新用户回访
#import "BNQuanQuViewController.h"// 全区
#import "BNDiShiViewController.h"// 地市
#import "BNQuXianViewController.h" // 区县
#import "BNHuaXiaoViewController.h" // 划小
#import "BNWangGeViewController.h" // 网格
#import "TakePhotoViewController.h"// 随手拍
#import "BNQuanLiangXiaoQuViewController.h"//全量小区
#import "BNMyWorkController.h"
#import <UIViewController+MMDrawerController.h>
#import "BNWarningController.h"
#import "BNUser360Controller.h"
#import "TakePhotoViewController.h"
#import "BNMenuModel.h"
#import <AFNetworking.h>
#import "BNCheckModel.h"
#import "LoginViewController.h"
#define Check_Token @"http://61.133.213.199/mpi/m/sys/ticketValid" //获取票据接口
#import "BNMyNewsModel.h"
#import "BNWaterMark.h"

@interface BNworkBrowseController()

@property (nonatomic, strong) NSArray *arrTitle;
@property (nonatomic, strong) NSArray *arrImage;
@property (nonatomic, strong) NSArray *arrClass;
@property (nonatomic, strong) NSArray *arrMenuModel;
@property (nonatomic, strong) MBProgressHUD *huds;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
// 存数据
//@property (nonatomic, strong) NSUserDefaults *userdefault;
@end
// 记录天数
static int redPointNums;
@implementation BNworkBrowseController
//
- (void)viewWillAppear:(BOOL)animated {
    // 水印背景
    UIImage *img = [BNWaterMark getwatermarkImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    [self viewDidLoad];

}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 记录登录时间
    // 获取当前时间hh:mm:ss SS
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"first1Start"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first1Start"];
        NSLog(@"第一次启动");
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYYMMdd"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
   //     NSString *dateString = @"20161101";
        // 存储登录时间
        [USERDEFAULT setObject:dateString forKey:@"lastLoginTime"];
        // 显示消息个数
        //redPointNums = 1;
        // 存储消息个数
        [USERDEFAULT setObject:[NSString stringWithFormat:@"%d", redPointNums] forKey:@"redPointNums"];
    }else{
        NSLog(@"不是第一次启动");
        int days = [self intervalSinceNow:[USERDEFAULT valueForKey:@"lastLoginTime"]];
        NSLog(@"天数===%ld",(long)days);
        // 计算显示消息个数（未打开app天数加上未点击的条数）
        // 读出
        NSData *readData = [USERDEFAULT objectForKey:@"allNews"];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
        int pointNum = 0;
        for (BNMyNewsModel *news in array) {
            BOOL isShowRedPoint = news.isShowRedpoint;
            if (isShowRedPoint) {
                pointNum +=1;
            }
        }
        redPointNums = days + pointNum;
        // 存储消息个数（小红点数+未登录天数）
        [USERDEFAULT setObject:[NSString stringWithFormat:@"%d", redPointNums] forKey:@"redPointNums"];
        
}
    // 数字小红点
    NSArray *tabBarItems = self.navigationController.tabBarController.tabBar.items;
    UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:1];
    if (redPointNums != 0) {
         personCenterTabBarItem.badgeValue =[NSString stringWithFormat:@"%d", redPointNums];//显示消息条数
    }
   
    // 先移除所有的通知
   // [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"----通知个数---%lu",(unsigned long)localNotifications.count);
    if (localNotifications) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    // 创建本地通知
    UILocalNotification *localNote  = [[UILocalNotification alloc] init];
    // 获取登录时间 + 第二天9：00发送
    NSDate *date = [NSDate date];
    NSDate *fireDate = [NSDate dateWithTimeInterval:60*60*24 sinceDate:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd 09:00:00"];
    NSString *dateString = [dateFormatter stringFromDate:fireDate];
    NSDate *precisionFireDate = [dateFormatter dateFromString:dateString];
    localNote.fireDate = precisionFireDate;
    
    NSLog(@"---通知发送日期---%@",[dateFormatter stringFromDate:precisionFireDate]);
    // 间隔一天发一次NSCalendarUnitDay
    localNote.repeatInterval = NSCalendarUnitDay;
    // 通知内容
    localNote.alertBody = @"有用户即将过期提醒，请点击查看";
    //localNote.applicationIconBadgeNumber =[[[UIApplication sharedApplication] scheduledLocalNotifications] count]+1;;
    NSLog(@"--未读消息的个数--%d",redPointNums);
    [UIApplication sharedApplication].applicationIconBadgeNumber = redPointNums;
    // 调度通知
    [[UIApplication sharedApplication]scheduleLocalNotification:localNote];
    
//    [self.view setBackgroundColor:Colros(215, 233, 244)];
    [self.imageView setImage:[UIImage imageNamed:@"login_bg"]];
//  // 界面背景图片
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]]];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ticket"] length]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(load) name:@"loadController" object:nil];
        
        _huds = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _huds.margin = 10;
        _huds.labelText = @"正在验证...";
        _huds.removeFromSuperViewOnHide = YES;
        [self getCheckToken];
        
    } else {
        [self setCollectionView];
    }
    
      
}

////计算上次登录后的新日期
//- (NSDate *)computeDateWithDays:(NSInteger)days
//{
//    
//    NSDate *currentDate = [NSDate date];//获取当前时间，日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *dateString = [dateFormatter stringFromDate:currentDate];
//    NSString *newDateString = [dateString stringByAppendingString:@" 09:00:00"];
//    NSLog(@"-----新的时间格式------%@",newDateString);
//    
//    NSDateFormatter *newDateFormatter = [NSDateFormatter new];
//    [newDateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
//    // 根据上次登录的时间叠加新的日期60 * 60 * 24
//    NSDate *myDate = [newDateFormatter dateFromString:newDateString];
//    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * days];
//    NSLog(@"---发送通知时间---%@",[newDateFormatter stringFromDate:newDate]);
//    return newDate;
//   
//}


- (void)load{
    [self setCollectionView];
}

//令牌验证
- (void)getCheckToken{

    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter = [NSMutableDictionary dictionary];
    
    NSString *str_ticket = [[NSUserDefaults standardUserDefaults] valueForKey:@"ticket"];
    [parameter setValue:str_ticket forKey:@"ticket"];
    // [parameter setValue:@"4ca416e8-1cca-4c53-aa7f-df8f618c0c22" forKey:@"ticket"];
    [parameter setValue:@"AUTHOR_0003" forKey:@"service_code"];
    [parameter setValue:@"1.0.0" forKey:@"version"];
    [parameter setValue:@"WDGZ_IOS" forKey:@"key"];
    
    AFHTTPRequestOperationManager *manager  = [[AFHTTPRequestOperationManager alloc] init];
    [manager POST:Check_Token parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSArray *userData = [data valueForKey:@"user_info"];
        BNCheckModel *checkmodel  = [BNCheckModel initWitchDicitionary:userData[0]];
        
        if(([[responseObject valueForKey:@"code"] isEqualToString:@"0000"])&&([[data valueForKey:@"valid_result"] isEqualToString:@"AT00"])){//调用成功、验证成功
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ticket"];
            LoginViewController *vc = [[LoginViewController alloc] init];
            [vc loginFromOther:checkmodel.acc_nbr andHud:nil];
            
        } else {
            
            [self.view makeToast:[responseObject valueForKey:@"data"] duration:0.5 position:@"center"];
            sleep(2000);
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tydic://com.chinatelecom.ningxia.cbzs"]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tydic://com.chinatelecom.ningxia.cbzs"]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (int)intervalSinceNow: (NSString *)lastLoginDate {
    // 上次登录时间
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"YYYYMMdd"];
    NSDate *lastDate=[date dateFromString:lastLoginDate];
    NSTimeInterval lastLogin = [lastDate timeIntervalSince1970]*1;
    // 现在的时间
    NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[nowDate timeIntervalSince1970]*1;
    NSString *timeString=@"";
    // 差
    NSTimeInterval cha=now-lastLogin;
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        NSLog(@"---%@",timeString);
        timeString = [timeString substringToIndex:timeString.length-7];
        NSLog(@"---%@",timeString);
        return [timeString intValue];
    }else {
        return 0;
    }
    
}



- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    }
    return _imageView;
}

- (NSArray *)arrTitle{
    return @[@"全量小区视图",@"我的工作",@"预警",@"随手拍",@"用户360"];
}

- (NSArray *)arrImage{
    
    return @[@"icon_shuju_chi",@"icon_user_back",@"yujing",
             @"suishoupai",@"icon_user360"];
}

- (NSArray *)arrClass{
    return @[@"GuestVisit",@"myWork",@"yujing",[TakePhotoViewController class],@"user360"];
}

- (UICollectionViewFlowLayout *)flowLayout{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _flowLayout.sectionInset = UIEdgeInsetsMake(0,1,5,8);//设置每个cell的上左下右距离
    _flowLayout.minimumLineSpacing = 10;
    return _flowLayout;
}

#pragma mark - 设置collectionView

- (void)setCollectionView{
    [self.imageView removeFromSuperview];
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-10, 340)];
    backView.userInteractionEnabled = YES;
    backView.image = [UIImage imageNamed:@"m"];
    [self.view addSubview:backView];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, backView.frame.size.width,backView.frame.size.height) collectionViewLayout:self.flowLayout];
      self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[BNCollectionViewCell class]
            forCellWithReuseIdentifier:@"BNCollectionCells"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [backView  addSubview:self.collectionView];

}

#pragma mark - collectionViewdelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return self.arrImage.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cell";
   
    [collectionView registerNib:[UINib nibWithNibName:@"BNCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId];
    
    BNCollectionViewCell *cell = [[BNCollectionViewCell alloc] init];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.img.image = [UIImage imageNamed:self.arrImage[indexPath.row]];
    cell.title.text = self.arrTitle[indexPath.row];
    
    return cell;

    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    CATransition *animation = [[CATransition alloc] transitionWithType:@"rippleEffect"
                                                            andSubType:kCATransitionFromRight];
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    BNBsaeViewController *root = nil;
    MMDrawerController *vc = nil;
    if (indexPath.row !=3 && indexPath.row !=0) {//除了随手拍 和 客户回访
        
        root = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]
                instantiateViewControllerWithIdentifier:self.arrClass[indexPath.row]];
        vc = [root setRootViewController];
//     [self presentViewController:vc animated:YES completion:nil];
    } else if(indexPath.row == 3) {
        UIViewController *vc = [[self.arrClass[indexPath.row] alloc] init];
        [self presentViewController:vc animated:YES completion:nil];


        return;
    
    } else {// indexPath.row == 0
//        // 根据 ORG_MANAGER_TYPE  直接跳到相应的界面
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"客户回访模块稍后开放!";
//        [hud hide: YES afterDelay: 2];
//------------------暂时不开放---------------------
        
        if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"QQ"]) {
            BNQuanQuViewController *quanQuVC = [BNQuanQuViewController new];
            root = quanQuVC;
            vc = [root setRootViewController];

        } else if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"DS"]){
            BNDiShiViewController *diShiVC = [BNDiShiViewController new];
            root = diShiVC;
            vc = [root setRootViewController];
            
        }else if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"QX"]){
            BNQuXianViewController *quXianVC = [BNQuXianViewController new];
            root = quXianVC;
            vc = [root setRootViewController];

        }else if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"HX"]){
//            BNHuaXiaoViewController *huaXiaoVC = [BNHuaXiaoViewController new];
//            root = huaXiaoVC;
//            vc = [root setRootViewController];
        //全量小区视图
        BNQuanLiangXiaoQuViewController *quanliangxiaoquVC = [BNQuanLiangXiaoQuViewController new];
        root = quanliangxiaoquVC;
        vc = [root setRootViewController];


        }else if ([[LoginModel shareLoginModel].ORG_MANAGER_TYPE isEqualToString:@"WG"]){
            BNWangGeViewController *wangGeVC = [BNWangGeViewController new];
            root = wangGeVC;
            vc = [root setRootViewController];

        }else {
            root = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]
                    instantiateViewControllerWithIdentifier:self.arrClass[indexPath.row]];
            vc = [root setRootViewController];

        }


    }
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

//定义每个cell的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(140 * self.view.frame.size.width/320,100);
    
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}




@end
