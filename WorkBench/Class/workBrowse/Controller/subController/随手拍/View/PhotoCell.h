//
//  PhotoCell.h
//  发微博界面1
//
//  Created by xiaos on 15/11/23.
//  Copyright © 2015年 com.xsdota. All rights reserved.
//
#import <UIKit/UIKit.h>

@class PhotoCell;
typedef void(^PhotoCellCallBack)(PhotoCell *);

@interface PhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (nonatomic,copy) PhotoCellCallBack deleteBlock;

@end
