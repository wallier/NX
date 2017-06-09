//
//  SendInfo.h
//  发微博界面1
//
//  Created by xiaos on 15/11/24.
//  Copyright © 2015年 com.xsdota. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendInfo : NSObject

/**
 这个接口有7个参数，分别为：user_id, user_name, opinion_title, image_names, image_num, publish_time, phone_brand 这7个参数都是String类型，其含义参照下图：
 */
@property (nonatomic,copy) NSString *user_id;           ///< 用户id
@property (nonatomic,copy) NSString *user_name;         ///< 用户姓名
@property (nonatomic,copy) NSString *opinion_title;     ///< 正文
@property (nonatomic,copy) NSString *image_names;       ///< 图片名称 多图名称用逗号隔开
@property (nonatomic,copy) NSString *image_num;         ///< 图片数量
@property (nonatomic,copy) NSString *publish_time;      ///< 发布时间
@property (nonatomic,copy) NSString *phone_brand;       ///< 手机品牌

@property (nonatomic,strong) NSArray *photos;   ///< 图片
@property (nonatomic,strong) NSArray *imageNameArr;

@end
