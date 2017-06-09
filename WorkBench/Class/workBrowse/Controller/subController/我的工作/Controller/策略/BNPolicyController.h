//
//  BNPolicyController.h
//  WorkBench
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNPolicyController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrPolcy;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, assign) int flagHXWG;
@property (nonatomic, assign) int cplus;

@property (nonatomic, assign)NSMutableDictionary *paramsPlus;

@property (nonatomic,strong) NSIndexPath * PolicyIndexPath;

@property (nonatomic, assign) BOOL isDevelopFlag;

- (void)setSanFlag:(NSString *)sanFlag andPolicy:(NSString *)policy;
@end
