//
//  LoginViewController.m
//  text_pch
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 com.bonc. All rights reserved.
//
#import "LoginModel.h"
#import "LoginViewController.h"
#import "KeychainItemWrapper.h"
@interface LoginViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) LoginModel *loginModel;
@property (nonatomic,assign) CGFloat offset;
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyBoardShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyBoardHidden:)
                                                  name:UIKeyboardWillHideNotification object:nil];
    _passWord.delegate = self;

    // 刘丽密码
//    _passWord.text = @"Wqt@1234";

    

//   _passWord.text = @"123456";
//    _passWord.text = @"NXDX_bonc_lzg2015";
    _userName.delegate = self;
    
//    _userName.text = @"liuli";
//    _userName.text = @"huguohua";
    

   // _passWord.text = @"123456";
    /** huguohua */
    //_passWord.text = @"123456";

    _userName.delegate = self;
//    _userName.text = @"bonc_lzg";
    
    //_userName.text = @"liuli";
//    --bonc_lzg / bonc_mal / bonc_wqt   全区
//    --fanliang   地市
//    --bonc_ych   区县
//    --bonc_rj   划小
//    --bonc_lzg5   网格 密码都是123456

    /** 全区 bonc_lzg / bonc_mal / bonc_wqt */
//    _userName.text = @"bonc_lzg";
//    /** 地市 */
//    _userName.text = @"fanliang ";
    /** 区县  */
    //_userName.text = @"bonc_ych";
//   /** 划小 */
//    _userName.text = @"bonc_rj";
//    /** 网格 */
//    _userName.text = @"bonc_lzg5";
  
//    _userName.text = @"huguohua";
   // _userName.text = @"liugang1";
   // _userName.text = @"masongjuan";
    
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showAlert];
}

- (void)KeyBoardShow:(NSNotification *)notification{
    CGSize  size = [[notification userInfo][@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size;
    CGFloat offset = CGRectGetMaxY([self.pwdView convertRect:self.passWord.frame toView:self.view]) + size.height - self.view.frame.size.height;
    if (offset > 0 ) {
        [UIView animateWithDuration:1.0f animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -offset);
        }];
    }
}

- (void)KeyBoardHidden:(NSNotification *)notification{
    self.view.transform = CGAffineTransformIdentity;
}

- (void)showAlert{
    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"我的工作温馨提示您:" message:@"hi，请通过承包助手进入此应用，更加安全、方便、快捷哦。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aler show];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_passWord resignFirstResponder];
    [_userName resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }];
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    _offset = 256 +CGRectGetMaxY(_passWord.frame) -self.view.frame.size.height;
    if (_offset > 0 ) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-_offset);
        }];
    }
    return YES;
}

- (IBAction)loginButton:(id)sender {
    
    NSString *uuid = nil;
    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MPUUID" accessGroup:nil];
    
//    /** Couldnt add the Keychain Item 崩溃 解决办法 代码 */
//    [keyChain setObject:@"Myappstring" forKey: (id)kSecAttrAccount];
    
    
    
    
    uuid = [keyChain objectForKey:(__bridge NSString *)(kSecValueData)];
    
    if (![uuid length]|| uuid == NULL) {
        uuid = [[NSUUID UUID] UUIDString];
       [keyChain setObject:@"myChainValues" forKey:(__bridge id)kSecAttrService];
       // [keyChain setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [keyChain setObject:@"uuID" forKey:(__bridge id)kSecAttrAccount];
        [keyChain setObject:uuid forKey:(__bridge NSString *)kSecValueData];
       // [keyChain setObject:(id)kSecAttrAccessibleWhenUnlocked forKey:(id)kSecAttrAccessible];
    }
    
   if (![_userName.text length] || ![_passWord.text length]){
        [self.view makeToast:@"用户名或密码为空" duration:0.5 position:CSToastPositionCenter];
        return;
    }
    self.hud = [MBProgressHUD showMessage:@"登录中..."];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_userName.text forKey:@"username"];
    [parameters setValue:_passWord.text forKey:@"password"];
    [parameters setValue:uuid forKey:@"imei"];
    
    
    [BNNetworkTool initWitUrl:SER_LOGIN_URL andJSonParameters:parameters andParmeterName:@"param"].requestData = ^(id requestDate){
        [self.hud setHidden:YES];
        NSLog(@"requestData88==%@",requestDate);
        
        [self judgeRequest:requestDate flag:YES];
    };

}

-(void)loginFromOther:(NSString *)userName andHud:(MBProgressHUD *)hud{
    
    NSDictionary *paramValue = @{@"username":userName};
    [BNNetworkTool initWitUrl:GetMainINfo andJSonParameters:paramValue andParmeterName:@"param"].requestData = ^(id requestData){
        NSLog(@"requestData===%@", requestData);
        if (!requestData) {
            [self alertTitle:hud];
        }
        [self judgeRequest:requestData flag:NO];
    };
}

- (void)alertTitle:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    [hud setHidden:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"我的工作温馨提示您"
                                                    message:@"亲，您目前没有权限访问,请OA中申请营销网格系统账号,申请后即可登录。"
                                                   delegate:self cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    
    alert.tag = 10000;
    
    [alert show];
    
    
}
/**
 *  @param flag  标记
*/

- (void)judgeRequest:(id)requestDate flag:(BOOL)flag{
    if ([requestDate[@"MSGCODE"] isEqualToString:@"200"]) {
        KeychainItemWrapper *keychin = [[KeychainItemWrapper alloc] initWithIdentifier:@"LOGIN_USER" accessGroup:nil];
        /** 造成崩溃的地方 */
        //[keychin setObject:@"SaveUserNameAndPassword" forKey:(__bridge id)kSecAttrService];
       // [keychin setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [keychin setObject:_userName.text forKey:(__bridge id)kSecAttrAccount];
        [keychin setObject:_passWord.text forKey:(__bridge id)kSecValueData];
       // [keychin setObject:(id)kSecAttrAccessibleWhenUnlocked forKey:(id)kSecAttrAccessible];

        UIViewController *ges = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"gesView"];
        [self presentViewController:ges animated:YES completion:nil];
 
        [[NSUserDefaults standardUserDefaults] setObject:requestDate[@"USER_NAME"] forKey:@"user_name"];
        [[NSUserDefaults standardUserDefaults] setObject:requestDate[@"USER_ID"] forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
//        animation.type = @"pageCurl";
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:animation forKey:nil];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:requestDate];
        self.loginModel = [[LoginModel shareLoginModel] initWithDictionary:dict];
    if (flag) {
               UIViewController *root = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"tabbar"];
        [UIApplication sharedApplication].keyWindow.rootViewController = root;
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadController" object:nil];
        }
        
    } else {
        
        [MBProgressHUD showError:@"登录失败"];
    }
    
}

#pragma mark - uialertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tydic://com.chinatelecom.ningxia.cbzs"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tydic://com.chinatelecom.ningxia.cbzs"]];
            dispatch_async(dispatch_queue_create("open", DISPATCH_QUEUE_CONCURRENT), ^{
                exit(0);
            });
        }
    }
}

@end

