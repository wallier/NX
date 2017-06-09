//
//  BNApartmentTableViewCell.m
//  WorkBench
//
//  Created by wouenlone on 16/8/17.
//  Copyright © 2016年 com.bonc. All rights reserved.
//
#import "Tools.h"
#import "BNApartmentTableViewCell.h"
@interface BNApartmentTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *operatorLabel;//运营商
@property (weak, nonatomic) IBOutlet UILabel *businessNumLabel;//业务编号
@property (weak, nonatomic) IBOutlet UILabel *combinationProductsLabel;//套餐
@property (weak, nonatomic) IBOutlet UILabel *deadTimeLabel;//到期时间
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;//速率
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@property (weak, nonatomic) IBOutlet UIImageView *productImageBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *pointToSpeedLabel;


@end

@implementation BNApartmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
+ (instancetype)getTableViewCellWithTableView:(UITableView *)tableView andProduct:(BNProductModel *)product
{
    BNApartmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell"];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BNApartmentTableViewCell" owner:nil options:nil] lastObject];
        cell.productImageBackgroundView.backgroundColor = RGB(245, 174, 0);
    }
    
    //productModel的属性
//    @property (nonatomic,copy) NSString *OPERATOR_TYPE;//运营商
//    @property (nonatomic,copy) NSString *PRODUCT_ID;//用户产品信息编号
//    @property (nonatomic,copy) NSString *PACKAGE_MEAL;//套餐
//    @property (nonatomic,copy) NSString *EXPIRE;//到期时间
//    @property (nonatomic,copy) NSString *PRODUCT_RATE;//速率
//    @property (nonatomic,copy) NSString *PRODUCT_TYPE;//产品类别 固话、移动、宽带、ITV
//    @property (nonatomic,copy) NSString *USER_NUMBER;//用户号码
//    @property (nonatomic,copy) NSString *note;//备注
    
    
    cell.operatorLabel.text = [[Tools sharedGestVisitTools] getOperatorNameByOPERATOR_TYPEinParam:product.OPERATOR_TYPE];
   
    
    cell.businessNumLabel.text = product.PRODUCT_ID;
    cell.combinationProductsLabel.text = product.PACKAGE_MEAL;
    cell.deadTimeLabel.text = product.EXPIRE;
    // PRODUCT_TYPE --> 产品类别（固话：1，宽带：2，手机：3，IPTV：4）
    //OPERATOR_TYPE --> 运营商（电信：1，移动：2，联通：3，未知：4）
    if (![product.PRODUCT_TYPE isEqualToString:@"2"]) {
        cell.speedLabel.hidden = YES;
        cell.pointToSpeedLabel.hidden = YES;
        if ([product.PRODUCT_TYPE isEqualToString:@"1"]) {
            cell.productImageView.image = [UIImage imageNamed:@"business_03.jpg"];
        }else if ([product.PRODUCT_TYPE isEqualToString:@"3"]){
            cell.productImageView.image = [UIImage imageNamed:@"business_06.jpg"];
        }else if ([product.PRODUCT_TYPE isEqualToString:@"4"]){
             cell.productImageView.image = [UIImage imageNamed:@"business_07"];
        }
    }else if([product.PRODUCT_TYPE isEqualToString:@"2"]){
        cell.speedLabel.hidden = NO;
        cell.pointToSpeedLabel.hidden = NO;
        cell.speedLabel.text = product.PRODUCT_RATE;
        cell.productImageView.image = [UIImage imageNamed:@"business_04.jpg"];
        
    }
        
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
