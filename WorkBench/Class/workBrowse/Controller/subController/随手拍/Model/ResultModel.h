//
//  ResultModel.h
//  WorkBench
//
//  Created by xiaos on 15/12/3.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResultModel : NSObject

@property (nonatomic,copy) NSString *IMAGE_NUM;     ///< 图片数量
@property (nonatomic,copy) NSString *COMMENTS;      ///< 评论
@property (nonatomic,copy) NSString *IMAGE_NAMES;   ///< 图片名字以逗号分割
@property (nonatomic,copy) NSString *PHONE_BRAND;   ///< 手机品牌
@property (nonatomic,copy) NSString *PRAISES;       ///< 点赞的全部名称
@property (nonatomic,copy) NSString *OPINION_ID;    ///< 内容唯一id
@property (nonatomic,copy) NSString *COMMENTS_NUM;  ///< 评论数量
@property (nonatomic,copy) NSString *OPINION_TITLE; ///< 内容正文
@property (nonatomic,copy) NSString *PUBLISH_TIME;  ///< 发布时间
@property (nonatomic,copy) NSString *PRAISES_NUM;   ///< 点赞数量
@property (nonatomic,copy) NSString *USER_ID;       ///< 用户id
@property (nonatomic,copy) NSString *USER_NAME;     ///< 用户名称

@end
