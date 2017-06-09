//
//  TakePhotoViewController.m
//  WorkBench
//
//  Created by xiaos on 15/12/01.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "SendMessageController.h"

#import "NavView.h"
#import "ResultCell.h"

#import "ResultViewModel.h"
#import "ResultModel.h"

#import "AFNetworking.h"
#import "MJExtension.h"
#import "MBProgressHUD+Extend.h"
#import "MJRefresh.h"
#import "SDImageCache.h"
#import <MJRefresh.h>

//刷新类型 刷新整个tableView 刷新单个cell
typedef NS_ENUM(NSInteger,ReloadType) {
    ReloadTypeTableView,
    ReloadTypeCellView
};

@interface TakePhotoViewController ()<UITableViewDataSource,UITableViewDelegate,ResultCellDelegate>

@property (nonatomic,strong) NavView     *naviView;     ///< 导航视图
@property (nonatomic,strong) UITableView *tableView;    ///< 表视图
@property (nonatomic,strong) NSArray     *viewModels;   ///< 数据源

@end

static NSString *reuseId = @"homeCell";

@implementation TakePhotoViewController{
    NSIndexPath *_needUpdateCellIndexPath;  ///< 需要刷新的cell的标识
    NSUInteger  _cleanCacheTime;            ///< 循环cell时清除图片缓存的阀值
}

#pragma mark - 生命周期
- (void)dealloc
{
    NSLog(@"takephotot销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
    [self initNavi];
    [self initTableView];
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self makeAutoLayout];
}

#pragma mark - 添加通知
- (void)addNotification {
    //SendMessageController界面发送完消息会发出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"sendMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCellUI) name:@"sendComment" object:nil];

}

#pragma mark - 网络请求
- (void)loadDataForViewType:(ReloadType)type {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    NSString *latestAPI = SERVER_HOMES@"/publish/release";
    WS
    [mgr GET:latestAPI parameters:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
         
         [weakSelf handleSuccessData:responseObject];
         
         switch (type) {
             case ReloadTypeTableView:
                 [weakSelf.tableView reloadData];
                 break;
             case ReloadTypeCellView:
                 [weakSelf.tableView
                  reloadRowsAtIndexPaths:@[_needUpdateCellIndexPath]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
                 break;
         }
         
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf handleFailureData];
    }];
}

#pragma mark 处理成功请求
- (void)handleSuccessData:(id )responseObject {
    [self.tableView.header endRefreshing];
    NSArray *results = [ResultModel objectArrayWithKeyValuesArray:responseObject[@"RESULT"]];
    NSMutableArray *tempArr = [NSMutableArray array];
    [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ResultViewModel *viewModel = [ResultViewModel new];
        viewModel.result = obj;
        [tempArr addObject:viewModel];
    }];
    self.viewModels = tempArr;
}

#pragma mark 处理失败请求
- (void)handleFailureData {
    [self.tableView.header endRefreshing];
    [MBProgressHUD showError:@"请检查网络连接"];
}

#pragma mark 延时刷新界面 获取最新动态
- (void)updateUI {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadDataForViewType:ReloadTypeTableView];
    });
}

#pragma mark  刷新单个cell实现点赞和回复的同步
- (void)updateCellUI {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadDataForViewType:ReloadTypeCellView];
    });
}

#pragma mark - 实现代理 UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    ResultViewModel *viewModel = self.viewModels[indexPath.row];
    cell.viewModel = viewModel;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewModels[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{/** 每循环20个cell就对图片内存清理 防止图片过多占用内存*/
    _cleanCacheTime++;
    if (_cleanCacheTime % 20 == 0) {
        [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    }
}

#pragma mark  ResultCellDelegate
/** 在cell中点赞 */
- (void)resultCell:(ResultCell *)cell
  praisesOpinionId:(NSString *)opId
          userName:(NSString *)name
        praisesNum:(NSString *)praisesNum {
    NSDictionary *paramDict = @{@"opinion_id":opId,
                                @"praises":name,
                                @"praises_num":praisesNum
                                };
    
    WS
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:SERVER_HOMES@"/publish/praise" parameters:paramDict success:^(NSURLSessionDataTask *task, id responseObject) {
        _needUpdateCellIndexPath = [weakSelf.tableView indexPathForCell:cell];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateCellUI];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:@"点赞失败"];
    }];
}
/** 在cell中回复 */
- (void)resultCell:(ResultCell *)cell
  commentOpinionId:(NSString *)opId
        commentStr:(NSString *)commentStr
     commentNumStr:(NSString *)commentNumStr {
    _needUpdateCellIndexPath = [self.tableView indexPathForCell:cell];
    SendMessageController *vc = [[SendMessageController alloc]initCommentViewControllerWithOpId:opId
                              commentsStr:commentStr
                              commentsNum:commentNumStr];
        [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 初始化子控件
- (void)initNavi {
    NavView *navi = [NavView new];
    [self.view addSubview:navi];
    self.naviView = navi;
    navi.title = @"随手拍";
    navi.rightImage = [UIImage imageNamed:@"TakePhotocamrea"];
    
    WS
    navi.Pop = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    navi.rightAction = ^{
        SendMessageController *vc = [SendMessageController new];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    };
}

- (void)initTableView {
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[ResultCell class] forCellReuseIdentifier:reuseId];
    WS
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataForViewType:ReloadTypeTableView];

    }];
}

#pragma mark - 自动布局
- (void)makeAutoLayout {
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - lazy
- (NSArray *)viewModels {
    if (!_viewModels) {
        _viewModels = [NSArray array];
    }
    return _viewModels;
}

@end
