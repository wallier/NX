//
//  BNWarningController.m
//  WorkBench
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNWarningController.h"
#import "myScrollerView.h"
#import "BNReprotView.h"
#import "BNReportCellModel.h"
#import "MyDatePickerView.h"
#import "PickerViewDateView.h"
#import "NSString+BNDate__String.h"
@interface BNWarningController ()<MyDatePickerViewDelegate>
@property (nonatomic, strong) myScrollerView *scroView;
@property (nonatomic, strong) BNReprotView *reprotView;
@property (nonatomic, strong) NSMutableArray *arrReprot;
@property (nonatomic, strong) NSString *choseDate;         ///<选择日期
@property (nonatomic, strong) NSMutableArray *arrBtn;      ///<按钮数组
@property (nonatomic, strong) PickerViewDateView *picker;

@property (nonatomic, assign) int type;

@end

@implementation BNWarningController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预警";
    
    self.scroView = [[myScrollerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:self.scroView];
    [self.scroView setSegmentCount:(int)self.arrTitle.count andTitle:self.arrTitle];
    [self setBtns];
}

#pragma  mark - 设置条件按钮

- (void)setBtns{

    NSString *strdate = [LoginModel shareLoginModel].LATEST_ACC_MON;
    NSDate *date = [NSString ChangeStringToDate:strdate andFromater:@"yyyyMM"];
    NSString *title = [NSString ChangeDateToString:date andFormater:@"yyyy/MM"];
    
    for (int i = 0 ; i < self.arrTitle.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i *self.view.frame.size.width,
                                   self.scroView.scrollView.frame.size.height - 49,
                                    self.view.frame.size.width, 49)];
        [button setBackgroundColor:Colros(0,118,255)];
        [button setTitle:title forState:UIControlStateNormal];
        [self.scroView.scrollView  addSubview:button];
        
        if (i == 2) {
            NSString *strdate = [LoginModel shareLoginModel].LATEST_ACC_DAY;
            NSDate *date = [NSString ChangeStringToDate:strdate andFromater:@"yyyyMMdd"];
            NSString *title = [NSString ChangeDateToString:date andFormater:@"yyyy/MM/dd"];

            [button setTitle:title forState:UIControlStateNormal];
        }
        button.tag = i;
        [self.arrBtn addObject:button];
        [button addTarget:self action:@selector(choseControdation:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self setReprotView];
}

- (NSMutableArray *)arrBtn{
    if (!_arrBtn) {
        _arrBtn = [NSMutableArray array];
    }
    return _arrBtn;
}

- (NSMutableArray *)arrReprot{
    if (!_arrReprot) {
        _arrReprot = [NSMutableArray array];
    }
    
    return _arrReprot;
}

#pragma mark -设置报表

- (void)setReprotView{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LoginModel shareLoginModel].ORG_ID forKey:@"orgId"];
    [dic setValue:[LoginModel shareLoginModel].ORG_MANAGER_TYPE forKey:@"userType"];
    [dic setValue:[LoginModel shareLoginModel].LATEST_ACC_DAY forKey:@"accDay"];
    [dic setValue:[LoginModel shareLoginModel].LATEST_ACC_MON forKey:@"accMon"];
    //语音
    BNReprotView *reprotView = [[BNReprotView alloc] initWithFrame:
                                CGRectMake(0, 0, self.view.frame.size.width,
                                           self.scroView.scrollView.frame.size.height - 49)];
    reprotView.headArray =  (NSMutableArray *)@[@"",@"超出语音20%",@"超出语音50%"];
    reprotView.url = GetVoiceEarlyWarning;
    [self.scroView.scrollView addSubview:reprotView];
    [self.arrReprot addObject:reprotView];
    [BNNetworkTool initWitUrl:GetVoiceEarlyWarning andParameters:dic andStyle:YES].requestData =
    ^(id requestData){
       
        reprotView.cellArray = (NSMutableArray *)[BNReportCellModel objectArrayWithKeyValuesArray:requestData[@"RESULT"] ];

    };
    
    //流量
    reprotView = [[BNReprotView alloc] initWithFrame:
                  CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width,
                             self.scroView.scrollView.frame.size.height - 49)];
    reprotView.headArray =  (NSMutableArray *)@[@"",@"超出语音20%",@"超出语音50%"];
    reprotView.url = GetFlowEarlyWarning;

    [self.scroView.scrollView addSubview:reprotView];
    [self.arrReprot addObject:reprotView];

    [BNNetworkTool initWitUrl:GetFlowEarlyWarning andParameters:dic andStyle:YES].requestData =
    ^(id requestData){

        reprotView.cellArray = (NSMutableArray *)[BNReportCellModel objectArrayWithKeyValuesArray:requestData[@"RESULT"] ];
        
    };
    
    //协议
    reprotView = [[BNReprotView alloc] initWithFrame:
                  CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width,
                             self.scroView.scrollView.frame.size.height - 49)];
    reprotView.headArray =  (NSMutableArray *)@[@"",@"宽带到期协议续包",@"手机到期协议续包"];
    reprotView.url = GetAgreementEarlyWarning;

    [self.scroView.scrollView addSubview:reprotView];
    [self.arrReprot addObject:reprotView];

    [BNNetworkTool initWitUrl:GetAgreementEarlyWarning andParameters:dic andStyle:YES].requestData =
    ^(id requestData){
       
        reprotView.cellArray = (NSMutableArray *)[BNReportCellModel objectArrayWithKeyValuesArray:requestData[@"RESULT"] ];
        
    };
}

