//
//  ResultCell.h
//  WorkBench
//
//  Created by xiaos on 15/12/3.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResultViewModel,CommentView,ResultCell;
@protocol ResultCellDelegate <NSObject>

/** 点赞 */
- (void)resultCell:(ResultCell *)cell
  praisesOpinionId:(NSString *)opId
          userName:(NSString *)name
        praisesNum:(NSString *)praisesNum;

/** 回复 */
- (void)resultCell:(ResultCell *)cell
  commentOpinionId:(NSString *)opId
          commentStr:(NSString *)commentStr
        commentNumStr:(NSString *)commentNumStr;

@end

@interface ResultCell : UITableViewCell

@property (nonatomic,strong) ResultViewModel *viewModel;

@property (nonatomic,weak) id<ResultCellDelegate> delegate;

@end
