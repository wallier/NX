//
//  PhotoView.h
//  发微博界面1
//
//  Created by xiaos on 15/11/24.
//  Copyright © 2015年 com.xsdota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoView : UIView

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end
