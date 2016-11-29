//
//  EFRiskViewModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/20.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewModel.h"
#import "RSRiskBannerModel.h"
#import "RSDateCenterModel.h"
#import "RSSReportModel.h"
#import "RSDateCenterMoreModel.h"
#import "RSRiskDetailModel.h"
#import "RSHomeDataModel.h"
#import "RSADModel.h"
#import "RSFollowUpRecordModel.h"
#import "RSRFDAModel.h"
#import "RSFDARiskModel.h"
#import "AllHealthModel.h"
#import "HealthModel.h"
#import "RSDataCenterDetailModel.h"
#import "RSRecordModel.h"
#import "RSMsgMdoel.h"
#import "RSEaseMobUserListModel.h"
#import "RSMyCollectRiskModel.h"
#import "RSMyCollectFilesModel.h"
#import "VersionInfoModel.h"
#import "SaleModel.h"


@class RSSearchResultModel;
@class HealthEducationDetailsModel;

#if NS_BLOCKS_AVAILABLE
typedef void (^RequestCallBackBlock)(CallBackStatus callBackStatus,NetworkModel * result);
#endif


typedef NS_ENUM(EFViewControllerCallBackAction,RSViewModelCallBackAction){
#pragma mark  **************优生优育风险分类rest接口******************
    RSRisk_NS_ENUM_findAllFDARiskCategory = 1, // 获取FDA风险分类所有栏目
    RSRisk_NS_ENUM_findAllRiskCategory = 2, //获取风险分类所有栏目
    RSRisk_NS_ENUM_findFDARisk = 3, //根据fda栏目id和fda类型获取风险因素
    RSRisk_NS_ENUM_findNextCategory = 4, //获取下级风险因素列表
    RSRisk_NS_ENUM_findCategoryAllContent = 5, //获取项目风险因素列表
    
#pragma mark  **************优生优育资料中心rest接口******************
    
    RSRisk_NS_ENUM_riskfilesOne = 6, // 根据栏目id获取该分类所有资料(查看更多)  第一级
    RSRisk_NS_ENUM_riskfilesTwo = 45, // 根据栏目id获取该分类所有资料(查看更多)  第二级
    RSRisk_NS_ENUM_findHealthByCategory = 7, //根据健康分类获取资料列表(查看更多)
    RSRisk_NS_ENUM_findMoreRiskFileByTitleOne = 8, //根据关键字搜索资的查看更多  第一级
    RSRisk_NS_ENUM_findMoreRiskFileByTitleTwo = 46, //根据关键字搜索资的查看更多  第二级
    RSRisk_NS_ENUM_findRiskFileByTitle = 9, //根据关键字搜索资料
    RSRisk_NS_ENUM_findAllHealth = 10, //获取健康教育页内容
    RSRisk_NS_ENUM_findIndexFiles = 11, //获取首页展示精品资料列表
    RSRisk_NS_ENUM_findRiskfiles = 12, //获取资料中心页内容
    RSRisk_NS_ENUM_findRiskFileById = 13, //根据资料id拿到资料详情
    
#pragma mark  **************优生优育统计报表rest接口******************
    RSRisk_NS_ENUM_findFollowUpRecords = 14, //获取统计报表记录
    
#pragma mark  **************优生优育风险rest接口******************
    RSRisk_NS_ENUM_findRiskDetails = 15, //获取风险详情
    RSRisk_NS_ENUM_findRiskByKeyWord =23, //全文检索接口
    
    
#pragma mark  **************广告管理rest接口******************
    RSRisk_NS_ENUM_getSystemAdvertisementsByPositions = 16,  //获取广告列表
    RSRisk_NS_ENUM_updateAdClickCount = 17,  //更新广告点击次数（用户点击广告调用）
    
    
#pragma mark  **************优生优育随访档案rest接口******************
    
    RSRisk_NS_ENUM_findFollowRecord = 18, //获取随访档案记录列表
    RSRisk_NS_ENUM_saveFollowRecord = 19, //添加随访档案
    RSRisk_NS_ENUM_updateFollowRecord = 20, //编辑随访档案
    RSRisk_NS_ENUM_deleteFollowRecord = 21, // 删除随访档案
    RSRisk_NS_ENUM_getBirthNum = 49, // 获取近十天要产的人数
    
#pragma mark  **************用户管理rest接口******************
    RSRisk_NS_ENUM_modifyPassword = 22,  //修改密码
    RSRisk_NS_ENUM_getUserProfileByEasemob = 23, //通过环信账号获取用户资料列表
    
    
    
#pragma mark  **************优生优育资料中心社交rest接口******************
    RSRisk_NS_ENUM_cancelFavourite = 30,  //取消收藏
    RSRisk_NS_ENUM_cancelPraise = 31,  //取消点赞
    RSRisk_NS_ENUM_favourate = 32,  //收藏
    RSRisk_NS_ENUM_praise = 33,  //点赞
    RSRisk_NS_ENUM_findMyFavourateTargets = 39,  //查询我收藏的对象列表
    RSRisk_NS_ENUM_getAllHealthFiles = 51,     //获得所有健康教育资料
    
#pragma mark  **************优生优育个人中心rest接口******************
    RSRisk_NS_ENUM_findSubmitRecords = 34,  //提交记录列表
    RSRisk_NS_ENUM_submitRisk = 35,  //提交风险名词
    RSRisk_NS_ENUM_submitFeedback = 44, //提交意见反馈
    
#pragma mark  **************消息管理rest接口******************
    RSRisk_NS_ENUM_getMyMessages = 36,  //我的消息列表
    RSRisk_NS_ENUM_getUnReadMsgCount = 37,  //我的未读消息数量
    RSRisk_NS_ENUM_updateUnReadMessage = 38, //更新消息未读标识
    RSRisk_NS_ENUM_getSystemNotice = 48,  //获取系统公告消息
    
#pragma mark  **************静态页面rest接口******************
    RSRisk_NS_ENUM_getStaticViewPath = 40,   //获取个人中心静态界面地址
    
#pragma mark  **************风险社交rest接口******************
    RSRisk_NS_ENUM_cancelFavourate_RISK = 41,  //取消风险收藏
    RSRisk_NS_ENUM_favourate_RISK = 42,  //风险收藏
    RSRisk_NS_ENUM_findMyFavourateTargets_RISK = 43,  //获取我的收藏列表——风险
    
#pragma mark  **************App版本管理rest接口******************
    RSRisk_NS_ENUM_getNewVersion = 47,  //获取最新app版本信息
    
#pragma mark  **************销售记录rest接口******************
    RSRisk_NS_ENUM_getMySaleRecord = 50,  //获取销售记录
    
    //注意：已经使用到51了
    
};



