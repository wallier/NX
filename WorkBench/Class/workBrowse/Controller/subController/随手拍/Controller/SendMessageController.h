//
//  SendMessageController.h
//  WorkBench
//
//  Created by xiaos on 15/12/1.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMessageController : UIViewController

/** 初始化评论控制器 */
- (instancetype)initCommentViewControllerWithOpId:(NSString *)Id
                                      commentsStr:(NSString *)str
                                      commentsNum:(NSString *)num;


@end