#pragma mark - 设置滚动标题

- (NSArray *)arrTitle{
    return @[@"语音预警",@"流量预警",@"协议到期预警"];
}


- (void)choseControdation:(UIButton *)sender{
    self.type = (int)sender.tag;
    if (sender.tag == 0 || sender.tag == 1) {
        UIButton *btn = self.arrBtn[self.type];
        NSDate *date = [NSString ChangeStringToDate:btn.titleLabel.text andFromater:@"yyyy/MM"];
        NSString *month = [NSString ChangeDateToString:date andFormater:@"yyyyMM"];
        
        MyDatePickerView *pickerView = [[MyDatePickerView alloc] initWithFrame:
                                        CGRectMake(sender.tag *self.view.frame.size.width,
                                                   self.view.frame.size.height - 260 ,
                                                   self.view.frame.size.width, 260)
                                                                andSelectMonth:month];
        
        pickerView.delegate = self;
        [self.scroView.scrollView addSubview:pickerView];
    } else {
        WS;
        self.picker = [[PickerViewDateView alloc] initWithFrame:
                                      CGRectMake(self.view.frame.size.width * 2, self.view.frame.size.height - 260,self.view.frame.size.width, 260)];
        UIButton *btn = self.arrBtn[2];
    
        [self.picker.pickerView setDate:[NSString ChangeStringToDate:btn.titleLabel.text
                                                         andFromater:@"yyyy/MM/dd"] animated:YES];
        [self.scroView.scrollView addSubview:self.picker];
    
        self.picker.send = ^(int tag){
                [weakSelf.picker removeFromSuperview];
        };
        
        self.picker.dates = ^(NSString *date1 ,NSString *date2){
        
            NSLog(@"%@,%@",date1,date2);
            UIButton *btn = weakSelf.arrBtn[2];
            [btn setTitle:date1 forState:UIControlStateNormal];
            [weakSelf requestFormDate:date2];
        };
        
    }
}

- (void)didFinishSelectedDate:(NSString *)date{
    self.choseDate = date;
    [self requestFormDate:self.choseDate];
    NSDate *dates = [NSString ChangeStringToDate:date andFromater:@"yyyyMM"];
    NSString *title = [NSString ChangeDateToString:dates andFormater:@"yyyy/MM"];
    UIButton *btn = self.arrBtn[self.type];
    [btn setTitle:title forState:UIControlStateNormal];
}

- (void)requestFormDate:(NSString *)date{
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view.window];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[LoginModel shareLoginModel].ORG_ID forKey:@"orgId"];
    [dic setValue:[LoginModel shareLoginModel].ORG_MANAGER_TYPE forKey:@"userType"];
    [dic setValue:[LoginModel shareLoginModel].LATEST_ACC_MON forKey:@"accDay"];
    [dic setValue:date forKey:@"accMon"];

    BNReprotView *reportView = self.arrReprot[self.type];
    if (self.type == 2) {
        [dic setValue:[LoginModel shareLoginModel].LATEST_ACC_MON forKey:@"accMon"];
        [dic setValue:date forKey:@"accDay"];
    }
    [BNNetworkTool initWitUrl:reportView.url andParameters:dic andStyle:YES].requestData =
    ^(id requestData){
        [hud setHidden:YES];
        reportView.cellArray = (NSMutableArray *)[BNReportCellModel objectArrayWithKeyValuesArray:requestData[@"RESULT"] ];
    };

}

- (void)dealloc{
    NSLog(@"预警-----dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
