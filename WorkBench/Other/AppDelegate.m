//
//  AppDelegate.m
//  WorkBench
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "AppDelegate.h"
#import "KeychainItemWrapper.h"
#import "SBJson.h"
#import <AFNetworking.h>
#import <UserNotifications/UserNotifications.h>

#define AppUrl @"com.bonc.Workbench://com.bonc.ContractManager.TELECOM.NX"//启动项
//#define Check_Token @"http://61.133.213.199/mpi/m/sys/ticketValid" //获取票据接口
#define Check_Token @"http://61.133.213.199:9488/mpi/m/sys/ticketValid" //获取票据接口

#define DeviceTokenStringKEY @"DeviceTokenStringKEY"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
       [self resignNetWorkstate];
    
    NSURL *Url = [launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if (Url) {
        return YES;
    }
    
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    NSString *pwd = [keychin objectForKey:(__bridge id)kSecValueData];
    UIViewController *vc = nil;
    if ([pwd length]) {
        
        vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle  ]] instantiateViewControllerWithIdentifier:@"gesView"];
        self.window.rootViewController = vc;
    }
    
    // 注册通知（本地和远程）
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionCarPlay | UNAuthorizationOptionSound | UNAuthorizationOptionBadge | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted) {
                NSLog(@" iOS 10 request notification success");
            }else{
                NSLog(@" iOS 10 request notification fail");
            }
        }];
    }else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0){
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:setting];
    
    
    }else{
        UIRemoteNotificationType type = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:type];
    }
    //注册通知
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    return YES;
}
//APP在前台的时候收到推送的回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    UNNotificationContent *content =  notification.request.content;
    NSDictionary *userInfo = content.userInfo;
    
    [self handleRemoteNotificationContent:userInfo];
    
    //可以执行设置 弹窗 和 声音
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);

}
//APP在后台，点击推送信息，进入APP后执行的回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    UNNotificationContent *content  = response.notification.request.content;
    NSDictionary *userInfo = content.userInfo;
    
    [self handleRemoteNotificationContent:userInfo];
    
    completionHandler();

}

- (void)handleRemoteNotificationContent:(NSDictionary *)userInfo
{
    NSLog(@" iOS 10 after Notificatoin message:\n %@",userInfo);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // dafcc2f7 be68cede 5da5afc5 238ad3e4 405f1a4f 9090b221 cf468b0c 98634e0d
    NSLog(@"--deviceToken--%@",deviceToken.description);


}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if (url) {
        if ([[url absoluteString] hasPrefix:AppUrl]) {
            NSString *newUrl = [url.absoluteString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@?",url] withString:@""];
            [self MenAutor:newUrl];
        }
        UIViewController *root = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"tabbar"];
        self.window.rootViewController = root;
        
        return YES;
        
    }else{
        return NO;
    }
}

//获取token
- (void)MenAutor:(NSString *)token{
    
    token =[self decodeFormPercentEscapeString:token];
    __block SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dict = [parser objectWithString:[token componentsSeparatedByString:@"?"][1]];
    NSString *ticket = dict[@"token"];
    [[NSUserDefaults standardUserDefaults] setValue:ticket forKey:@"ticket"];
}

//token解密
-(NSString *)decodeFormPercentEscapeString:(NSString*)input{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)resignNetWorkstate{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:
     ^(AFNetworkReachabilityStatus status) {
         //网络断开
         if (status == AFNetworkReachabilityStatusUnknown ||
             status == AFNetworkReachabilityStatusNotReachable) {
             [[UIApplication sharedApplication].keyWindow makeToast:@"您的网络已经断开"
                                                           duration:0.5 position:CSToastPositionCenter];
             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"netWorkState"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
         } else {
             [[UIApplication sharedApplication].keyWindow makeToast:@"您的网络处于正常状态"
                                                           duration:0.5 position:CSToastPositionCenter];
             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"netWorkState"];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
     }];
    
}


@end
