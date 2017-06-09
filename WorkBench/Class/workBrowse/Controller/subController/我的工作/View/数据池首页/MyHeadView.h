//
//  MyHeadView.h
//  BIBuilderApp
//
//  Created by mac on 15/6/26.
//  Copyright (c) 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^getMore)(void);
@interface MyHeadView : UICollectionReusableView
@property (nonatomic,strong) UILabel *lab;
@property (nonatomic,strong) getMore getmore;

@end
