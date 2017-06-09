//
//  BNUser360Controller.m
//  WorkBench
//
//  Created by mac on 16/1/21.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import <Masonry.h>
#import "BNValueView.h"
#import "BNProductLists.h"
#import "BNUser360Controller.h"
#import "BNValueModel.h"
#import "BNCountModel.h"
#import "BNBehaverModel.h"
@interface BNUser360Controller ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *btnValue;               ///<价值目标
@property (nonatomic, strong) UIButton *btnCount;               ///<稳定指数
@property (nonatomic, strong) UIButton *btnBehaver;             ///<业务行为
@property (weak, nonatomic) IBOutlet UITextField *textPhoNum;   ///<号码框
@property (weak, nonatomic) IBOutlet UILabel *userName;         ///<用户姓名
@property (weak, nonatomic) IBOutlet UILabel *introduce;        ///<用户介绍
@property (weak, nonatomic) IBOutlet UIButton *proNum;          ///<用户产品
@property (nonatomic, strong) BNValueModel *valueModel;         ///<价值目标
@property (nonatomic, strong) BNCountModel *countModel;         ///<稳定指数
@property (nonatomic, strong) BNBehaverModel *behaverModel;     ///<业务行为
@property (weak, nonatomic) IBOutlet UIImageView *phoneImg;

@property (nonatomic, strong) NSArray *arrPro;                  ///<产品数量
@property (weak, nonatomic) IBOutlet BNValueView *ValueView;    ///<价值目标
@property (nonatomic, strong) NSArray *arrCellData;             ///< 表格数据

@property (nonatomic, strong) UIButton *btnSelect;

@property (weak, nonatomic) IBOutlet UIView *CountView;         ///<稳定指数
@property (weak, nonatomic) IBOutlet UITableView *CountTableView;
@property (nonatomic, strong) UIView *maskViews;

@property (nonatomic, strong) BNProductLists *lists;
@property (nonatomic, strong) NSArray *arrMenuModel;            ///<菜单

@end

@implementation BNUser360Controller


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户360";
    [self addChoseBtns];
    self.ValueView.ValueTableView.delegate = self;
    self.ValueView.ValueTableView.dataSource = self;

}

- (void)getMenu{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [paramDic setValue:[LoginModel shareLoginModel].ORG_MANAGER_TYPE forKey:@"roleCode"];
    [paramDic setValue:[LoginModel shareLoginModel].USER_ID forKey:@"userId"];
    NSString *url = RESPORT_INTERFACE;
    [BNNetworkTool initWitUrl:url andParameters:paramDic andStyle:YES].requestData = ^(id requestData){
        NSLog(@"%@",requestData);
        self.arrMenuModel = [BNMenuModel objectArrayWithKeyValuesArray:requestData[@"MENU"]];
        for (BNMenuModel *model  in self.arrMenuModel) {
            if ([model.MENU_NAME containsString:@"360"]) {
                self.menuModel = model;

                NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithCapacity:1];
                [paramDic setValue:self.menuModel.MENU_ID forKey:@"menuId"];
                [paramDic setValue:[LoginModel shareLoginModel].ORG_MANAGER_TYPE forKey:@"roleCode"];
                NSString *subMenuURL = SUBMENU_INTERFACE;
                [BNNetworkTool initWitUrl:subMenuURL andParameters:paramDic andStyle:YES].requestData =
                ^(id requestData){
                    
                    NSString *urlStr = requestData[@"PAGE_CONTENT"][0][@"URL"];

                NSMutableString *paramsStr = [NSMutableString stringWithString:@"?"];
                [paramsStr appendString:[NSString stringWithFormat:@"phoneNumber=%@", self.textPhoNum.text]];
                    NSLog(@"-------urlStr-------%@",urlStr);
                    NSString *URL = [NSString stringWithFormat:@"%@%@",urlStr,paramsStr];

              //  http://202.100.110.55:9081/scm_ningxia_ios/pages/mbuilder/usepage/formal/R20150511155616107/formal_R20150511155616107.jsp?phoneNumber=18995112063
                    // web下的URL
                    NSLog(@"--web---URL----%@",URL);
                    // 加载webView的URL
                [self.ValueView.ValueWebView loadRequest:[NSURLRequest requestWithURL:[NSURL
                                           URLWithString:URL]]];
                    NSLog(@"%@",requestData);
                    
                };
            }
        }
        
        
    };

}
- (void)addMaskView{
    self.maskViews = [[UIView alloc] init];
    [self.maskViews setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_maskViews];
}
- (void)addChoseBtns{
    
    [self.proNum addTarget:self action:@selector(checkPro) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnValue = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnValue setTitle:@"价值目标" forState:UIControlStateNormal];
    [self.btnValue addTarget:self action:@selector(getValue:)
            forControlEvents:UIControlEventTouchDown];
    [self.btnValue setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    self.btnValue.tag = 0;
    [self setFont:self.btnValue];
    [self.view addSubview:self.btnValue];
    
    self.btnCount = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnCount setTitle:@"稳定指数" forState:UIControlStateNormal];
    [self.btnCount addTarget:self action:@selector(getValue:)
            forControlEvents:UIControlEventTouchDown];
    self.btnCount.tag = 1;
    [self setFont:self.btnCount];
    [self.view addSubview:self.btnCount];
    
    self.btnBehaver = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnBehaver setTitle:@"业务行为" forState:UIControlStateNormal];
    [self.btnBehaver addTarget:self action:@selector(getValue:)
              forControlEvents:UIControlEventTouchDown];
    self.btnBehaver.tag = 2;
    [self setFont:self.btnBehaver];
    [self.view addSubview:self.btnBehaver];
    
     [self addMaskView];

    
}


