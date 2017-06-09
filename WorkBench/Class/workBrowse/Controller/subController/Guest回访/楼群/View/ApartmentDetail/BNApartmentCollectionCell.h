//
//  BNApartmentCollectionCell.h
//  WorkBench
//
//  Created by wanwan on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNApartmentCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *userAccount;
@property (weak, nonatomic) IBOutlet UILabel *apartmentNumLabel;
// 传collectionView，返回collectionCell
//+ (instancetype)collectionCellWithCollection:(UICollectionView *)collectionView;
@end
