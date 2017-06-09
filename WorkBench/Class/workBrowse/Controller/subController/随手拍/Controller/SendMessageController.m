//
//  SendMessageController.m
//  WorkBench
//
//  Created by xiaos on 15/12/1.
//  Copyright © 2015年 com.bonc. All rights reserved.
//

#import "SendMessageController.h"
#import "MLSelectPhotoPickerViewController.h"

#import "NavView.h"
#import "XSTextView.h"
#import "PhotoView.h"

#import "SendInfo.h"

#import "UIButton+XSButton.h"
#import "NSString+CGSize.h"

#import "AFNetworking.h"
//#import "MJExtension.h"
#import "MBProgressHUD+Extend.h"


static const NSUInteger maxTextCount = 140;               ///< 最大字数限制

@interface SendMessageController ()<UITextViewDelegate>
@property (nonatomic,weak) NavView    *naviView;                ///< 导航条
@property (nonatomic,weak) XSTextView *textView;                ///< 文字输入框
@property (nonatomic,weak) UIButton   *addImageButton;          ///< 添加图片按钮
@property (nonatomic,weak) UILabel    *textCountLabel;          ///< 文字计数器
@property (nonatomic,weak) PhotoView  *photoView;               ///< 图片视图

/** 评论视图的复用 */
@property (nonatomic,assign) BOOL isCommentVC;
@property (nonatomic,copy) NSString *opId;
@property (nonatomic,copy) NSString *commentsStr;
@property (nonatomic,copy) NSString *commentsNum;

@end

@implementation SendMessageController

/** 评论视图的复用 */
- (instancetype)initCommentViewControllerWithOpId:(NSString *)Id
                                      commentsStr:(NSString *)str
                                      commentsNum:(NSString *)num {
    if (self = [super init]) {
        self.isCommentVC = YES;
        self.opId = Id;
        self.commentsStr = str;
        self.commentsNum = num;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"sendphotot销毁");
    [self.photoView removeObserver:self forKeyPath:@"dataSource"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNaviView];
    [self initTextView];
    [self initAddImageButton];
    [self initTextCountLabel];
    [self initPhotoView];
    
    if (self.isCommentVC) {
        self.addImageButton.hidden = YES;
        self.photoView.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self makeAutoLayout];
}


