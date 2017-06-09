//
//  HeaderandUrl.h
//  WorkBench
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 com.bonc. All rights reserved.
//

#ifndef HeaderandUrl_h
#define HeaderandUrl_h

#define Colros(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
//服务地址

//#define SERVER_IP @"202.100.110.55" // @"192.168.8.10:8000" //118.186.205.203:8000/scm

//#define SERVER_HOMES @"http://202.100.110.55:81/scm"// @"http://192.168.8.10:8000/scm"
// 服务器地址
//#define SERVER_HOMES @"http://bonc.ittun.com/scm"
//#define SERVER_HOMES @"http://haydroid.ittun.com/scm"
//#define SERVER_HOMES @"http://192.168.0.125:8080/scm"
// 宁夏服务器
 #define SERVER_HOMES @"http://202.100.110.55:9081/scm"

#define SER_LOGIN_URL [SERVER_HOMES stringByAppendingString:@"/splituserlogon"]
//userlogon
#define SER_LOGIN_URL_PHONE [SERVER_HOMES stringByAppendingString:@"/userlogonbyphonenum"]
#define USER_360_URL [SERVER_HOMES stringByAppendingString:@"/user360view"]


#define Getcustomerdetailtwo   [SERVER_HOMES stringByAppendingString:@"/datapool/getcustomerdetailtwo"]
#define Getcustomerdetailthree   [SERVER_HOMES stringByAppendingString:@"/datapool/getcustomerdetailthree"]
#define Getcustomerdetailfour   [SERVER_HOMES stringByAppendingString:@"/datapool/getcustomerdetailfour"]

//test
//#define RESPORT_INTERFACE @"http://192.168.6.211:8899/scm_ningxia_ios/getUserMenus.action"
//#define SUBMENU_INTERFACE @"http://192.168.6.211:8899/scm_ningxia_ios/getSubMenu.action"

//菜单地址
//#define RESPORT_INTERFACE @"http://202.100.110.55:81/scm_ningxia_ios/getUserMenus.action"
#define RESPORT_INTERFACE @"http://202.100.110.55:9081/scm_ningxia_ios/getUserMenus.action"
//#define SUBMENU_INTERFACE @"http://202.100.110.55:81/scm_ningxia_ios/getSubMenu.action"
#define SUBMENU_INTERFACE @"http://202.100.110.55:9081/scm_ningxia_ios/getSubMenu.action"

#define MYDELE_SubView_URL [Resport_INTERFACE stringByAppendingString:@"/getSubMenu.action"];

// Message
#define WARNINGURL SERVER_HOMES@"/mymessage/getmsgwarn/"


// Guest回访
/** 根据角色下钻获取下一级组织机构信息URL */
#define ROLEURL SERVER_HOMES@"/userback/gridByRole/"
/** 网格url */
#define GRIDURL SERVER_HOMES@"/userback/grid/"
/** 网格下小区url */
#define REGIONURL SERVER_HOMES@"/userback/region/"
/** 所有的小区url */
#define ALLREGI_ON_URL SERVER_HOMES@"/userback/regionall"
/** 获取CITY_NO的url */
#define CITY_ON_URL SERVER_HOMES@"/userback/city/"
/** 获取添加小区到服务器的url */
#define ADDREGION_URL SERVER_HOMES@"/userback/addregion"
/** 获取单元梗概url */
#define UNIT_SUMMARY_URL SERVER_HOMES@"/userback/floordisplay"
/** 获取单元的详细信息 */
#define UNIT_DETAIL_URL SERVER_HOMES@"/userback/floordisplayinfo"
/** 添加住户 */
#define ADD_ONEHOUSE SERVER_HOMES@"/userback/addproduct"
/** 一次性添加信息 */
#define ADD_ONETIME_URL SERVER_HOMES@"/userback/addcomplete"

/** 楼群 */
#define REGION [SERVER_HOMES stringByAppendingString:@"/userback/regiondisplay"]
/** 小区展示 */
#define REGION_DISPLAY [REGION stringByAppendingString:@"/region_id/wg_id"]
/** 添加住宅楼 */
#define ADD_BUILDING  [SERVER_HOMES stringByAppendingString:@"/userback/addbuild"]
/** 获取他网占我网 */
#define OTHER_NET  [SERVER_HOMES stringByAppendingString:@"/userback/occupydisplay"]

/** 产品 */

