//
//  BNLDViewController.m
//  WorkBench
//
//  Created by mac on 16/2/3.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNLDViewController.h"
#import "BNOrderDetailController.h"
@interface BNLDViewController ()

@end

@implementation BNLDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyBoardShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyBoardHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [self setNavtitle];
    self.accr.text = self.model.USER_ACCR;
    self.name.text = self.model.USER_NAME;
    self.taocan.text = self.model.OFFER_BRAND;
    self.time.text = self.model.START_DATE;
    self.kind.text = self.model.USER_KIND;
    self.device.text = self.model.TERMINAL_INTEREST;
    self.about.text = self.model.USER_INTEREST;
    self.introduce.text = [[NSString stringWithFormat:@"%@:",self.model.USER_SEX] stringByAppendingString:[self.model.RH_TYPE isEqualToString:@"否"]?@"非融合":@"融合"];
    [self.btncommit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setModel:(BNLDModel *)model{
    _model = model;
}

#pragma mark - 录单提交

- (void)commit{

    if ([self.textRecord.text length] == 0 ||[self.textRecord.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"工单录入信息不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
   

    [_params setValue:self.textRecord.text forKey:@"receiptBoby"];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"正在录入..." toView:self.view];
//    NSLog(@"self.params000===%@", self.params);
//    return;
//    NSString* strUrl = @"";
//        strUrl = [ExecuteGrabgdstautsend stringByAppendingFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",[self.params objectForKey:@"serviceType"], [self.params objectForKey:@"sanFlag"], [self.params objectForKey:@"taskId"], [self.params objectForKey:@"policyId"], [self.params objectForKey:@"userAccr"], [self.params objectForKey:@"userType"], [self.params objectForKey:@"orgId"], [self.params objectForKey:@"userId"], [self.params objectForKey:@"workOrderType"], [self.params objectForKey:@"stateExecutePerson"]];
    
    [BNNetworkTool initWitUrl:DataPoolEnteringThreeURL andParameters:self.params andStyle:YES].requestData = ^(id responseObject){
        [hud setHidden:YES];
        NSLog(@"%@",responseObject);
        if([@"401" isEqualToString:[responseObject valueForKey:@"MSGCODE"]]){
            
            [self.view makeToast:@"录入成功" duration:1.0 position:CSToastPositionCenter];
            
            NSMutableDictionary *dics = [NSMutableDictionary dictionary];
            [dics setValue:[LoginModel shareLoginModel].orderDetail.ORDER_NO forKey:@"orderNo"];    //工单流水
            [dics setValue:@"" forKey:@"orderBody"];    //回单内容，传入是为空字符串
            [dics setValue:[LoginModel shareLoginModel].orderDetail.USER_ID forKey:@"userId"];    //用户实例id
            [dics setValue:[LoginModel shareLoginModel].orderDetail.POLICY_ID forKey:@"policyId"];  //策略ID
            [dics setValue:[LoginModel shareLoginModel].LOGIN_ID forKey:@"staffId"];    //登录工号 （staff_id）
            [dics setValue:[LoginModel shareLoginModel].orderDetail.START_DATE  forKey:@"startDate"];   //工单创建时间
            [dics setValue:@"1" forKey:@"orderstate"];    //工单状态
            [dics setValue:@"" forKey:@"resultHs"];    //返回参数，传入是为空字符串
            
           /* NSString *Strs = [NSString stringWithFormat:@"%@?",HXdatacoordinationwithCRM];
            
            for (int i = 0; i <[dics count]; i++) {
                Strs = [Strs stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",[[dics allKeys] objectAtIndex:i],[[dics allValues] objectAtIndex:i]]];
            }
            NSLog(@"参数和url－－－－－－－%@\n－－－－－－－－",Strs);
            */
            
            //调用crm函数工单同步
            [BNNetworkTool initWitUrl:HXdatacoordinationwithCRM andParameters:dics andStyle:YES].requestData = ^(id requestData){
                
                [BNNetworkTool initWitUrl:DataPoolGDStautsEndURL andParameters:_params andStyle:YES].requestData = ^(id requestData){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
                };
                
                [self performSelector:@selector(back) withObject:self afterDelay:1];
            };
            
        }else{
            [self.view makeToast:@"录入失败" duration:1.0 position:@"center"];
        }
    };
}

- (void)setNavtitle{
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0,self.view.frame.size.width / 2, 40)];
    [back setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [back setTitle:@"< 返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backs) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
}
- (void)back{
    NSArray *arr = [NSArray arrayWithArray:self.navigationController.childViewControllers];
    for (UIViewController *vc in arr) {
        if ([[vc class] isSubclassOfClass:[BNOrderDetailController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
}

- (void)backs{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillLayoutSubviews{
    self.textRecord.layer.borderWidth = 1;
    self.textRecord.layer.borderColor = [UIColor redColor].CGColor;
    self.textRecord.layer.cornerRadius = 4;
    self.textRecord.width = self.view.width - self.textRecord.x - 10;
    self.btncommit.width = self.view.width - self.btncommit.x - 10;
    self.accr.width = self.textRecord.width;
    self.name.width = self.textRecord.width;
    self.device.width = self.textRecord.width;
    self.about.width = self.textRecord.width;
    self.time.width = self.textRecord.width;
    self.taocan.width = self.textRecord.width;
    self.labTitle.center = CGPointMake(self.view.width/2, self.labTitle.center.y);
}
- (void)KeyBoardShow:(NSNotification *)notification{
    CGSize  size = [[notification userInfo][@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size;
    CGFloat offset = CGRectGetMaxY(self.btncommit.frame) + size.height - self.view.frame.size.height;
    if (offset > 0 ) {
        [UIView animateWithDuration:1.0f animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -offset);
        }];
    }
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textRecord resignFirstResponder];
}

- (void)KeyBoardHidden:(NSNotification *)notification{
    self.view.transform = CGAffineTransformIdentity;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
