//
//  BNNewsViewController.m
//  WorkBench
//
//  Created by wanwan on 16/10/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNNewsViewController.h"
#import "BNWaterMark.h"
#import "BNPushSettingTableViewController.h"
#import "BNMyNewsTableViewController.h"
#import "BNWarningViewController.h"
#import "BNMyNewsModel.h"

@interface BNNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
// 小红点Label
@property (nonatomic, strong) UILabel *redPointLabel;
@end

// 记录红点数
static int redPointNums;

@implementation BNNewsViewController

//- (NSMutableArray *)redPointArray {
//    if (!_redPointArray) {
//        _redPointArray = [NSMutableArray array];
//    }
//    return _redPointArray;
//
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;

    // 水印背景
    UIImage *img = [BNWaterMark getwatermarkImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    [self initTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    // self.hidesBottomBarWhenPushed=NO;
    [self refreshRedPointNums];
    if (redPointNums == 0) {
        self.redPointLabel.hidden = YES;
    }

}

// 刷新小红点数
- (void)refreshRedPointNums {
    
    // 计算小红点
    int days = [self intervalSinceNow:[USERDEFAULT valueForKey:@"lastLoginTime"]];
    NSLog(@"天数===%ld",(long)days);
    // 计算显示消息个数（未打开app天数加上未点击的条数）
    // 读出
    NSData *readData = [USERDEFAULT objectForKey:@"allNews"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
    int pointNum = 0;
    for (BNMyNewsModel *news in array) {
        BOOL isShowRedPoint = news.isShowRedpoint;
        NSLog(@"---红点BOOL---%@",isShowRedPoint ? @"YES" : @"NO");
        if (isShowRedPoint) {
            pointNum +=1;
        }
    }
    NSLog(@"---剩余红点数---%d",pointNum);
    redPointNums = days + pointNum;
     NSLog(@"---天数+剩余红点数---%d",redPointNums);
    // 存储消息个数（小红点数+未登录天数）
    [USERDEFAULT setObject:[NSString stringWithFormat:@"%d", redPointNums] forKey:@"redPointNums"];
    
    // 数字小红点
    NSArray *tabBarItems = self.navigationController.tabBarController.tabBar.items;
    UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:1];
    if (redPointNums != 0) {
        personCenterTabBarItem.badgeValue =[NSString stringWithFormat:@"%d", redPointNums];//显示消息条数
    }

    
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


- (void)initTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

#pragma tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, SCREEN_W , 0.5)];
        lineview.backgroundColor = RGB(255, 146, 50);
        [cell addSubview:lineview];
    }
    cell.backgroundColor = [UIColor clearColor];
   
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (indexPath.row == 0) {
                // redPointLabel.hidden = YES;
        // 如果小红点数不为0就显示
        NSLog(@"---小红点数---%d",redPointNums);
            if (redPointNums != 0) {
                self.redPointLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 8, 8)];
                self.redPointLabel.backgroundColor = [UIColor redColor];
                self.redPointLabel.layer.cornerRadius = 4;
                self.redPointLabel.clipsToBounds = YES;
                [cell addSubview:self.redPointLabel];
               // self.redPointLabel.hidden = YES;
        }
        cell.imageView.image = [UIImage imageNamed:@"small_my_user_back"];
        cell.textLabel.text = @"我的消息";
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"small_my_warning"];
        cell.textLabel.text = @"到期预警";
    } else {
        cell.imageView.image = [UIImage imageNamed:@"small_my_set"];
        cell.textLabel.text = @"推送设置";
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // tabBarItems数字小红点
    NSArray *tabBarItems = self.navigationController.tabBarController.tabBar.items;
    UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:1];
    personCenterTabBarItem.badgeValue = nil;
    if (indexPath.row == 0) {
         self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:[BNMyNewsTableViewController new] animated:YES];
         self.hidesBottomBarWhenPushed=NO;
    } else if (indexPath.row == 1) {
         self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:[BNWarningViewController new] animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    } else {
         self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:[BNPushSettingTableViewController new] animated:YES];
        self.hidesBottomBarWhenPushed=NO;

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