/**显示某个房屋里的产品信息 */
#define APARTMENTPRODUCT [SERVER_HOMES stringByAppendingString:@"/userback/productinfo"]
/** 获取某个具体的产品 */
#define GET_A_PRODUCT [SERVER_HOMES stringByAppendingString:@"/userback/productout"]
/** 修改某个产品 */
#define MODIFICATION_PRODUCT [SERVER_HOMES stringByAppendingString:@"/userback/updproduct"]
/** 添加产品 */
#define ADDPRODUCT [SERVER_HOMES stringByAppendingString:@"/userback/addreviewinfo"]
/** 删除某个产品 */
#define DELETEPRODUCT [SERVER_HOMES stringByAppendingString:@"/userback/delproduct"]
/** 一次性添加信息 */
#define ONCEADDINFO [SERVER_HOMES stringByAppendingString:@"/scm/userback/addcomplete"]





//客户回访
//<<<<<--------------废弃不用了(下)---------------->>>>>>
#define  KHHFURL  @"http://202.100.110.55:81/scm_ningxia_ios/getAllArea.action"
#define KHHFDETAILURL1 @"http://202.100.110.55:81/scm_ningxia_ios/getEachProduct.action"
#define KHHFDETAILURL2 @"http://202.100.110.55:81/scm_ningxia_ios/getOneUserPro.action"
#define KHHFRZURL @"http://202.100.110.55:81/scm_ningxia_ios/getUserBackLogs.action"
#define GXKHHF @"http://202.100.110.55:81/scm_ningxia_ios/updateUserBack.action"
#define ADDKHURL @"http://202.100.110.55:81/scm_ningxia_ios/addUserBack.action"
#define DELECTJL @"http://202.100.110.55:81/scm_ningxia_ios/deleteUserBack.action"
//<<<<<--------------废弃不用了(上)---------------->>>>>>

//#define BASEURLS @"http://172.16.21.46:8080"//@"http://192.168.6.211:8686" //测试
//#define BASEURL @"http://202.100.110.55:81"//@"http://192.168.6.211:8686" //

#define BASEURL @"http://202.100.110.55:9081"
//1.获取数据池总体页面数据
#define DataPoolURL BASEURL"/scm_ningxia_ios/getIndexDataPool.action"

//2.点击发展机会数据获取每个子条目
#define DataPoolDevelopURL BASEURL"/scm_ningxia_ios/getDatapoolDevChance.action"

//3.点击发展机会个数下策略名称下用户列表
#define DataPoolDevChanceUserListURL BASEURL"/scm_ningxia_ios/getDevChanceUserList.action"

//4.点击三心用户数获取每个子条目
//#define DataPoolThreeHeartURL BASEURL"/scm_ningxia_ios/getDataPoolThreeHeart.action"
#define DataPoolThreeHeartURL BASEURL"/scm/datapool/getthreeheartGrab/"///1002/HX/864000200211004

//5.点击三心用户下 各个策略名称 显示用户列表；数据池获取三心用户 用户列表
//#define DataPoolThreeHeartUserListURL BASEURL"/scm_ningxia_ios/getThreeHeartUserList.action"
#define DataPoolThreeHeartUserListURL BASEURL"/scm/datapool/getThreeHeartUserGrabList/"


//6.点击 三心用户列表 获取各个三心用户列表子数据；数据池获取三心用户中的任意一个
//#define DataPoolThreeHeartAnyOneURL BASEURL"/scm_ningxia_ios/getThreeHeartAnyOne.action"
#define DataPoolThreeHeartAnyOneURL BASEURL"/scm/datapool/getthreeheartitemGrab/"


//6.1是否满员 进入抢单界面
#define GrabOnlineOrDownlineURL BASEURL"/scm/datapool/grabOnlineOrDownline/"

//7.点击 各个三心列表下面的策略名称 下的用户列表
//#define  DataPoolThreeHeartItemUserListURL BASEURL"/scm_ningxia_ios/getThreeHeartItemUserList.action"
#define  DataPoolThreeHeartItemUserListURL BASEURL"/scm/datapool/getThreeHeartItemGrabUserList/"


//8.工单处理
#define DataPoolThreeHeartDefaultOrderURL  BASEURL"/scm_ningxia_ios/getThreeHeartDefaultOrder.action"

//8.1 发展用户中的工单详情
#define GetGrabDpWorkOrderDetailURL  BASEURL"/scm/datapool/getGrabDpWorkOrderDetail/"

//9.工单详情
#define DataPoolThreeHeartUntreatedOrderURL  BASEURL"/scm_ningxia_ios/getThreeHeartUntreatedOrder.action"

