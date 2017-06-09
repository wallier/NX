//
//  KHScrollView.h
//  WorkBench
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHGroupModel.h"
#import "KHTableViewCell.h"
#import "PersonView.h"

typedef void(^VALUECHANGE)(int);
typedef void (^SENDDiCTION)(NSDictionary *);
@interface KHScrollView : UIView<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSDictionary *dicPerson;
@property (nonatomic,strong)NSMutableArray *arrPoint;
@property (nonatomic,strong)KHGroupModel *grouModel;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong)VALUECHANGE change;
@property (nonatomic,strong)SENDDiCTION sendData;
@property (nonatomic,strong)UIView *changeView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong) PersonView *personView;
@end