#pragma mark - 价值目标 - 稳定指数 - 业务行为

- (void)getValue:(UIButton *)sender{
    if (![self.textPhoNum.text length]) {
        [MBProgressHUD showError:@"请填写用户号码"];
        return;
    }
    if (sender.selected) {
        return;
    }
    if (self.btnSelect != sender) {
        self.btnSelect.selected = NO;
        self.btnSelect = sender;
        self.btnSelect.selected = YES;
    }
    if (sender.tag == 0) {
        [self.CountView setHidden:YES];
        [self.ValueView setHidden:NO];
        
    } else {
        [self.ValueView setHidden:YES];
        [self.CountView setHidden:NO];
        
    }
    [self sendRequest:sender.tag == 0?@"valuegoal":sender.tag == 1?
     @"stabilityindex":@"businessaction" byTag:(int)sender.tag];
    
}

#pragma mark - 搜索号码

- (IBAction)btnSearch:(id)sender {
    
    if (![self judgeTextNull]) {
        return;
    }
    [self.maskViews setHidden:NO];
    [self.CountView setHidden:YES];
    [self.ValueView setHidden:NO];
    if (self.btnSelect != self.btnValue) {
        self.btnSelect.selected = NO;
        self.btnSelect = self.btnValue;
        self.btnValue.selected = YES;
    }
    [self getMenu];

    [self sendRequest:@"valuegoal" byTag:0];
    [self.textPhoNum resignFirstResponder];

    
    
}


#pragma mark - 发送请求

- (void)sendRequest:(NSString*)parameters byTag:(int)tag{
    if (![self judgeTextNull]) {
        [MBProgressHUD showError:@"请填写用户号码"];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"/%@/%@",parameters,self.textPhoNum.text];
    
    NSString *Url = [USER_360_URL stringByAppendingString:url];
    NSLog(@"----360URL-----%@",Url);
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
    [BNNetworkTool initWitUrl:Url andParameters:nil andStyle:NO].requestData = ^(id requestData){
        [hud setHidden:YES];
        if(tag == 0) {
            if (![requestData[@"RESULT"] count]) {
                [MBProgressHUD showError:@"数据异常"];
                self.maskViews.transform = CGAffineTransformIdentity;
                [self.maskViews setHidden:NO];

                return ;
            }
            [self.maskViews setHidden:YES];

            self.valueModel = [BNValueModel objectWithKeyValues:requestData[@"RESULT"][0]];
            self.userName.text = self.valueModel.CUST_NAME;
            if ([self.valueModel.SEX isEqualToString:@"男"]) {
                self.phoneImg.image = [UIImage imageNamed:@"man_head"];
            }
                [self.proNum setTitle:self.valueModel.ACC_NBR forState:UIControlStateNormal];
                self.arrCellData = @[@{@"价值:":self.valueModel.VALUE_LEVEL_FLAG},
                                     @{@"终端:":self.valueModel.PHONE_MODEL},
                                     @{@"地域归属:":self.valueModel.UNION_ORG_NAME},
                                     @{@"客户名称:":self.valueModel.CUST_NAME},
                                     @{@"用户套餐:":self.valueModel.MAIN_OFFER_NAME},
                                     @{@"账户Arpu:":self.valueModel.ACCT_ARPU},
                                     @{@"账户收入:":self.valueModel.ACCT_FEE},
                                     @{@"用户收入:":self.valueModel.FEE}
                                     ];
                [self.ValueView.ValueTableView reloadData];
           
        } else if (tag == 1){
            self.countModel = [BNCountModel objectWithKeyValues:requestData[@"RESULT"][0]];
            self.arrCellData = @[@{@"稳定度:":self.countModel.H_FLAG},
                                 @{@"融合:":self.countModel.RH_INFO},
                                 @{@"用户网龄:":self.countModel.INNET_MONTH},
                                 @{@"终端网龄:":self.countModel.TERM_AGE},
                                 @{@"是否快销卡:":self.countModel.IS_FPCARD},
                                 @{@"是否合约:":self.countModel.TREATY_FLAG},
                                 @{@"用户欠费:":self.countModel.OWE_FEE},
                                 @{@"交往圈数:":self.countModel.CALL_OBJ_NUM},
                                 ];
            [self.CountTableView reloadData];
            
            
        } else {
            self.behaverModel = [BNBehaverModel objectWithKeyValues:requestData[@"RESULT"][0]];
            self.arrCellData = @[@{@"-":self.behaverModel.ACTIVE_INFO},
                                 @{@"-":self.behaverModel.ACTIVE_INFO_PREFER},
                                 @{@"-":self.behaverModel.CALLING_DURA},
                                 @{@"-":self.behaverModel.FLOW_FLUX_1},
                                 @{@"-":self.behaverModel.SMS},
                                 @{@"-":self.behaverModel.LOC_CALL_ZB},
                                 @{@"-":self.behaverModel.CALL_DOWN_HB},
                                 @{@"-":self.behaverModel.FLOW_DOWN_HB},
                                 ];
            [self.CountTableView reloadData];
            
            
            
        }
    };
    
    NSString *url2 = [NSString stringWithFormat:@"/usernumberlistaction/%@",self.textPhoNum.text];
    NSString *Url2 = [USER_360_URL stringByAppendingString:url2];
    NSLog(@"--USER_360_URL---%@",Url2);
    //  http://202.100.110.55:9081/scm/user360view/usernumberlistaction/18995110263
    [BNNetworkTool initWitUrl:Url2 andParameters:nil andStyle:NO].requestData = ^(id requestData){
        NSLog(@"%@",requestData);
        self.arrPro = [NSArray arrayWithArray:requestData[@"RESULT"]];
        self.introduce.text = [NSString stringWithFormat:@"该客户共有%ld个产品",(unsigned long)self.arrPro.count];
    };
    
    
}
#pragma mark - 用户产品查看

