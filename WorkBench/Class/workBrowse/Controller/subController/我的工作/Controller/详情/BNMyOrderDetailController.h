//
//  BNOrderDetailController.h
//  WorkBench
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BNOrderDetailModel.h"

@interface BNMyOrderDetailController : UIViewController
@property (nonatomic, strong) NSMutableArray *arrModel;
@property (nonatomic, strong) NSMutableArray *myarrModel;
@property (nonatomic, assign) int maxCout;
@property (nonatomic, assign) int mymaxCout;
@property (nonatomic, assign) int flagLR;
@property (nonatomic, assign) int publicNum;
@property (nonatomic, assign) int cplus;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UILabel *titleLabLeft;
@property (nonatomic, strong) UILabel *titleLabLeftWarning;
@property (nonatomic, strong) UILabel *titleLabRight;
@property (nonatomic, strong) UIView *buttonLab;
@property (nonatomic, strong) UIButton* btnConfirm;
@property (nonatomic, strong) UIButton* btnReset;
@property (nonatomic, strong) UIButton* btnKillOrder;
@property (nonatomic, strong) UIImageView* timeImg;
@property (nonatomic, strong) UIImageView* rightImg;
@property (nonatomic, strong) UIImageView* circleImg;
@property (nonatomic, strong) UIImageView* doorImg;
@property (nonatomic, strong) UIButton* btnStatus;
@property (nonatomic, strong) UIButton* rightBtn;
@property (nonatomic, strong) UIButton* selectBtn;

@property (nonatomic, assign) BOOL fullStatus;
@property (nonatomic, assign) BOOL isReset;

@property (nonatomic, strong) BNOrderDetailModel *myCellmodel;

@property (nonatomic, strong) MBProgressHUD *hud;





- (void)setNavLeftTitle:(NSString *)title;
@end
