//
//  BNRightViewController.m
//  WorkBench
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNRightViewController.h"
#import "BNUser360Controller.h"
#import "BNWarningController.h"
#import "BNMyWorkController.h"
//#import "BNUserVisitController.h"// 旧客户回访
#import "BNQuanQuViewController.h" // 新客户回访
#import <MMDrawerBarButtonItem.h>
#import "TakePhotoViewController.h"
@interface BNRightViewController ()
@property (nonatomic, strong) NSArray *arrTitle;
@property (nonatomic, strong) NSArray *arrImg;
@property (nonatomic, strong) NSArray *arrClass;


@end

@implementation BNRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营销网格";
    
}

- (NSArray *)arrClass{
    
    return @[@"",
             @"GuestVisit",
             @"myWork",
             @"yujing",
             [TakePhotoViewController class],
             @"user360"];
}

- (NSArray *)arrTitle{
    return [NSArray arrayWithObjects:@"首页",@"客户回访" ,@"我的工作",@"预警",@"随手拍",@"用户360",
            nil];
}

- (NSArray *)arrImg{
    return [NSArray arrayWithObjects:@"small_home",@"small_my_user_back",@"small_my_datapool",
            @"small_my_warning",@"suishoupai", @"small_my_user360",nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrImg.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:self.arrImg[indexPath.row]];
    cell.textLabel.text = self.arrTitle[indexPath.row];
    
    return cell;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self Back];
        return;
    }
    if ([self.arrTitle[indexPath.row] isEqualToString:self.mmdrawer.centerViewController.title]) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    } else {
        if (indexPath.row == 4) {
            UIViewController *vc = [[self.arrClass[4] alloc] init];
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];

            [self presentViewController:vc animated:YES completion:nil];
        } else {
            BNBsaeViewController *root = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]
                                          instantiateViewControllerWithIdentifier:self.arrClass[indexPath.row]];
            UIViewController *vc = [root setRootViewController];
            [self.mm_drawerController setCenterViewController:vc withCloseAnimation:YES completion:nil];
        }
    }
}

- (void)setNav:(UIViewController *)dest{
    
    //leftBarbuttonItem
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setFrame:CGRectMake(0, 0,30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [btn setContentMode:UIViewContentModeCenter];
    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dest.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    //rightBarbuttonItem
    MMDrawerBarButtonItem *item = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(Move)];
    dest.navigationItem.rightBarButtonItem = item;
    
}

- (void)Back{
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    // animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)Move{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}


- (void)dealloc{
    NSLog(@"rightMenu--dealloc");
}
@end
