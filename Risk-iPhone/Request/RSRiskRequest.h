//
//  RSRiskRequest.h
//  Risk
//
//  Created by ylgwhyh on 16/7/20.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFRequest.h"

@interface RSRiskRequest : EFRequest

@end

#pragma mark  **************用户管理rest接口******************

@interface RSLoginRequest : EFRequest
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *md5Code;
@property (nonatomic, assign) int type;
@end

/**
 *  获取我的个人资料
 */
@interface RSGetMyProfile : EFRequest
@property (nonatomic,copy) NSString *token;
@end


/**
 *  通过环信账号获取用户资料列
 */

@interface getUserProfileByEasemob : EFRequest

@property (nonatomic,copy) NSString * easemobIds;

@end

#pragma mark  **************优生优育风险分类rest接口******************

/**
 *  获取FDA风险分类所有栏目
 */
@interface findAllFDARiskCategory : EFRequest

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;

@end

/**
 *  获取风险分类所有栏目
 */
@interface findAllRiskCategory : EFRequest

@end


/**
 *  根据fda栏目id和fda类型获取风险因素
 */
@interface findFDARisk : EFRequest

@property (nonatomic, assign) NSInteger riskId; //风险栏目Id
@property (nonatomic, copy) NSString *type;

@end

/**
 *  获取下级风险因素列表
 */
@interface findNextCategory : EFRequest

@property (nonatomic, assign) NSInteger riskId; //风险栏目Id

@end


/**
 *  获取项目风险因素列表
 */
@interface findCategoryAllContent : EFRequest

@property (nonatomic, assign) NSInteger riskId; //风险栏目Id

@end


#pragma mark  **************优生优育资料中心rest接口******************

/**
 *  获得所有健康教育资料
 */
@interface getAllHealthFiles : EFRequest

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger size;

@end

/**
 *  根据资料id拿到资料详情
 */
@interface findRiskFileById : EFRequest

@property (nonatomic, assign) NSInteger riskId;

@end


/**
 *  根据栏目id获取该分类所有资料(查看更多) 第一级
 */
@interface moreRiskfilesOne : EFRequest

@property (nonatomic, assign) NSInteger riskId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;

@end

/**
 *  根据栏目id获取该分类所有资料(查看更多) 第二级
 */
@interface moreRiskfilesTwo : EFRequest

@property (nonatomic, assign) NSInteger riskId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;

@end

/**
 *  根据健康分类获取资料列表(查看更多)
 */
@interface findHealthByCategory : EFRequest

@property (nonatomic, assign) NSInteger riskId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;

@end

/**
 *  根据关键字搜索资的查看更多 第一级
 */
@interface findMoreRiskFileByTitleOne : EFRequest

@property (nonatomic, assign) NSInteger riskId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, copy) NSString* keyWord;

@end

/**
 *  根据关键字搜索资的查看更多 第二级
 */
@interface findMoreRiskFileByTitleTwo : EFRequest

@property (nonatomic, assign) NSInteger riskId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, copy) NSString* keyWord;

@end

/**
 *  根据关键字搜索资料
 */
@interface findRiskFileByTitle : EFRequest

@property (nonatomic, copy) NSString* keyWord;

@end


/**
 *  获取健康教育页内容-- 左侧
 */
@interface findAllHealth : EFRequest

@end

/**
 *  获取首页展示精品资料列表
 */
@interface findIndexFiles : EFRequest

@end


/**
 *  获取资料中心页内容
 */
@interface findRiskfiles : EFRequest

@end


#pragma mark  **************优生优育统计报表rest接口******************

/**
 *  获取统计报表记录
 */
@interface findFollowUpRecords : EFRequest

@property (nonatomic, assign) NSInteger recordsType;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger isMine;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;

@end

#pragma mark  **************优生优育风险rest接口******************

/**
 * 全文检索接口
 */
@interface findRiskByKeyWord : EFRequest

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, copy) NSString *keyword;

@end

/**
 *  获取风险详情
 */