@interface RSRiskViewModel : EFBaseViewModel



#pragma mark  **************优生优育风险分类rest接口******************

@property (nonatomic, strong) NSMutableArray<RiskBannerModel *>  *riskBannerModelArray; //风险栏目
@property (nonatomic, strong) NSMutableArray<ChildrensModel *>  *childrensModelArray; //下级风险栏目
@property (nonatomic, strong) NSMutableArray <RSFDARiskModel *> *rsFDARiskModelArray;


/***  获取FDA风险分类所有栏目*/
- (void)findAllFDARiskCategory:(NSInteger )page size:(NSInteger )size;

/***  获取风险分类所有栏目*/
- (void)findAllRiskCategory;

/***  根据fda栏目id和fda类型获取风险因素*/
- (void)findFDARisk:(NSString *)type riskId:(NSInteger) riskId;

/***  获取下级风险因素列表*/
- (void)findNextCategory:(NSInteger) riskId;

/***  获取项目风险因素列表*/
- (void)findCategoryAllContent:(NSInteger) riskId;


#pragma mark  **************优生优育资料中心rest接口******************

@property (nonatomic, strong) NSMutableArray<RSDateCenterModel *>  *rsDateCenterModelArray; //资料中心栏目
@property (nonatomic, strong) RSDateCenterMoreModel *rsDateCenterMoreModel; //资料中心更多页面

