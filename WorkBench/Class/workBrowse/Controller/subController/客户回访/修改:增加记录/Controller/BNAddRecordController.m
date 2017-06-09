//
//  BNAddRecordController.m
//  WorkBench
//
//  Created by mac on 16/2/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNAddRecordController.h"
#import "PickerViewDateView.h"
#import "NSString+BNDate__String.h"
#import "BNRecordList.h"
@interface BNAddRecordController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSArray *arr_type;    ///< 类型
@property (nonatomic, strong) NSArray *arr_operator;///< 运营商
@property (nonatomic, strong) UIView *blockView;
@property (nonatomic, strong) NSDictionary *dicOperator;
@property (nonatomic, strong) NSDictionary *dictype;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) PickerViewDateView *picker;


@end

@implementation BNAddRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setInfo];
}

- (void)setInfo{

    self.xiaoqu.text = self.model.model3.XIAOQU_NAME;
    self.louhao.text = self.model.model1.LOUHAO;
    self.danyuan.text = self.model.model1.DANYUAN;
    self.fanghao.text = self.model.model1.FANGHAO;
    if (self.model.model2.TELE_TYPE_DESC)
        [self.pro setTitle:self.model.model2.TELE_TYPE_DESC forState:UIControlStateNormal];
    
    if (self.model.model2.DEV_NUMBER)
        self.yewuhao.text = self.model.model2.DEV_NUMBER;
    
    if (self.model.model2.OPERATORS_DESC)
        [self.yunyingshang setTitle:self.model.model2.OPERATORS_DESC forState:UIControlStateNormal];
    if (self.model.model2.END_TIME)
        [self.xieyidaoqi setTitle:self.model.model2.END_TIME forState:UIControlStateNormal];
    
    [self.yunyingshang addTarget:self action:@selector(choseOperator:) forControlEvents:UIControlEventTouchUpInside];
    [self.xieyidaoqi addTarget:self action:@selector(chonseEndDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.pro addTarget:self action:@selector(chosePro:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (UIView *)blockView{
    if (!_blockView) {
        _blockView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_blockView setBackgroundColor:[UIColor blackColor]];
        [self.blockView setAlpha:0];

    }
    return _blockView;
}
- (void)choseOperator:(UIButton *)sender{
    
    [self addListView:self.arr_operator andSender:sender andflag:YES];
  
}

- (void)addListView:(NSArray *)arrData andSender:(UIButton *)sender andflag:(BOOL)flag{
    [UIView animateWithDuration:1 animations:^{
        [self.view addSubview:self.blockView];
        [self.blockView setAlpha:0.6];
    }];
    BNRecordList *listOper = [[BNRecordList alloc] initWithFrame:CGRectMake(0, 0, 250, arrData.count * 44)];
    __weak typeof(listOper) list = listOper;
    listOper.center = CGPointMake(self.view.center.x, self.view.frame.size.height / 2);
    listOper.data = arrData;
    listOper.sendList = ^(NSDictionary *dic){
        if (flag) {
            self.dicOperator = dic;
        } else {
            self.dictype = dic;
        }
        [sender setTitle:[dic allKeys][0] forState:UIControlStateNormal];

        [list removeFromSuperview];
        [self.blockView removeFromSuperview];
        self.blockView = nil;
    };
    [self.view addSubview:listOper];
}

- (void)chonseEndDate:(UIButton *)sender{
    WS;
    self.picker = [[PickerViewDateView alloc] initWithFrame:
                   CGRectMake(0, self.view.frame.size.height - 256,self.view.frame.size.width, 256)];
    if (self.model.model2.END_TIME) {
        [self.picker.pickerView setDate:[NSString ChangeStringToDate:self.model.model2.END_TIME andFromater:@"yyyy/MM/dd"]];
    }
    
    [self.view addSubview:self.picker];
    
    
    self.picker.send = ^(int tag){
        [weakSelf.picker removeFromSuperview];
    };
    self.picker.dates = ^(NSString *date1 ,NSString *date2){
        [sender setTitle:date1 forState:UIControlStateNormal];
        weakSelf.endTime = date2;
    };
    

}

- (void)chosePro:(UIButton *)sender{
    [self addListView:self.arr_type andSender:sender andflag:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Save:(id)sender {
  
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"YYYYMMdd"];
    NSDate *date = [NSDate date];
    NSString *accday = [formater stringFromDate:date];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:1];

    //修改
    
    [params setValue:self.model.model2.HF_NO forKey:@"hfNo"];
    //增加
    [params setValue:self.model.model3.XIAOQU_NAME forKey:@"xiaoQuName"];
    [params setValue:self.model.model3.XIAOQU_ID  forKey:@"xiaoQuId"];
    [params setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"gridID"]
              forKey:@"gridNo"];
    
    [params setValue:self.model.model1.LOUHAO?:[self.louhao.text stringByAppendingString:@"号楼"]  forKey:@"louHao"];
    [params setValue:self.model.model1.DANYUAN?:[self.danyuan.text stringByAppendingString:@"单元"] forKey:@"danYuan"];
    [params setValue:self.model.model1.FANGHAO?:[self.fanghao.text stringByAppendingString:@"室"] forKey:@"fangHao"];
    
    [params setValue:self.model.model2.DEV_NUMBER?:self.yewuhao.text forKey:@"deviceNumber"];
    [params setValue:self.model.model2.TELE_TYPE?:[self.dictype allValues][0] forKey:@"teleType"];
    [params setValue:self.model.model2.OPERATORS?:[self.dicOperator allValues][0] forKey:@"operators"];
    
    [params setValue:accday forKey:@"accDay"];
    [params setValue:self.zoufangResult.text forKey:@"revisitResult"];
    [params setValue:[LoginModel shareLoginModel].LOGIN_ID forKey:@"loginId"];
    
    if (![self checkError:params]) {
        [MBProgressHUD showError:@"参数不完整，请确认"];
        return;
    }
    [BNNetworkTool initWitUrl:self.flag?GXKHHF:ADDKHURL andParameters:params andStyle:YES].requestData =
        ^(id responseObject){
            if ([[responseObject valueForKey:@"MSGCODE"] isEqualToString:@"700"] ||
                [[responseObject valueForKey:@"MSGCODE"]isEqualToString:@"401"]) {
                [self.view makeToast:@"更新成功" duration:0.5 position:CSToastPositionCenter];
            }else{
                [self.view makeToast:@"更新失败" duration:0.5 position:CSToastPositionCenter];
                
            }

        };

}

- (BOOL)checkError:(NSDictionary *)params{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    [dic removeObjectForKey:@"revisitResult"];
    NSArray *arr = [dic allValues];
    for (NSString *str in arr) {
        if (![str length]) {
            return NO;
        }
    }
    return YES;
}

- (NSArray *)arr_type{
    return @[@{@"移动手机":@"1"},@{@"无线宽带":@"2"},@{@"固话":@"3"},@{@"宽带":@"4"},@{@"ITV":@"4.5"},@{@"光纤、电路":@"4.6"},@{@"其他":@"5"},];
}

- (NSArray *)arr_operator{
    return @[@{@"中国联通":@"20"},@{@"中国移动":@"30"},@{@"中国电信":@"40"}];

}

- (void)KeyBoardShow:(NSNotification *)notification{
    CGSize  size = [[notification userInfo][@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size;
    CGFloat offset = CGRectGetMaxY(self.zoufangResult.frame) + size.height - self.view.frame.size.height;
    if (offset > 0 ) {
        [UIView animateWithDuration:1.0f animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -offset);
        }];
    }
    
}

- (void)KeyBoardHidden:(NSNotification *)notification{
    self.view.transform = CGAffineTransformIdentity;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 127) {
        
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.tag == 127) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end
