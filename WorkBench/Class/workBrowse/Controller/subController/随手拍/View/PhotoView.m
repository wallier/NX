//
//  PhotoView.m
//  发微博界面1
//
//  Created by xiaos on 15/11/24.
//  Copyright © 2015年 com.xsdota. All rights reserved.
//

#import "PhotoView.h"

#import "PhotoCell.h"
#import "MLSelectPhotoAssets.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define SCREES_W [UIScreen mainScreen].bounds.size.width


@interface PhotoView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

static NSString *cellId = @"photo";

@implementation PhotoView
- (void)dealloc
{
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = [NSMutableArray array];
        [self initCollectionView];
    }
    return self;
}

- (void)initCollectionView
{
    CGFloat margin = 5;
    CGFloat itemWidth = (SCREES_W - 4*margin)/3;
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    flow.itemSize = (CGSize){itemWidth,itemWidth};
    flow.minimumLineSpacing = margin;
    flow.minimumInteritemSpacing = margin;
    flow.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    self.collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectMake(0, 0, SCREES_W, itemWidth*3)
                           collectionViewLayout:flow];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    UINib *cellNib = [UINib nibWithNibName:@"PhotoCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:cellId];
    UILongPressGestureRecognizer *londPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handlelongGesture:)];
    [self.collectionView addGestureRecognizer:londPress];
    [self addSubview:self.collectionView];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    id obj = self.dataSource[indexPath.row];
    if ([obj isKindOfClass:[MLSelectPhotoAssets class]]) {
        cell.photoView.image = [obj originImage];
    }else
    {
        cell.photoView.image = obj;
    }
    
    cell.deleteBlock = ^(PhotoCell *photoCell) {
        WS;
        NSIndexPath *currentIndex = [self.collectionView indexPathForCell:photoCell];
        NSArray *indexs = @[currentIndex];
        [[weakSelf mutableArrayValueForKey:@"dataSource"] removeObjectAtIndex:currentIndex.row];
        [weakSelf.collectionView deleteItemsAtIndexPaths:indexs];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self openImageBrowserWithImageView:cell.photoView andIndex:indexPath.row];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id obj = self.dataSource[sourceIndexPath.row];
    [self.dataSource removeObjectAtIndex:sourceIndexPath.row];
    [self.dataSource insertObject:obj atIndex:destinationIndexPath.row];
}

-(void)openImageBrowserWithImageView:(UIImageView *)imgV andIndex:(NSInteger)index
{
    // UIImage -> MJPhoto
    NSMutableArray *arrM = [NSMutableArray array];
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MJPhoto *p = [[MJPhoto alloc] init];
        if ([obj isKindOfClass:[MLSelectPhotoAssets class]]) {
            p.image = [obj originImage];
        }else
        {
            p.image = obj;
        }
        p.srcImageView = imgV;
        [arrM addObject:p];
    }];
    // 弹出图片浏览器
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    brower.photos = arrM;
    brower.currentPhotoIndex = index;
    [brower show];
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:
        {/** 手势在视图上 */
            NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (selectedIndexPath == nil) {
                break;
            }
            WS;
            PhotoCell *pressCell = (PhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:selectedIndexPath];
            [UIView animateWithDuration:0.2 animations:^{
                pressCell.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                pressCell.transform = CGAffineTransformIdentity;
            }];
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {/** 手势拖到cell 更新cell位置 */
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:longGesture.view]];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {/** 手势停止 cell停止移动 */
            [self.collectionView endInteractiveMovement];
            break;
        }
        default:
        {/** 手势失效离开 取消移动 */
            [self.collectionView cancelInteractiveMovement];
        }
    }
    
}

@end
