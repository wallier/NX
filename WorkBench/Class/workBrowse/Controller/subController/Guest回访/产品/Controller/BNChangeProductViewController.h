//
//  BNAddAndChangeBaseViewController.h
//  WorkBench
//
//  Created by wouenlone on 16/8/18.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNProductModel.h"

@interface BNChangeProductViewController : UIViewController
//传入头部视图的地址和本商品的信息
- (instancetype)initWithHouseAddress:(NSString *)address andProductId:(NSString *)productId;

@end