- (void)checkPro{
    [self.maskViews setHidden:NO];
    self.maskViews.transform = CGAffineTransformScale(self.maskViews.transform, 1, 2);
    self.lists = [[BNProductLists alloc] initWithFrame:CGRectMake(0, 0, 250, 300)];
    WS;
    self.lists.senddata = ^(NSString *num){
        weakSelf.textPhoNum.text = num;
        [weakSelf btnSearch:weakSelf.btnValue];
        [weakSelf.maskViews setHidden:YES];
        [weakSelf.lists removeFromSuperview];
    };
    self.lists.center = self.view.window.center ;
    [self.view.window addSubview:self.lists];
    _lists.data = self.arrPro;
    
}

#pragma mark - 文字空判断

- (BOOL)judgeTextNull{
    if (![self.textPhoNum.text length]){
        [MBProgressHUD showError:@"请填写用户号码"];
        return NO;
    }
    return YES;
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrCellData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    NSDictionary *dic = self.arrCellData[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text =[NSString stringWithFormat:@"%@%@",[dic allKeys][0],[dic allValues][0]];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}

#pragma mark -textfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.textPhoNum resignFirstResponder];
    return YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.lists removeFromSuperview];
    self.maskViews.transform = CGAffineTransformIdentity;
    if ((self.maskViews.hidden && [self.textPhoNum.text length]) || (self.lists)) {
        [self.maskViews setHidden:YES];
    }
    [self.textPhoNum resignFirstResponder];
}

#pragma mark - 返回处理

- (void)dealDate{
    if (self.lists) {
        [self.lists removeFromSuperview];
    }
}
#pragma mark - 设置底部button
- (void)setFont:(UIButton *)sender{
    [sender.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [sender setBackgroundColor:Colros(0,118,255)];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
}

#pragma mark - 重新布局
- (void)viewWillLayoutSubviews{
    
    int offset = 2;
    
    CGFloat w = (self.view.frame.size.width - offset) / 3;
    
    NSNumber *weight = [NSNumber numberWithFloat:w];
    
    [self.btnValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.width.equalTo(weight);
        make.height.equalTo(@49);
    }];
    [self.btnCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.btnValue.mas_right).offset(offset / 2);
        make.width.equalTo(weight);
        make.height.equalTo(@49);
    }];
    [self.btnBehaver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.width.equalTo(weight);
        
        make.left.equalTo(self.btnCount.mas_right).offset(offset / 2);
        make.height.equalTo(@49);
    }];
    
    [self.maskViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(CGRectGetMaxY(self.textPhoNum.frame)+2));
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    NSLog(@"user360--dealloc");
}

@end
