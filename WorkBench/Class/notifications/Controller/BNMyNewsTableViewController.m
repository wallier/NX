//
//  BNMyNewsTableViewController.m
//  WorkBench
//
//  Created by wanwan on 16/10/19.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNMyNewsTableViewController.h"
#import "BNMyNewsTableViewCell.h"
#import "BNWarningViewController.h"
#import "BNMyNewsTableViewCell.h"
#import "BNMyNewsModel.h"
#import "BNMyNewsContentViewController.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import "BNMyNewsContentViewController.h"

@interface BNMyNewsTableViewController ()
// 请求新消息数组
@property (nonatomic, strong) NSMutableArray *newsArray;
// 所有消息数组
@property (nonatomic, strong) NSMutableArray *allNewsArray;
// 小红点数组
@property (nonatomic, strong) NSMutableArray *redPointArray;
// 日期数组
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) MBProgressHUD *hud;
// 读存储的数组
//@property (nonatomic, strong) NSArray *readArray;
@property (nonatomic, strong) BNMyNewsModel *cell1;
@property (nonatomic, strong) BNMyNewsModel *cell2;
//@property (nonatomic, strong) BNMyNewsModel *cell;
// 记录差几天
@property (nonatomic, assign) NSInteger days;

@property (nonatomic, assign)BOOL isfirst;
@end

@implementation BNMyNewsTableViewController
// 切记，网懒加载NSMutableArray中添加数据的时候不能用"_"要用"self"
- (NSMutableArray *)newsArray {
    if (!_newsArray) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}

- (NSMutableArray *)redPointArray {
    if (!_redPointArray) {
        _redPointArray = [NSMutableArray array];
    }
    return _redPointArray;
}

- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (NSMutableArray *)allNewsArray {
    if (!_allNewsArray) {
        _allNewsArray = [NSMutableArray array];
    }
    return _allNewsArray;
}
// 注意优化
- (void)viewWillAppear:(BOOL)animated {
    
    [self viewDidLoad];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    self.title = @"我的消息";
    //self.tabBarController.tabBar.hidden=YES;
    // 判断差几天
    self.days = [self intervalSinceNow:[USERDEFAULT valueForKey:@"lastLoginTime"]];
    NSLog(@"------相差%ld几天------",(long)self.days);
    
    [self loadData];
}

- (void)loadData {
    // 根据上次的登录时间和当前时间打印出中间相差的时间
    if (self.days == 0) {
        // 加载上一次数据
        // 读出
        NSData *readData = [USERDEFAULT objectForKey:@"allNews"];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
        _allNewsArray = [NSMutableArray arrayWithArray:array];
        
        [self.tableView reloadData];
    } else {
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.margin = 10.0f;
        self.hud.removeFromSuperViewOnHide = YES;
        self.hud.labelText = @"数据加载中...";
        
        // 差一天加载今天的
        for (int i = 1; i<=self.days; i++) {
            // 获取未加载的日期
            [self.dateArray addObject:[self computeDateWithDays:i]];
            // NSLog(@"--新日期---%@",[self computeDateWithDays:i]);
        }
        
        [self getRequest];
        
        // 存储今天时间为最近登录时间
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYYMMdd"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        // 存储登录时间
        [USERDEFAULT setObject:dateString forKey:@"lastLoginTime"];
        
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

//计算上次登录后的新日期
- (NSString *)computeDateWithDays:(NSInteger)days
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    // 根据上次登录的时间叠加新的日期60 * 60 * 24
    NSDate *myDate = [dateFormatter dateFromString:[USERDEFAULT valueForKey:@"lastLoginTime"]];
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * days];
    
    return [dateFormatter stringFromDate:newDate];
}

