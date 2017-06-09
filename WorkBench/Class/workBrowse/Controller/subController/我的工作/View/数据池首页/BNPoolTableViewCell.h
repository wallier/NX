//
//  BNPoolTableViewCell.h
//  WorkBench
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

@protocol BNPoolTableViewCellDelegate <NSObject>
@optional
#pragma mark - 获取三心条目工单
- (void)finishedClick:(NSString *)typeFlag andServiceType:(NSString *)serviceType;

#pragma mark - 获取三心工单
- (void)finishedClickGetAllOrder:(NSString *)serviceType;

#pragma mark - 获取发展工单
- (void)finishedClickGetDevelopOrder:(NSString *)serviceType;

@end

#import <UIKit/UIKit.h>
#import "BNPoolItemModel.h"
@interface BNPoolTableViewCell : UITableViewCell
@property (nonatomic, strong) BNPoolItemModel *model;
@property (nonatomic, assign) id <BNPoolTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *img;  ///<图片
@property (weak, nonatomic) IBOutlet UIButton *deveBtn; ///<发展机会
@property (weak, nonatomic) IBOutlet UILabel *type; ///<类型 移动宽带Itv
@property (weak, nonatomic) IBOutlet UILabel *typeNum;  ///<类型数量


- (IBAction)getAllOrder:(id)sender;
- (IBAction)getDevelopOrder:(id)sender;


#pragma mark - 操心
@property (weak, nonatomic) IBOutlet UILabel *lab_cx;
@property (weak, nonatomic) IBOutlet UILabel *cx_per;
- (IBAction)getCxOrder:(id)sender;

#pragma mark - 关心
@property (weak, nonatomic) IBOutlet UILabel *lab_gx;
@property (weak, nonatomic) IBOutlet UILabel *gx_per;
- (IBAction)getGxOrider:(id)sender;

#pragma mark - 放心
@property (weak, nonatomic) IBOutlet UILabel *lab_fx;
@property (weak, nonatomic) IBOutlet UILabel *fx_per;
- (IBAction)getFxOrder:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lab_oderNum;


@end
