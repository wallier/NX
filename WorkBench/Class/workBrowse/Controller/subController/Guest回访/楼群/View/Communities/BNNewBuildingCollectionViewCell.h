//
//  BNNewBuildingCollectionViewCell.h
//  WorkBench
//
//  Created by wouenlone on 16/8/15.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNBuildingModel.h"

@interface BNNewBuildingCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *usageRateLabel;//使用率

@property (weak, nonatomic) IBOutlet UILabel *BuildingNUMLabel;
//cell显示的图片
@property (weak, nonatomic) IBOutlet UIImageView *buildingView_image;
//楼栋用途
@property (weak, nonatomic) IBOutlet UILabel *buildingPurposeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;


@property (weak, nonatomic) IBOutlet UILabel *ResidualPortLabel;//剩余端口
@property (weak, nonatomic) IBOutlet UILabel *DXKDLabel;//电信宽带
@property (weak, nonatomic) IBOutlet UILabel *DXITVLabel;//电信ITV
@property (weak, nonatomic) IBOutlet UILabel *DXPhoneLabel;//电信手机
@property (weak, nonatomic) IBOutlet UILabel *YWKDLabel;//异网宽带
@property (weak, nonatomic) IBOutlet UILabel *YWTVLabel;//异网电视
@property (weak, nonatomic) IBOutlet UILabel *YWPhoneLabel;//异网手机



@property (weak, nonatomic) IBOutlet UILabel *SYDKLb;//剩余端口lb
@property (weak, nonatomic) IBOutlet UILabel *DXCPLb;//电信产品lb
@property (weak, nonatomic) IBOutlet UILabel *YWCPLb;//异网产品lb
@property (weak, nonatomic) IBOutlet UILabel *DXKDLb;//DX宽带
@property (weak, nonatomic) IBOutlet UILabel *DXITVLb;//DXITV
@property (weak, nonatomic) IBOutlet UILabel *DXPHLb;//DX手机
@property (weak, nonatomic) IBOutlet UILabel *YWKDLb;//YW宽带
@property (weak, nonatomic) IBOutlet UILabel *YWTVLb;//YW电视
@property (weak, nonatomic) IBOutlet UILabel *YWPhoneLb;//YW手机
@end
