//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//
#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import "GesturePasswordController.h"
#import "LoginModel.h"
#import "KeychainItemWrapper.h"
#define DeviceTokenStringKEY @"DeviceTokenStringKEY"//注册的token

@interface GesturePasswordController ()<UIAlertViewDelegate>

@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;
@property (nonatomic,strong) LoginModel * loginModel;

@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
}

@synthesize gesturePasswordView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    previousString = [NSString string];
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([password isEqualToString:@""]) {
        [self reset];
    }
    else {
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"zhuxiao"])
            [self reset];
        else{
            [self verify];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 验证手势密码
- (void)verify{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:1];
    [gesturePasswordView setGesturePasswordDelegate:self];
    [gesturePasswordView.forgetButton setHidden:NO];
    [gesturePasswordView.changeButton setHidden:NO];
    [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
    [gesturePasswordView.state setText:@"请输入密码"];
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 重置手势密码
- (void)reset{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:2];
    [gesturePasswordView.imgView setHidden:NO];
    [gesturePasswordView.forgetButton setHidden:NO];
    [gesturePasswordView.changeButton setHidden:NO];
    [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
    [gesturePasswordView.state setText:@"请输入密码"];
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 判断是否已存在手势密码
- (BOOL)exist{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([password isEqualToString:@""])return NO;
    return YES;
}

#pragma mark - 清空记录
- (void)clear{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    [keychin resetKeychainItem];
}

#pragma mark - 改变手势密码
- (void)change{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改手势密码需要重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    
    
}

#pragma mark - 忘记手势密码
- (void)forget{
    NSLog(@"忘记");
    
}

- (BOOL)verification:(NSString *)result{
    
    if ([result length]<4) {
        [gesturePasswordView.state setTextColor:[UIColor redColor]];
        [gesturePasswordView.state setText:@"密码节点不能少于4个"];
        return NO;
    }
    if ([result isEqualToString:password]) {
        BOOL flag = NetWorkState;
        if (!flag) {
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"网络异常"];
            [gesturePasswordView.tentacleView reSetting];
            return NO;
        }
        [gesturePasswordView.state setTextColor:[UIColor greenColor]];
        
        [gesturePasswordView.state setText:@"密码正确请稍后..."] ;
        [gesturePasswordView.tentacleView reSetting];
        [gesturePasswordView setUserInteractionEnabled:NO];
        KeychainItemWrapper *keychin = [[KeychainItemWrapper alloc] initWithIdentifier:@"LOGIN_USER" accessGroup:nil];
        NSString *loginId = [keychin objectForKey:(__bridge id)kSecAttrAccount];
        
        NSString *loginPassword = [keychin objectForKey:(__bridge id)kSecValueData];
        
        KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"MPUUID" accessGroup:nil];
        
        NSString *uuid = [keyChain objectForKey:(__bridge NSString *)(kSecValueData)];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:loginId forKey:@"username"];
        [parameters setValue:loginPassword forKey:@"password"];
        [parameters setValue:uuid forKey:@"imei"];
        
        [BNNetworkTool initWitUrl:SER_LOGIN_URL andJSonParameters:parameters andParmeterName:@"param"].requestData = ^(NSDictionary * dic){
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
//            [dict removeObjectForKey:@"CALL_CODE"];
//            [dict removeObjectForKey:@"CONTRACTS_CEO"];
//            [dict removeObjectForKey:@"CONTRACTS_MAN"];
            _loginModel = [[LoginModel shareLoginModel] initWithDictionary:dict];
            if ([_loginModel.MSGCODE isEqualToString:@"200"]) {//登录成功
                
                UIViewController *root = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"tabbar"];
                [UIApplication sharedApplication].keyWindow.rootViewController = root;
                //查看应用角标是否和未读文件个数一样
                //                if ([UIApplication sharedApplication].applicationIconBadgeNumber >[[NewTool shareInstace] unreadFileCount]) {
                ////                    [[NewTool shareInstace] getDateFromNotifiction:@"accDay" Ispush:NO];
                //                }
                
                
                dispatch_async(dispatch_queue_create("sss",DISPATCH_QUEUE_CONCURRENT), ^{
                    if ([_loginModel.ORG_MANAGER_TYPE isEqualToString:@"HX"]) {
                        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
                        [params setValue:_loginModel.ORG_ID forKey:@"orgId"];
                        [params setValue:_loginModel.ORG_MANAGER_TYPE forKey:@"orgManagerType"];
                        
                        [BNNetworkTool initWitUrl:getHXData andJSonParameters:params andParmeterName:@"paramCeo"].requestData = ^(NSDictionary *dic ){
                            _loginModel = [[LoginModel shareLoginModel] initWithDictionary:dic];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"relodCellData" object:nil];
                        };
                    }
                });
            }
        };
        
        
        return YES;
        
    }
    [gesturePasswordView.state setTextColor:[UIColor redColor]];
    [gesturePasswordView.state setText:@"手势密码错误,请重新输入"];
    [gesturePasswordView.tentacleView reSetting];
    
    return NO;
}

- (void)getDataFromNocification{//登陆成功后获取接口数据
    
    //    if ([[NewTool shareInstace] unreadFileCount]<[UIApplication sharedApplication].applicationIconBadgeNumber) {
    //        [[NewTool shareInstace] getDateFromNotifiction:@"accDay" Ispush:YES];
    //    }else{
    //        //        PUSH_CONTROLLER([RAPPLICATION chomeViewControleller] , YES);
    //    }
}
- (BOOL)resetPassword:(NSString *)result{
    
    if ([result length]<4) {
        [gesturePasswordView.state setTextColor:[UIColor redColor]];
        [gesturePasswordView.state setText:@"密码节点不能少于4个"];
        return NO;
    }
    if ([previousString isEqualToString:@""]) {
        previousString=result;
        [gesturePasswordView.tentacleView enterArgin];
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [gesturePasswordView.state setText:@"请验证输入密码"];
        return YES;
    }
    else {
        if ([result isEqualToString:previousString]) {
            BOOL flag = NetWorkState;
            
            if (!flag) {
                [gesturePasswordView.state setTextColor:[UIColor redColor]];
                [gesturePasswordView.state setText:@"网络异常"];
                [gesturePasswordView.tentacleView reSetting];
                return NO;
            }
            
            
            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
            [keychin setObject:@"<帐号>" forKey:(__bridge id)kSecAttrAccount];
            [keychin setObject:result forKey:(__bridge id)kSecValueData];
            password = result;
            [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
            [gesturePasswordView.state setText:@""];
            [self.view makeToast:@"保存密码成功！" duration:1.0f position:CSToastPositionCenter];//登录成功
            {
                UIViewController *root = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"tabbar"];
                [UIApplication sharedApplication].keyWindow.rootViewController = root;
                [self removeFromParentViewController];
                
                return YES;
            }
        } else{
            previousString =@"";
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:@"两次密码不一致，请重新输入"];
            return NO;
        }
        
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self clear];
        password = @"";
        [self reset];
        KeychainItemWrapper *keychin = [[KeychainItemWrapper alloc] initWithIdentifier:@"LOGIN_USER" accessGroup:nil];
        [keychin resetKeychainItem];
        [self setModalPresentationStyle:UIModalPresentationPageSheet];
        [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginView"] animated:YES completion:nil];
        
    }
}
@end
