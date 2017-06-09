//
//  BNBuildingModel.m
//  WorkBench
//
//  Created by wouenlone on 16/8/14.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#import "BNBuildingModel.h"

@implementation BNBuildingModel

+(NSArray *)getAllBuildingInCommunityWithArray:(NSArray *)array;
{
    if (array.count == 0) {
        NSLog(@"需解析数组为空");
    }else{
        NSMutableArray *arr = [NSMutableArray array];
        
            for (NSDictionary *dic in array) {
                
                BNBuildingModel *model = [[BNBuildingModel alloc]init];
                model.PORT_ALL_NUM = dic[@"PORT_ALL_NUM"];
                 model.PORT_OCCUPY_NUM = dic[@"PORT_OCCUPY_NUM"];
                 model.USE_PERSENT = dic[@"USE_PERSENT"];
                 model.BUILDING_NO = dic[@"BUILDING_NO"];
                 model.BUILDING_ID = dic[@"BUILDING_ID"];
                model.OTHER_WLAN_NUM = dic[@"OTHER_WLAN_NUM"];
                model.BUILDING_TYPE = dic[@"BUILDING_TYPE"];

                model.PORT_LAST_NUM = dic[@"PORT_LAST_NUM"];
                model.ALL_ROOM_NUM = dic[@"ALL_ROOM_NUM"];
                model.SELF_WLAN_KD = dic[@"SELF_WLAN_KD"];
                model.SELF_WLAN_ITV = dic[@"SELF_WLAN_ITV"];
                model.SELF_WLAN_SJ = dic[@"SELF_WLAN_SJ"];
                model.OTHER_WLAN_KD = dic[@"OTHER_WLAN_KD"];
                model.OTHER_WLAN_ITV = dic[@"OTHER_WLAN_ITV"];
                model.OTHER_WLAN_SJ = dic[@"OTHER_WLAN_SJ"];
                [arr addObject:model];
            }
        
        return [arr copy];
    }
    return nil;
}
@end
