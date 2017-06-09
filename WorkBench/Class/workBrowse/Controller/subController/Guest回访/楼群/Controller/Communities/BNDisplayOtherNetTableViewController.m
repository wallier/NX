//
//  BNDisplayOtherNetTableViewController.m
//  WorkBench
//
//  Created by wouenlone on 16/8/16.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "BNOtherNetTableViewCell.h"
#import "BNDisplayOtherNetTableViewController.h"
#import "Tools.h"
#import <AFNetWorking.h>
#import "MBProgressHUD+Extend.h"


@interface BNDisplayOtherNetTableViewController ()
@property (nonatomic, strong) NSArray *otherNet;
@end

@implementation BNDisplayOtherNetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setBackgroundViewForTableView];
 
    
    [self getRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.otherNet.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNOtherNetTableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:@"cellForOtherNet"];
    if (!cells) {
        cells = [[[NSBundle mainBundle] loadNibNamed:@"BNOtherNetTableViewCell" owner:nil options:nil] firstObject];
        cells.backgroundView.backgroundColor = [UIColor clearColor];
        cells.backgroundColor = [UIColor clearColor];
    }
    [[Tools sharedGestVisitTools] marginOfViewAtBottm:cells.contentView withColor:[UIColor groupTableViewBackgroundColor] width:1];
    
    cells.selectionStyle = UITableViewCellSelectionStyleNone;
    BNOtherNetModel *model = [[BNOtherNetModel alloc]initWithDictionary:self.otherNet[indexPath.row]];
    
    cells.otherNetNameLabel.text =nil;
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@ %@",model.REDION_NAME,model.BUILDING_NO,model.UNIT_NO,model.ROOT_NO];
    cells.houseNumLabel.text = str;
    cells.findTimeLabel.text = model.FIND_TIME;
    cells.finderNameLabel.text = model.FIND_PERSON;
    
    

    return cells;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是第一个cell那么高度增加10 给顶部多出加一条黄线的位置
    
    return 120;
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0,20);
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    //tableView.separatorColor = [UIColor orangeColor];
//    
//}
//给tableview设置背景
- (void)setBackgroundViewForTableView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    [[Tools sharedGestVisitTools] setBackgroundImageWithView:view];

    [self.tableView setBackgroundView:view];
}

- (void) getRequest
{
    WS;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[self getURL] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"MSGCODE"] isEqualToString:@"000"]) {
            [MBProgressHUD showError:@"系统异常"];
        }else if ([responseObject[@"MSGCODE"] isEqualToString:@"300"])
        {
            weakSelf.otherNet = responseObject[@"RESULT"];
            NSLog(@"他网占用信息：%@",weakSelf.otherNet);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络请求失败"];
    }];

}
- (NSString *) getURL
{
    //OTHER_NET
    NSString *str = [OTHER_NET stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",self.wg_id,self.region_id]];
    return str;
}

-(void)dealloc
{
    NSLog(@"界面释放");
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