#pragma mark - 事件和响应
- (void)addImageButtonTapped
{
    MLSelectPhotoPickerViewController *pickerVC = [MLSelectPhotoPickerViewController new];
    pickerVC.status = PickerViewShowStatusCameraRoll;
    pickerVC.topShowPhotoPicker = YES;
    pickerVC.maxCount = 9;
    pickerVC.selectPickers = self.photoView.dataSource;
    WS;
    pickerVC.callBack = ^(NSArray *assets){
        [weakSelf.photoView.dataSource removeAllObjects];
        [[weakSelf.photoView mutableArrayValueForKey:@"dataSource"] addObjectsFromArray:assets];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.photoView.collectionView reloadData];
        });
    };
    [self presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark 改变发布按钮状态
/** 图片数据源发生改变时调用 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"dataSource"] && object == self.photoView) {
        [self changeSendButtonState];
    }
}

- (void)changeSendButtonState {
    NSUInteger imageCount = self.photoView.dataSource.count;
    NSUInteger textCount = [NSString convertToInt:self.textView.text];
    
    UIButton *sendButton = [self.naviView rightButton];
    if (imageCount) {//有图片
        sendButton.enabled = YES;
        self.addImageButton.enabled = imageCount <= 9? YES: NO;
    }else if (self.textView.hasText){//有文字
        sendButton.enabled = textCount <= maxTextCount ?YES : NO;
    }else {//文字图片都没有
        sendButton.enabled = NO;
    }
}

#pragma mark 改变文字计数器状态
- (void)changeTextCountLabelState {
    NSUInteger textCount = [NSString convertToInt:self.textView.text];
    if (textCount <= maxTextCount) {
        self.textCountLabel.text = [NSString stringWithFormat:@"%lu",(long)(maxTextCount - textCount)];
        self.textCountLabel.textColor = RGB(90, 192, 44);
    }else {
        self.textCountLabel.text = [NSString stringWithFormat:@"-%lu",(long)(textCount - maxTextCount)];
        self.textCountLabel.textColor = [UIColor redColor];
    }
}

#pragma mark - 代理实现
#pragma - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self changeSendButtonState];      //监控textView的变化 改变发送按钮和计数label
    [self changeTextCountLabelState];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];         //滑动视图就取消编辑
}

#pragma mark - 网络请求
- (void)sendInfo
{
    if (self.isCommentVC) {//是评论界面
        [self sendComment];
    }else {//是发布界面
        BOOL hasPhotoAndText     = self.photoView.dataSource.count && self.textView.hasText;
        BOOL hasPhotoWithoutText = self.photoView.dataSource.count && !self.textView.hasText;
        
        SendInfo *sendInfo = [SendInfo new];
        if (hasPhotoAndText) {//有图有文字
            sendInfo.opinion_title = self.textView.text;
            sendInfo.photos        = self.photoView.dataSource;
            
        }else if (hasPhotoWithoutText) {//有图没文字
            sendInfo.opinion_title = @"分享图片";
            sendInfo.photos        = self.photoView.dataSource;
            
        }else {//只有文字
            sendInfo.opinion_title = self.textView.text;
            sendInfo.photos        = nil;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (sendInfo.photos) {//发送图片数据
                [self sendImageDataWithSendInfo:sendInfo];
            }else {//发送文字
                [self sendTextDataWithSendInfo:sendInfo];
            }
        });
        
    }
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 发送评论数据
- (void)sendComment {
    NSString *commentStr = [NSString
                            stringWithFormat:@"%@%@",self.commentsStr,self.textView.text];
    NSDictionary *paramDict = @{@"opinion_id":self.opId,
                                @"comments":commentStr,
                                @"comments_num":self.commentsNum
                                };
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:SERVER_HOMES@"/publish/comment"
   parameters:paramDict
      success:^(NSURLSessionDataTask *task, id responseObject) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"sendComment" object:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:@"评论失败"];
    }];
}

#pragma mark 发送图片数据
- (void)sendImageDataWithSendInfo:(SendInfo *)sendInfo {
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *sendImageAPI = SERVER_HOMES@"/publish/upload";

    NSArray *imagesDataArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"imagesDataArr"];
    if (!imagesDataArr) {
        [MBProgressHUD showError:@"图片上传失败"];
        return;
    }
    
    [mgr POST:sendImageAPI parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [sendInfo.imageNameArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:imagesDataArr[idx] name:@"upload" fileName:obj  mimeType:@"image/jpeg"];
        }];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        NSString *sendAPI = SERVER_HOMES@"/publish/opinion";
        [mgr POST:sendAPI
       parameters:sendInfo.keyValues
          success:^(NSURLSessionDataTask *task, id responseObject) {
              [MBProgressHUD showSuccess:@"发布成功"];
              [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMessage" object:nil];
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              [MBProgressHUD showError:@"发布失败"];
          }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:@"发布失败"];
    }];

}

#pragma mark 发送文字数据
- (void)sendTextDataWithSendInfo:(SendInfo *)sendInfo {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSString *sendAPI = SERVER_HOMES@"/publish/opinion";
    [mgr POST:sendAPI
   parameters:sendInfo.keyValues
      success:^(NSURLSessionDataTask *task, id responseObject) {
          [MBProgressHUD showSuccess:@"发布成功"];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMessage" object:nil];
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          [MBProgressHUD showError:@"发布失败"];
      }];
}

#pragma mark - 初始化子控件
- (void)initNaviView {
    NavView *naviView = [NavView new];
    [self.view addSubview:naviView];
    self.naviView = naviView;
    
    naviView.title = @"随手拍";
    if (self.isCommentVC) {
        naviView.title = @"评论";
    }
    naviView.rightTitle = @"发布";
    [naviView rightButton].enabled = NO;
    
    WS
    naviView.Pop = ^{
        [weakSelf.textView resignFirstResponder];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    naviView.rightAction = ^{
        [weakSelf sendInfo];
        
    };
}

- (void)initTextView {
    XSTextView *textView = [XSTextView new];
    [self.view addSubview:textView];
    self.textView = textView;
    textView.canScrollText = YES;              //占位符可滑动
    textView.alwaysBounceVertical = YES;       //竖直方向上可滑动
    textView.placeholder = @"说点什么吧...";
    textView.font = [UIFont systemFontOfSize:16.0f];
    [textView becomeFirstResponder];
    textView.delegate = self;
}

- (void)initAddImageButton {
    UIButton *addImageButton = [UIButton setUpButtonsWithColor:RGB(0, 122, 255)
                                               isEnabled:YES
                                                    title:@"添加图片"];
    [self.view addSubview:addImageButton];
    self.addImageButton = addImageButton;
    [addImageButton addTarget:self
                       action:@selector(addImageButtonTapped)
             forControlEvents:UIControlEventTouchUpInside];
}

- (void)initTextCountLabel {
    UILabel *textCountLabel = [UILabel new];
    [self.view addSubview:textCountLabel];
    self.textCountLabel = textCountLabel;
    textCountLabel.textColor = RGB(90, 192, 44);
}

- (void)initPhotoView {
    PhotoView *photoView = [PhotoView new];
    [self.view addSubview:photoView];
    self.photoView = photoView;
    /** 监听图片视图中的数据源 */
    [photoView addObserver:self
                     forKeyPath:@"dataSource"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
}

- (void)makeAutoLayout {
    /** 导航条 */
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    /** 文字输入框 */
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@120);
    }];
    
    /** 添加图片按钮 */
    [self.addImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(5);
        make.left.equalTo(self.textView);
        make.width.equalTo(@65);
    }];
    
    /** 文字计数器 */
    [self.textCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom);
        make.right.equalTo(self.textView.mas_right);
    }];
    
    /** 图片视图 */
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addImageButton.mas_bottom).offset(5);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
@end