@property (nonatomic, strong) NSMutableArray<RSDateCenterModel *>  *rsDateCenterMoreSecondArray; //资料中心子栏目

@property (nonatomic, strong) NSMutableArray<RSDateCenterModel *>  *searchResultArray;  //搜索结果

@property (nonatomic, strong) NSMutableArray<RSDateCenterModel *>  *searchResultSecondArray;  //子栏目搜索结果

@property (nonatomic, strong) NSMutableArray <RSRFDAModel *> *rsRFDAModelArray; //FDA风险分类所有栏目
@property (nonatomic, strong) NSArray<AllHealthModel *> * healthArrayModel;  //健康教育资讯栏目
@property (nonatomic, strong) HealthModel * healthModel;  //健康教育资讯列表
@property (nonatomic, strong) RSDataCenterDetailModel *rsDataCenterDetailModel; //资料中心详情

@property (nonatomic, strong) HealthEducationDetailsModel *healthEducationDetailsModel; //健康教育详细数据列表



/***  根据资料id拿到资料详情 */
- (void)findRiskFileById:(NSInteger) riskId;

/***  根据栏目id获取该分类所有资料(查看更多) 第一级 */
- (void)moreRiskfilesOne:(NSInteger )page size:(NSInteger )size riskId:(NSInteger) riskId;

/***  根据栏目id获取该分类所有资料(查看更多) 第二级 */
- (void)moreRiskfilesTwo:(NSInteger )page size:(NSInteger )size riskId:(NSInteger) riskId;

/***  根据健康分类获取资料列表(查看更多)*/
- (void)findHealthByCategory:(NSInteger )page size:(NSInteger )size riskId:(NSInteger) riskId;

/***  根据关键字搜索资的查看更多 第一级*/
- (void)findMoreRiskFileByTitleOne:(NSInteger )page size:(NSInteger )size riskId:(NSInteger) riskId keyWord:(NSString *)keyWord;

/***  根据关键字搜索资的查看更多 第二级*/
- (void)findMoreRiskFileByTitleTwo:(NSInteger )page size:(NSInteger )size riskId:(NSInteger) riskId keyWord:(NSString *)keyWord;

/***  根据关键字搜索资料*/
- (void)findRiskFileByTitle:(NSString *)keyWord;

/***  获取健康教育页内容*/
- (void)findAllHealth;

/***  获取首页展示精品资料列表*/
- (void)findIndexFiles;

@property (nonatomic,strong)NSMutableArray * filesArray;

/***  获取资料中心页内容*/
- (void)findRiskfiles;


#pragma mark  **************优生优育统计报表rest接口******************


@property (nonatomic, strong) RSSReportModel *sreportModel;

- (void)findFollowUpRecords:(NSInteger )page size:(NSInteger )size recordsType:(NSInteger) recordsType isMine:(NSInteger )isMine year:(NSString *)year month:(NSString *)month type:(NSInteger )type;

#pragma mark  **************优生优育风险rest接口******************

@property (nonatomic, strong) RSRiskDetailModel *rsRiskDetailModel; //风险详情
@property (nonatomic, strong) NSArray <RSFDARiskModel *>*rsSearchResultArr; //搜索结果

- (void ) findRiskDetails:(NSInteger ) riskId;
/*** 全文检索接口*/
- (void ) findRiskByKeyWord:(NSInteger )page size:(NSInteger )size keyword:(NSString *)keyword;


#pragma mark  **************广告管理rest接口******************

@property (nonatomic,strong) NSMutableArray * advertisArray;    //广告列表
- (void)getSystemAdvertisementsByPositions:(NSString * )_position;
- (void)updateAdClickCount:(int)_advertisementId;

#pragma mark  **************优生优育随访档案rest接口******************

@property (nonatomic, strong) RSFollowUpRecordModel *rsFollowUpRecordModel;

