//
//  BNApartmentTableViewController.m
//  WorkBench
//
//  Created by wouenlone on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "BNChangeProductViewController.h"
#import "BNAddProductViewController.h"
#import "BNApartmentTableViewController.h"
#import "BNApartmentTableViewCell.h"
#import "BNProductModel.h"
#import "BNApartmentTableViewHeaderView.h"
#import "Tools.h"
#import <AFNetWorking.h>
#import <MJRefresh.h>
#import "MBProgressHUD+Extend.h"
#import "BNProductModel.h"
#import "BNWaterMark.h"

@interface BNApartmentTableViewController ()

@property (nonatomic,strong) NSArray *allProduct;

@end

@implementation BNApartmentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 水印
    UIImage *img = [BNWaterMark getwatermarkImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    //设置虚拟值
    self.address = [NSString stringWithFormat:@"%@  %@单元  %@",self.address,self.unit_no,self.root_no];
//    //000102140000000001083777/1单元/302室
//    self.building_id = @"000102140000000001083777";
//    self.unit_no = @"1单元";
//    self.root_no = @"302室";
    //设置背景
    [self setBackgroundViewForTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置title 字体
    self.title = @"产品详情";
    self.tableView.header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(drop_downRefresh)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    //给navigationBar 添加右边的按钮
    [self setAddProductButton];
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [self getRequest];
}
- (void) setAddProductButton
{
    UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addNewProduct)];
    self.navigationItem.rightBarButtonItem = rightNavigationItem;
}
- (void) addNewProduct
{
    //点击添加按钮跳转到下个界面  模拟参数
    BNAddProductViewController *addProduct = [[BNAddProductViewController alloc]initWithHouseAddress:self.address];
    addProduct.BUILDING_ID = self.building_id;
    addProduct.UNIT_NO = self.unit_no;
    addProduct.ROOT_NO = self.root_no;
    [self.navigationController pushViewController:addProduct animated:YES];
}
- (void)drop_downRefresh
{
    [self getRequest];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source and Delegate
//头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //传进来view
    //此数据应是 apartment 的address 属性
    UIView *headerView = [BNApartmentTableViewHeaderView getApartmentTableViewHeadViewWithAddress:self.address];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//   // tableView.separatorColor = [UIColor orangeColor];//待传入颜色值
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.allProduct == nil) {
        return 0;
    }
    return self.allProduct.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BNProductModel *product = [[BNProductModel alloc]init];
    product = self.allProduct[indexPath.row];

   //传进去product 和 tableview
    BNApartmentTableViewCell *cell = [BNApartmentTableViewCell getTableViewCellWithTableView:tableView andProduct:product];
    //cell的contentView.tag = 20
    [[Tools sharedGestVisitTools] marginOfViewAtBottm:cell.contentView withColor:[UIColor orangeColor] width:1];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
   
}
//选中cell跳转到修改页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNProductModel *model = self.allProduct[indexPath.row];
    BNChangeProductViewController *modification = [[BNChangeProductViewController alloc]initWithHouseAddress:self.address andProductId:model.PRODUCT_ID];

    [self.navigationController pushViewController:modification animated:YES];
    
}
//左滑删除cell
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNProductModel *model = self.allProduct[indexPath.row];
    NSString *product_id = model.PRODUCT_ID;
    [self requestDeleteProductWithProduct_id:product_id];
    
    NSMutableArray *allProductB = [self.allProduct mutableCopy];
    [allProductB removeObjectAtIndex:indexPath.row];
    self.allProduct = [allProductB copy];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    /** 发送网络请求删除数据库数据 */
    
    
}

 //给tableview设置背景
- (void)setBackgroundViewForTableView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
   // [[Tools sharedGestVisitTools] setBackgroundImageWithView:view];
    [self.tableView setBackgroundView:view];
}

#pragma mark URLRequest
- (void) getRequest
{
    WS;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:[self getURL] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        /*
//         *数据请求成功
//         *1.重新加载页面
//         *2.停止下拉刷新
//         *3.取出数据给数组赋值
//         **/
//        NSString *info = responseObject[@"MSGCODE"];
//        [weakSelf.tableView.header endRefreshing];
//        if ([info isEqualToString:@"000"]) {
//            [MBProgressHUD showError:@"系统异常"];
//        }else{
//            if (responseObject[@"RESULT"] == nil) {
//                [MBProgressHUD showError:@"无数据"];
//                return ;
//            }
//        [weakSelf getDataFromDic:responseObject];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.tableView reloadData];                
//            });
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [weakSelf.tableView.header endRefreshing];
//        [MBProgressHUD showError:@"网络请求失败"];
//        NSLog(@"网络请求失败%@",error);
//    }];
    
    NSDictionary *param = @{@"BUILDING_ID":self.building_id,@"UNIT_NO":self.unit_no,@"ROOT_NO":self.root_no};
        [manager POST:APARTMENTPRODUCT parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            /*
             *数据请求成功
             *1.重新加载页面
             *2.停止下拉刷新
             *3.取出数据给数组赋值
             **/
            NSString *info = responseObject[@"MSGCODE"];
            [weakSelf.tableView.header endRefreshing];
            if ([info isEqualToString:@"000"]) {
                [MBProgressHUD showError:@"系统异常"];
            }else{
                [weakSelf getDataFromDic:responseObject];
                    [weakSelf.tableView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf.tableView.header endRefreshing];
            [MBProgressHUD showError:@"网络请求失败"];
            NSLog(@"网络请求失败%@",error);
        }];

}
- (void)getDataFromDic:(NSDictionary *)dic
{
    //NSLog(@"返回某户的产品信息数据%@",dic);
    self.allProduct = [BNProductModel getProductModelFromDic:dic];
}
- (NSString *)getUrlForDeleteProductWithProduct_id:(NSString *)product_id
{
//    NSString *str = @"http://haydroid.ittun.com/scm/userback/delproduct";
//    return [str stringByAppendingString:[NSString stringWithFormat:@"/%@",product_id]];
    return [DELETEPRODUCT stringByAppendingString:[NSString stringWithFormat:@"/%@",product_id]];
}
- (void) requestDeleteProductWithProduct_id:(NSString *)product_id
{
    NSLog(@"删除用户产品URL%@",[self getUrlForDeleteProductWithProduct_id:product_id] );
    WS;
    AFHTTPSessionManager *manager =  [AFHTTPSessionManager manager];
    [manager GET:[self getUrlForDeleteProductWithProduct_id:product_id] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *resutl = responseObject[@"MSGCODE"];
        if ([resutl isEqualToString:@"000"]) {
            [MBProgressHUD showError:@"系统异常"];
        }else if ([resutl isEqualToString:@"600"]){
            [MBProgressHUD showError:@"删除失败"];
        }else{
        [MBProgressHUD showSuccess:@"删除成功"];
        }
        [weakSelf.tableView.header beginRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络请求失败"];
        [weakSelf.tableView.header beginRefreshing];
    }];
}
-(void)dealloc
{
    NSLog(@"界面释放");
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
