//
//  BNMyNewsContentViewController.m
//  WorkBench
//
//  Created by wanwan on 16/10/21.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNMyNewsContentViewController.h"

@interface BNMyNewsContentViewController ()
@property (nonatomic, strong) UITextView *newsTextView;
@end

@implementation BNMyNewsContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息简介";
    [self addTextView];
}

- (void)addTextView {
    _newsTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    _newsTextView.text = [NSString stringWithFormat:@"截止%@，即将过期%@位用户，请到到期预警中查看详细信息，及时与客户联系，做好相应的处理。",self.date, self.deadLineNums];
    [self.view addSubview:_newsTextView];


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