/***  获取随访档案记录列表*/
- (void ) findFollowRecord:(NSString *)keyWord risk:(NSString *)risk year:(NSString *)year month:(NSString *)month  page:(NSInteger ) page size: (NSInteger )size;
/***  添加随访档案*/
- (void ) saveFollowRecord:(NSString *)json;
/***  删除随访档案*/
- (void ) deleteFollowRecord: (NSString *)patiendId;
/***  获取近十天要产的人数*/
- (void)getBirthNum;

/***  编辑随访档案*/
- (void ) updateFollowRecord:(NSString *)json;
#pragma mark  **************用户管理rest接口******************

@property (nonatomic, strong) RSEaseMobUserListModel *rsEaseMobUserListModel;

- (void)modifyPasswordWitholdPassWord:(NSString *)_oldPassWord newPassWord:(NSString *)newPassWord;
- (void )getUserProfileByEasemob: (NSString *)easemobIds;
- (void )getUserProfileByEasemob: (NSString *)easemobIds callBackBlock:(RequestCallBackBlock )callBackBlock;


#pragma mark  **************优生优育资料中心社交rest接口******************
/**获得所有健康教育资料*/
- (void)getAllHealthFiles:(NSInteger)page size:(NSInteger)size;
/**收藏*/
- (void)favourate:(NSInteger)targetId;
/**取消收藏*/
- (void)cancelFavourite:(NSInteger ) targetId;
/**取消点赞*/
- (void)cancelPraise:(NSInteger ) targetId;
/**点赞*/
- (void)praise:(NSInteger ) targetId;

@property (nonatomic,strong)RSMyCollectFilesModel * collecttionFilesModel;
/**
 *  获取我搜藏的对象列表
 *
 *  @param _page 页数
 *  @param _size 每页数量
 */
- (void)findMyFavourateTargetsWithPage:(int)_page Size:(int)_size;


#pragma mark  **************优生优育个人中心rest接口******************

@property(nonatomic, strong)RSRecordModel * recordModel;
/**
 *  提交记录列表
 */
- (void)findSubmitRecordsWithPage:(int)_page size:(int)_size;

/**
 *  提交风险名词
 */
- (void)submitRisk:(NSString *)_name;

/**
 *  提交意见反馈
 *
 *  @param _suggestion 意见、建议
 */
- (void)submitFeedback:(NSString *)_suggestion;

#pragma mark  **************消息管理rest接口******************

@property (nonatomic, strong)RSMsgMdoel * msgModel;
@property (nonatomic, assign)int  unReadMsgCount;
@property (nonatomic, strong) NSArray * tMsgArray;

/**
 *  我的消息列表
 *
 *  @param _page 页数
 *  @param _size 每页数量
 */
- (void)getMyMessagesWithPage:(int)_page Size:(int)_size;

/**
 *  我的未读消息数量
 */
- (void)getUnReadMsgCount;

/**
 *  更新消息未读表示
 */
- (void)updateUnReadMessage;

/**
 *  获取系统公告消息
 */
- (void)getSystemNotice;


#pragma mark  **************静态页面rest接口******************

@property (nonatomic,strong) NSString * path;

/**
 *  获取个人中心静态界面url
 *
 *  @param _urlPath 地址
 */
- (void)getStaticViewUrlWithPath:(NSString * )_urlPath;


#pragma mark  **************风险社交rest接口******************
/**
 *  取消收藏
 */
- (void)cancelFavouriteRISK:(NSInteger)targetId;

/**
 *  收藏
 */
- (void)favourateRISK:(NSInteger)targetId;


@property (nonatomic,strong)RSMyCollectRiskModel * riskModel;

/**
 *  获取我的收藏列表
 */
- (void)findMyFavourateTargetsRISKWithPage:(int)_page Size:(int)_size;


#pragma mark  **************App版本管理rest接口******************

@property (nonatomic,strong) VersionInfoModel * versionModel;
/**
 *  获取app最新版本信息
 */
- (void)getNewVersion;


#pragma mark  **************销售记录rest接口******************
@property (nonatomic,strong) SaleModel * saleMdoel;
/**
 *  获取销售记录
 */
- (void)getMySaleRecordWithPage:(int)_page Size:(int)_size;

@end




