//
//  BNBuildingCollectionViewCell.h
//  WorkBench
//
//  Created by wouenlone on 16/8/15.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNBuildingModel.h"

@interface BNBuildingCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *usageRateLabel;//使用率

@property (weak, nonatomic) IBOutlet UILabel *BuildingNUMLabel;
//cell显示的图片
@property (weak, nonatomic) IBOutlet UIImageView *buildingView_image;
//楼栋用途
@property (weak, nonatomic) IBOutlet UILabel *buildingPurposeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;



@end
