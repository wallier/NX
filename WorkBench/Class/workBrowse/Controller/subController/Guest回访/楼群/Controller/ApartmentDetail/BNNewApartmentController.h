//
//  BNNewApartmentController.h
//  WorkBench
//
//  Created by wanwan on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNNewApartmentController : UIViewController
/** 小区编号 */
@property (nonatomic, strong) NSString *region_id;
/** 楼号 */
@property (nonatomic, strong) NSString *building_no;
/** 小区名字*/
@property (nonatomic, strong) NSString *regionName;
@end
