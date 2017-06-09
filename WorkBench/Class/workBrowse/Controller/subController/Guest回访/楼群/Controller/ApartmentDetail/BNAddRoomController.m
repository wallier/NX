//
//  BNAddRoomController.m
//  WorkBench
//
//  Created by wanwan on 16/9/8.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNAddRoomController.h"
#import <AFNetworking.h>
#import "LoginModel.h"
#import "MBProgressHUD+Extend.h"
#import "BNWaterMark.h"

@interface BNAddRoomController ()
// 楼层数textField
@property (nonatomic, strong) UITextField *textFieldRoom;
@end

@implementation BNAddRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 水印背景
    UIImage *img = [BNWaterMark getwatermarkImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    
    // 室号
    _textFieldRoom = [self createCellViewCGRectMakeX:0 andY:0 andW:self.view.bounds.size.width andH:60 andLabel1Content:@"室号:" andLabel2Content:@" 室" andTextFieldPlaceHolder:@"请输入室号"];
    
    // 保存按钮
   // UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W/2-50, 70, 100, 40)];
   // [button setFrame:CGRectMake(SCREEN_W/2-50, 70, 100, 40)];
    [button setBackgroundColor:RGB(255, 146, 50)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    
    // 设置button的边框颜色和圆角
    CALayer *searchButtonLayer = [button layer];
    [searchButtonLayer setMasksToBounds:YES];
    [searchButtonLayer setCornerRadius:5];
    [searchButtonLayer setBorderWidth:1.0];
    [searchButtonLayer setBorderColor:RGB(255, 143, 12).CGColor];
    
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];

}

- (UITextField*)createCellViewCGRectMakeX:(CGFloat)viewX andY:(CGFloat)viewY andW:(CGFloat)viewW andH:(CGFloat)viewH andLabel1Content:(NSString*)label1Content andLabel2Content:(NSString*)label2Content andTextFieldPlaceHolder:(NSString*)textFieldPlaceHolder{
    // view作为背景
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    cellView.backgroundColor = [UIColor whiteColor];
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, cellView.bounds.size.width , 0.5)];
    lineview.backgroundColor = RGB(255, 146, 50);
    [cellView addSubview:lineview];
    [self.view addSubview:cellView];
    
    // 自定义控件
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/4, 60)];
    label1.text= label1Content;
    //label1.font = [UIFont boldSystemFontOfSize:60.f];
    label1.font = [UIFont systemFontOfSize:16];
    label1.textAlignment = NSTextAlignmentCenter;
    [cellView addSubview:label1];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(cellView.bounds.size.width/4, 10, cellView.bounds.size.width/2, 40)];
    // 设置tag
    [textField setTag:40000+viewY ];
    textField.placeholder = textFieldPlaceHolder;
    textField.font = [UIFont systemFontOfSize:13];
    textField.backgroundColor = [UIColor whiteColor];
    // 边框颜色
    textField.layer.borderWidth = 2.0f;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    // 注册通知观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldBeginAction:) name: UITextFieldTextDidBeginEditingNotification object:textField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEndAction:) name: UITextFieldTextDidEndEditingNotification object:textField];
    
    // 设置textField中初始光标
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways ;
    // 只能输数字
    textField.keyboardType=UIKeyboardTypeNumberPad;

    [cellView addSubview:textField];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*3/4, 0, self.view.bounds.size.width/4, 60)];
    label2.text= label2Content;
    label2.font = [UIFont systemFontOfSize:16];
    label2.textAlignment = NSTextAlignmentLeft;
    [cellView addSubview:label2];
    
    return textField;
}

- (void)textFieldBeginAction:(NSNotification*)didbegin {
    UITextField *textField = didbegin.object;
    textField.layer.borderWidth = 2.0f;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = RGB(255, 146, 50).CGColor;
    
}

- (void)textFieldEndAction:(NSNotification*)notifiction {
    UITextField *textField = notifiction.object;
    [textField endEditing:YES];
}
#pragma mark 网络请求相关方法

- (void)addHouseRequest
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"UNIT_NO":self.UNIT_NO,@"ROOT_NO":self.textFieldRoom.text,@"MODIFIED_BY":[LoginModel shareLoginModel].USER_NAME,@"BUILDING_ID":self.BUILDING_ID};
    NSLog(@"ADD_ONEHOUSE:params-%@",params);
    WS
    [manager POST:ADD_ONEHOUSE parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
            [MBProgressHUD showError:@"系统异常"];
        }else if ([responseObject[@"MSGCODE"] isEqualToString:@"600"]){
            [MBProgressHUD showError:@"插入失败"];
        }else{
            [MBProgressHUD showSuccess:@"插入成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络错误"];
    }];
}


// 提交到服务器
- (void)buttonClick {
    [_textFieldRoom endEditing:YES];
    [self addHouseRequest];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textFieldRoom endEditing:YES];


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