@interface findRiskDetails : EFRequest

@property (nonatomic, assign) NSInteger riskId;

@end



#pragma mark  **************优生优育随访档案rest接口******************

/**
 *  获取随访档案记录列表
 */
@interface findFollowRecord : EFRequest

@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, copy) NSString *risk;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;

@end


/**
 *  添加随访档案
 */
@interface saveFollowRecord : EFRequest

@property (nonatomic, copy) NSString *json;

@end


/**
 *  删除随访档案
 */
@interface deleteFollowRecord : EFRequest

@property (nonatomic, copy) NSString* patiendId;

@end


/**
 *  获取近十天要产的人数
 */
@interface getBirthNum : EFRequest

@end



/**
 *  编辑随访档案
 */
@interface updateFollowRecord : EFRequest

@property (nonatomic, copy) NSString *json;

@end

#pragma mark  **************广告管理rest接口******************
@interface GetSystemAdvertisementsByPositions : EFRequest

@property (nonatomic,strong) NSString * position;

@end


@interface updateAdClickCount : EFRequest

@property (nonatomic,assign) int advertisementId;

@end



#pragma mark  **************优生优育资料中心社交rest接口******************

/**取消收藏*/
@interface cancelFavourite : EFRequest

@property (nonatomic,assign) NSInteger targetId;

@end

/**取消点赞*/
@interface cancelPraise : EFRequest

@property (nonatomic,assign) NSInteger targetId;

@end

/**收藏*/
@interface favourate : EFRequest

@property (nonatomic,assign) NSInteger targetId;

@end


/**点赞*/
@interface praise : EFRequest

@property (nonatomic,assign) NSInteger targetId;

@end

/**
 *  查询我收藏的对象列表
 */
@interface findMyFavourateTargets : EFRequest

@property (nonatomic,assign) int page;
@property (nonatomic,assign) int size;

@end



#pragma mark  **************优生优育个人中心rest接口******************

/**
 *  提交记录列表
 */
@interface findSubmitRecords : EFRequest

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;

@end


/**
 *  提交风险名词
 */
@interface submitRisk : EFRequest

@property (nonatomic,strong) NSString * name;

@end

/**
 *  提交意见反馈
 */
@interface submitFeedback : EFRequest

@property (nonatomic,strong) NSString * suggestion;

@end

#pragma mark  **************消息管理rest接口******************
/**
 *  我的消息列表
 */
@interface getMyMessages : EFRequest

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;

@end


/**
 *  我的未读消息数量
 */
@interface getUnReadMsgCount : EFRequest

@end

/**
 *  更新消息未读表示
 */
@interface updateUnReadMessaage : EFRequest

/**
 *  更新未读消息标示（参数：消息ID数组是非必传项，未传参数则更新我的所有未读消息为已读）
 */
//@property (nonatomic, strong) NSArray * messaageIds;

@end

/**
 *  获取系统公告消息
 */
@interface getSystemNotice : EFRequest


@end


#pragma mark  **************静态页面rest接口******************
/**
 *  获取静态界面地址
 */
@interface getStaticView : EFRequest

@property (nonatomic, strong)NSString * urlStr;

@end


#pragma mark  **************风险社交rest接口******************
/**
 *  风险社交--获取我的收藏-风险
 */
@interface findMyFavourateTargets_RISK : EFRequest

@property (nonatomic, assign)int page;
@property (nonatomic, assign)int size;

@end

/**
 *  收藏--风险
 */
@interface favourate_RISK : EFRequest

@property (nonatomic, assign)int targetId;

@end

/**
 *  取消搜藏
 */
@interface cancelFavourate_RISK : EFRequest

@property (nonatomic, assign)int targetId;

@end

#pragma mark  **************app版本信息rest接口******************
@interface getNewVersion : EFRequest

@end

#pragma mark  **************销售记录rest接口******************

@interface getMySaleRecord : EFRequest

@property (nonatomic,assign) int page;
@property (nonatomic,assign) int size;

@end


