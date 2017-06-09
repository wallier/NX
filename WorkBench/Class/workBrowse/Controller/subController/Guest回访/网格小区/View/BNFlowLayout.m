//
//  BNFlowLayout.m
//  WorkBench
//
//  Created by wanwan on 16/8/13.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNFlowLayout.h"

@implementation BNFlowLayout
-(instancetype)init {
    if (self = [super init]) {
        //设置每项的大小
        self.itemSize = CGSizeMake(SCREEN_W/3-8, 140);
//        //设置每行间隔大小
        self.minimumLineSpacing = 0;
//        //设置每项的间隔
        self.minimumInteritemSpacing = 0;
//        //设置 四边的间隔
//        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        //设置滑动方向 为 水平方向
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0.0f;
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
@end