- (void)getRequest {
    //这里写网络请求
    WS
    for (NSString *str in _dateArray) {
        NSLog(@"-----URL-----%@",[weakSelf getURLWithDate:str]);
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        [mgr GET:[weakSelf getURLWithDate:str] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            [weakSelf.hud setHidden:YES];
            BNMyNewsModel *cell = [[BNMyNewsModel alloc] init];
            cell.image = [UIImage imageNamed:@"small_my_warning"];
            cell.title = @"即将到期提醒";
            NSDateFormatter *dateFormatter1 = [NSDateFormatter new];
            [dateFormatter1 setDateFormat:@"YYYYMMdd"];
            NSDate *myDate = [dateFormatter1 dateFromString:str];
            NSDateFormatter *dateFormatter2 = [NSDateFormatter new];
            [dateFormatter2 setDateFormat:@"YYYY-MM-dd"];
            NSString *dataStr = [dateFormatter2 stringFromDate:myDate];
            cell.times = dataStr;
            cell.deadlineNums = responseObject[@"SIZE"];
            cell.isShowRedpoint = YES;
            [weakSelf.newsArray addObject:cell];
            // 判断全部返回后排序展示
            if (weakSelf.newsArray.count == weakSelf.dateArray.count) {
                [weakSelf sortedNewsArray];
            }
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf.hud setHidden:YES];
            NSLog(@"失败-%@",error);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"您的网络不给力!";
            [hud hide: YES afterDelay: 2];
        }];
        
    }
    
}

- (void)sortedNewsArray {
    WS
    [self.newsArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        weakSelf.cell1 = obj1;
        weakSelf.cell2 = obj2;
        // 转化时间格式
        NSDateFormatter *dateFormatter1 = [NSDateFormatter new];
        [dateFormatter1 setDateFormat:@"YYYY-MM-dd"];
        NSDate *myDate1 = [dateFormatter1 dateFromString:weakSelf.cell1.times];
         NSDate *myDate2 = [dateFormatter1 dateFromString:weakSelf.cell2.times];
        
        NSDateFormatter *dateFormatter2 = [NSDateFormatter new];
        [dateFormatter2 setDateFormat:@"YYYYMMdd"];
        NSString *dataStr1 = [dateFormatter2 stringFromDate:myDate1];
        NSString *dataStr2 = [dateFormatter2 stringFromDate:myDate2];
        NSLog(@"-dataStr1-%@--",dataStr1);
        NSLog(@"-dataStr2-%@--",dataStr2);
        if ([dataStr1 integerValue] < [dataStr2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([dataStr1 integerValue] > [dataStr2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSLog(@"----newsArray长度-----%lu",(unsigned long)self.newsArray.count);
    // 把新获取的数据放在老数据前面
    [self.newsArray addObjectsFromArray:[self.allNewsArray copy]];
    
    self.allNewsArray = self.newsArray;
    NSLog(@"----allNewsArray长度-----%lu",(unsigned long)self.allNewsArray.count);

    // 存储只能存不可变数组
    // 写入
    NSArray *arr = [NSArray arrayWithArray:_allNewsArray];
    NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [USERDEFAULT setObject:writeData forKey:@"allNews"];
}

- (NSString *)getURLWithDate:(NSString*)date; {
    
    return [[[[[WARNINGURL stringByAppendingString:date]stringByAppendingString:@"/"]stringByAppendingString:[LoginModel shareLoginModel].ORG_MANAGER_TYPE]stringByAppendingString:@"/"]stringByAppendingString:[LoginModel shareLoginModel].ORG_ID];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return ;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return _allNewsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取即将过期的 人数  时间
    BNMyNewsModel *cellModel = _allNewsArray[indexPath.row];
    BNMyNewsTableViewCell *cell = [BNMyNewsTableViewCell cellWithTableView:self.tableView andNums:[cellModel.deadlineNums integerValue] andTime:cellModel.times andNewsTitle:cellModel.title andSownRedPoint: cellModel.isShowRedpoint];
    
    
    // redPointLabel.tag = indexPath.row + 10000;
    
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BNMyNewsModel *cellModel = _allNewsArray[indexPath.row];
    cellModel.isShowRedpoint = NO;
    // 存储数组
    // 写入
    NSArray *arr = [NSArray arrayWithArray:_allNewsArray];
    NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [USERDEFAULT setObject:writeData forKey:@"allNews"];
    // 传参数
    BNMyNewsContentViewController *contentVC = [[BNMyNewsContentViewController alloc] init];
    contentVC.deadLineNums = cellModel.deadlineNums;
    contentVC.date = cellModel.times;
    // 存储点状态
    [self.navigationController pushViewController:contentVC animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_allNewsArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // 写入
        NSArray *arr = [NSArray arrayWithArray:_allNewsArray];
        NSData *writeData = [NSKeyedArchiver archivedDataWithRootObject:arr];
        [USERDEFAULT setObject:writeData forKey:@"allNews"];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
