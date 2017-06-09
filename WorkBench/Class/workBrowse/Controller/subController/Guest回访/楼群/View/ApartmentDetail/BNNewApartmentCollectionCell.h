//
//  BNNewApartmentCollectionCell.h
//  WorkBench
//
//  Created by wanwan on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNNewApartmentCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *userAccount;
@property (weak, nonatomic) IBOutlet UILabel *apartmentNumLabel;



@property (weak, nonatomic) IBOutlet UILabel *circle00;
@property (weak, nonatomic) IBOutlet UILabel *circle01;
@property (weak, nonatomic) IBOutlet UILabel *circle02;
@property (weak, nonatomic) IBOutlet UILabel *circle03;
@property (weak, nonatomic) IBOutlet UILabel *circle04;


@property (weak, nonatomic) IBOutlet UILabel *circle10;
@property (weak, nonatomic) IBOutlet UILabel *circle11;
@property (weak, nonatomic) IBOutlet UILabel *circle12;
@property (weak, nonatomic) IBOutlet UILabel *circle13;
@property (weak, nonatomic) IBOutlet UILabel *circle14;


@property (weak, nonatomic) IBOutlet UILabel *circle20;
@property (weak, nonatomic) IBOutlet UILabel *circle21;
@property (weak, nonatomic) IBOutlet UILabel *circle22;
@property (weak, nonatomic) IBOutlet UILabel *circle23;
@property (weak, nonatomic) IBOutlet UILabel *circle24;
// 传collectionView，返回collectionCell
//+ (instancetype)collectionCellWithCollection:(UICollectionView *)collectionView;
@end
