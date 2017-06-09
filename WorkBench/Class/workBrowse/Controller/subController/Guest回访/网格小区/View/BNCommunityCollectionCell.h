//
//  BNCommunityCollectionCell.h
//  WorkBench
//
//  Created by wanwan on 16/8/13.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNCommunityCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *communityName;
@property (weak, nonatomic) IBOutlet UILabel *UsersQuantity;
@property (weak, nonatomic) IBOutlet UILabel *differentUsersQuantity;

//+ (instancetype)cellWithTableView:(UICollectionView *)collectionView;

@end
