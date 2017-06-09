//
//  BNOneTimeIncreseProductViewController.h
//  WorkBench
//
//  Created by wanwan on 16/9/23.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNOneTimeIncreseProductViewController : UIViewController
// 第一个跳转传url
@property (nonatomic, strong) NSString *all_WG_URL;
// 第二个跳转传网格名字allCommunityURL
@property (nonatomic, strong) NSString *wg_name;
// 第二个跳转传网格名字allCommunityURL
@property (nonatomic, strong) NSString *allCommunityURL;
// 网格id
@property (nonatomic, strong) NSString *wg_id;
// 小区id
@property (nonatomic, strong) NSString *region_id;
// 楼号 buildingNo
@property (nonatomic, strong) NSString *building_no;
// 楼类型 building_type
@property (nonatomic, strong) NSString *building_type;
// 单元数
@property (nonatomic, strong) NSString *unit_Num;
// 记录选取的单元编号
@property (nonatomic, strong) NSString *unit_no;
@end
