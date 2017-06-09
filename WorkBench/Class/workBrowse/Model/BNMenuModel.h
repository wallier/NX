//
//  BNMenuModel.h
//  WorkBench
//
//  Created by mac on 16/1/22.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 IMG = "";
 "IS_COLLECT" = NO;
 "MENU_ID" = 1261;
 "MENU_NAME" = "\U94b1\U888b\U5b50";
 "MENU_STATUS" = 1;
 ORD = 4;
 TYPE = WEBVIEW;
 */
@interface BNMenuModel : NSObject

@property (nonatomic, strong) NSString *IMG;
@property (nonatomic, strong) NSString *IS_COLLECT;
@property (nonatomic, strong) NSString *MENU_ID;
@property (nonatomic, strong) NSString *MENU_NAME;
@property (nonatomic, strong) NSString *MENU_STATUS;
@property (nonatomic, strong) NSString *ORD;
@property (nonatomic, strong) NSString *TYPE;
@end