//10.客户视图
#define DataPoolThreeHeartClientViewURL  BASEURL"/scm_ningxia_ios/getThreeHeartClientView.action"

//11.趋势图
#define DataPoolUserInfoTrendURL  BASEURL"/scm_ningxia_ios/getDatapoolUserInfoTrend.action"

//12.划小经理转派给网格经理的用户
#define DataPoolWGDataThreeURL  BASEURL"/scm_ningxia_ios/updateUserWGDataThree.action"

//13.工单回退
#define DataPoolGDStautsNotURL  BASEURL"/scm_ningxia_ios/updateGDStautsNot.action"

//13.1 工单回退，新
#define ExecuteGrabGDStautsNot  BASEURL"/scm/datapool/executeGrabGDStautsNot"

//14.未处理工单处理（打电话处理或者发送短信处理）
#define DataPoolGDStautsURL  BASEURL"/scm_ningxia_ios/updateGDStauts.action"

//15.未处理工单处理（提交回单页面）
#define DataPoolGDStautsEndURL  BASEURL"/scm_ningxia_ios/updateGDStautsEnd.action"

//16.回单信息录入
#define DataPoolEnteringThreeURL  BASEURL"/scm_ningxia_ios/receiptInfoEnteringThree.action"
#define ExecuteGrabgdstautsend  BASEURL"/scm/datapool/executeGrabgdstautsend/"

//17.撤销所抢订单
#define  ReverceGrabWorkOrderURL BASEURL"/scm/datapool/reverceGrabWorkOrder/"

//18.我的已抢工单列表
#define  GetThreeHeartUserOwnGrabListURL BASEURL"/scm/datapool/getThreeHeartUserOwnGrabList/"

//19.抢单剩余抢单数 所拥有单数  限制最高单数
#define  GetLimitGrabURL BASEURL"/scm/datapool/getLimitGrab/"

//20.抢订单
#define  GrabWorkOrderURL BASEURL"/scm/datapool/GrabWorkOrder/"


//版本升级
#define GET_VERSION_URL  BASEURL"/scm_ningxia_ios/queryNxVersion.action"

//HX数据获取
#define getHXData BASEURL"/scm/userlogonCeo"

//流量
#define GetFlowMonth BASEURL"/scm_ningxia_ios/getFlowMonth.action"

//预警Y
#define GetVoiceEarlyWarning BASEURL"/scm_ningxia_ios/getVoiceEarlyWarning.action"
//预警L
#define GetFlowEarlyWarning BASEURL"/scm_ningxia_ios/getFlowEarlyWarning.action"
//预警X
#define GetAgreementEarlyWarning BASEURL"/scm_ningxia_ios/getAgreementEarlyWarning.action"
//终端绑定查询
#define FindImeiByLoginId BASEURL"/scm_ningxia_ios/findImeiByLoginId.action"
//终端绑定
#define UpdateImeiByLoginId BASEURL"/scm_ningxia_ios/updateImeiByLoginId.action"

//力合外呼接口
#define  Forwordrequesturltoheli BASEURL"/scm_ningxia_ios/forwordrequesturltoheli.action"

//划小CRM已执行工单状态同步
//#define HXdataupdatewithCRM [SERVER_HOMES stringByAppendingString:@"/datapool/hxdataupdatewithCRM"]
#define HXdataupdatewithCRM [SERVER_HOMES stringByAppendingString:@"/datapool/hxdataupdatewithCRMGrab"]


//划小单条工单的状态同步
#define HXdatacoordinationwithCRM [SERVER_HOMES stringByAppendingString:@"/datapool/hxdatacoordinationwithCRM"]
//推送设置
//#define UpdateMsgPushState @"http://172.16.21.46:8080/scm_ningxia_ios/updateMsgPushState.action"
#define UpdateMsgPushState BASEURL"/scm_ningxia_ios/updateMsgPushState.action"

//获取数据
//#define GetMessage @"http://172.16.21.46:8080/scm_ningxia_ios/getMessage.action"
#define GetMessage BASEURL"/scm_ningxia_ios/getMessage.action"

//登录界面获取数据
//#define GetMainINfo @"http://202.100.110.55:81/scm/splituserlogon"
#define GetMainINfo @"http://202.100.110.55:9081/scm/splituserlogon"

//全量小区视图获取数据
#define QuanLiangXiaoQuInfo @"http://202.100.110.55:9081/scm/userback/getCenterHomeInfo/"


//化小接口

#endif /* HeaderandUrl_h */
