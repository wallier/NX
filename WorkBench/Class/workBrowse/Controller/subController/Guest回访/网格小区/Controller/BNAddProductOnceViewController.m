//
//  BNAddProductOnceViewController.m
//  WorkBench
//
//  Created by wouenlone on 16/9/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNAddProductOnceViewController.h"

@interface BNAddProductOnceViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;


@end

@implementation BNAddProductOnceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    UIView *LongView = [[[NSBundle mainBundle] loadNibNamed:@"BNAddProductOnceViewController" owner:self options:nil] lastObject];
   LongView.frame = CGRectMake(0, 0, self.ScrollView.frame.size.width, self.ScrollView.frame.size.height);
   [self.ScrollView addSubview:LongView];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    self.ScrollView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.ScrollView.delegate = nil;
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
