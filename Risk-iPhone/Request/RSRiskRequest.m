//
//  RSRiskRequest.m
//  Risk
//
//  Created by ylgwhyh on 16/7/20.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSRiskRequest.h"
#import "RSToolRequest.h"


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation RSRiskRequest

@end

#pragma mark  **************登录rest接口******************

@implementation RSLoginRequest
- (void)startCallBack:(RequestCallBackBlock)_callBack{
    self.urlPath = @"/rest/user/login";
    self.params = @{@"loginname":self.phoneNumber,@"password":self.password,@"md5Code":self.md5Code,@"type":@(self.type)};
    self.httpHeaderFields = @{@"version":@"1.0"};
    [super startCallBack:_callBack];
}

@end

#pragma mark  **************用户管理rest接口******************

#pragma mark 获取我的个人资料
@implementation RSGetMyProfile

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/user/myProfile";
    self.httpHeaderFields = @{@"version":@"1.0",@"token":self.token};
    [super startCallBack:_callBack];
}

@end


@implementation getUserProfileByEasemob

- (void)startCallBack:(RequestCallBackBlock)_callBack {
    self.urlPath = @"/rest/user/getUserProfileByEasemob";
    self.params = @{@"easemobIds":self.easemobIds};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:_callBack];
}

@end

#pragma mark  **************优生优育风险分类rest接口******************

@implementation findAllFDARiskCategory

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskCategory/findAllFDARiskCategory";
    self.params = @{
                    @"page":@(self.page),
                    @"size":@(self.size) };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

@implementation findAllRiskCategory


- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskCategory/findAllRiskCategory";
    //self.params = @{ };
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

@implementation findFDARisk

- (void)startCallBack:(RequestCallBackBlock)callBack{
    
    self.urlPath = @"/rest/riskCategory/findFDARisk";
    self.params = @{@"id":@(self.riskId),
                    @"type":self.type };
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
    
}

@end

@implementation findNextCategory

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskCategory/findNextCategory";
    self.params = @{@"id":@(self.riskId) };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


@implementation findCategoryAllContent

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskCategory/findCategoryAllContent";
    self.params = @{@"id":@(self.riskId) };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


#pragma mark  **************优生优育资料中心rest接口******************



@implementation getAllHealthFiles

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/getAllHealthFiles";
    self.params = @{@"page":@(self.page),
                    @"size":@(self.size)
                    };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


@implementation findRiskFileById

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/findRiskFileById";
    self.params = @{@"id":@(self.riskId),
                    };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


@implementation moreRiskfilesOne

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/moreRiskfilesOne";
    self.params = @{@"id":@(self.riskId),
                    @"page":@(self.page),
                    @"size":@(self.size) };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

@implementation moreRiskfilesTwo

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/moreRiskfilesTwo";
    self.params = @{@"id":@(self.riskId),
                    @"page":@(self.page),
                    @"size":@(self.size) };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


@implementation findHealthByCategory

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/findHealthByCategory";
    self.params = @{@"id":@(self.riskId),
                    @"page":@(self.page),
                    @"size":@(self.size) };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

@implementation findMoreRiskFileByTitleOne

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/findMoreRiskFileByTitleOne";
    self.params = @{@"id":@(self.riskId),
                    @"page":@(self.page),
                    @"size":@(self.size),
                    @"keyWord":self.keyWord};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

@implementation findMoreRiskFileByTitleTwo

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/findMoreRiskFileByTitleTwo";
    self.params = @{@"id":@(self.riskId),
                    @"page":@(self.page),
                    @"size":@(self.size),
                    @"keyWord":self.keyWord};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


@implementation findRiskFileByTitle

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/findRiskFileByTitle";
    self.params = @{
                    @"keyWord":self.keyWord };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


@implementation findAllHealth

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/findAllHealth";
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


@implementation findIndexFiles

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/findIndexFiles";
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


@implementation findRiskfiles

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/findRiskfiles";
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

#pragma mark  **************优生优育统计报表rest接口******************

@implementation findFollowUpRecords

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskStatistics/findFollowUpRecords";
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@(self.page) forKey:@"page"];
    [dic setObject:@(self.size) forKey:@"size"];
    [dic setObject:@(self.isMine) forKey:@"isMine"];
    [dic setObject:@(self.type) forKey:@"type"];
    [dic setObject:self.year forKey:@"year"];
    [dic setObject:self.month forKey:@"month"];
    [dic setObject:@(self.recordsType) forKey:@"recordsType"];
    
    
    if (-1 == self.type ) {
        [dic removeObjectForKey:@"type"];
    }
    if ( [self.year isEqualToString:@"-1"] ) {
        [dic removeObjectForKey:@"year"];
    }
    if ( [self.month isEqualToString:@"-1"] ) {
        [dic removeObjectForKey:@"month"];
    }
    
    self.params = [dic mutableCopy];
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


#pragma mark  **************优生优育风险rest接口******************

@implementation findRiskByKeyWord

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskcontent/findRiskByKeyWord";
    
    self.params = @{@"page":@(self.page),
                    @"size" : @(self.size),
                    @"keyword":self.keyword};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

@implementation findRiskDetails

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskcontent/findRiskDetails";
    
    self.params = @{@"id":@(self.riskId) };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

#pragma mark  **************广告管理rest接口******************
@implementation GetSystemAdvertisementsByPositions

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/advertisement/getSystemAdvertisementsByPositions";
    
    self.params = @{@"position":self.position};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

@implementation updateAdClickCount

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/advertisement/updateAdClickCount";
    
    self.params = @{@"advertisementId":@(self.advertisementId)};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end





#pragma mark  **************优生优育随访档案rest接口******************

@implementation findFollowRecord

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/followUp/findFollowRecord";
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@(self.page) forKey:@"page"];
    [dic setObject:@(self.size) forKey:@"size"];
    [dic setObject:self.year forKey:@"year"];
    [dic setObject:self.month forKey:@"month"];
    [dic setObject:self.risk forKey:@"risk"];
    [dic setObject:self.keyWord forKey:@"keyWord"];
    
    if ([self.keyWord isEqualToString:@"-1"] ) {
        [dic removeObjectForKey:@"keyWord"];
    }
    if ( [self.year isEqualToString:@"-1"] ) {
        [dic removeObjectForKey:@"year"];
    }
    if ( [self.month isEqualToString:@"-1"] ) {
        [dic removeObjectForKey:@"month"];
    }
    if ( [self.risk isEqualToString:@"-1"] ) {
        [dic removeObjectForKey:@"risk"];
    }
    
    self.params = [dic mutableCopy];
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

@implementation saveFollowRecord

- (void)startWithJsonCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/followUp/saveFollowRecord";
    
    self.params = @{
                    @"body":self.json
                    };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startWithJsonCallBack:callBack];
}

@end


@implementation deleteFollowRecord

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/followUp/deleteFollowRecord";
    
    self.params = @{
                    @"patiendId":self.patiendId
                    };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

@implementation getBirthNum
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/followUp/getBirthNum";
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

@implementation updateFollowRecord

- (void)startWithJsonCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/followUp/updateFollowRecord";
    
    self.params = @{
                    @"body":self.json
                    };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startWithJsonCallBack:callBack];
}

@end

#pragma mark  **************优生优育资料中心社交rest接口******************

@implementation cancelFavourite

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/social/cancelFavourite";
    
    self.params = @{
                    @"targetId":@(self.targetId)
                    };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

@implementation cancelPraise

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/social/cancelPraise";
    
    self.params = @{
                    @"targetId":@(self.targetId)
                    };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


@implementation favourate

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/social/favourate";
    
    self.params = @{
                    @"targetId":@(self.targetId)
                    };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


@implementation praise

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/social/praise";
    
    self.params = @{
                    @"targetId":@(self.targetId)
                    };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


@implementation findMyFavourateTargets

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskfiles/social/findMyFavourateTargets";
    
    self.params = @{
                    @"page":@(self.page),
                    @"size":@(self.size)
                    };
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}


@end

#pragma mark  **************优生优育个人中心rest接口******************

/**
 *  提交记录列表
 */
@implementation findSubmitRecords
- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskPersonal/findSubmitRecords";
    
    self.params = @{@"page":@(self.page),@"size":@(self.size)};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


/**
 *  提交风险名词
 */
@implementation submitRisk

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskPersonal/submitRisk";
    
    self.params = @{@"name":self.name};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

/**
 *  提交意见反馈
 */
@implementation submitFeedback

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/riskPersonal/submitFeedback";
    
    self.params = @{@"suggestion":self.suggestion};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

#pragma mark  **************消息管理rest接口******************
/**
 *  我的消息列表
 */
@implementation getMyMessages

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/message/getMyMessages";
    
    self.params = @{@"page":@(self.page),@"size":@(self.size)};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


/**
 *  我的未读消息数量
 */
@implementation getUnReadMsgCount

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/message/getUnReadMsgCount";
    
    self.params = @{};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

/**
 *  更新消息未读表示
 */
@implementation updateUnReadMessaage

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/message/updateUnReadMessaage";
    
    self.params = @{};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

/**
 *  获取系统公告消息
 */
@implementation getSystemNotice : EFRequest

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/message/getSystemNotice";
    
    self.params = @{};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


#pragma mark  **************静态页面rest接口******************
@implementation getStaticView

- (void)startCallBack:(RequestCallBackBlock)callBack{
    NSString * url = [NSString stringWithFormat:@"/rest/staticPage/%@",self.urlStr];
    self.urlPath = url;
    
    self.params = @{};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end


#pragma mark  **************风险社交rest接口******************
/**
 *  风险社交--获取我的收藏-风险
 */
@implementation findMyFavourateTargets_RISK

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/risk/social/findMyFavourateTargets";
    
    self.params = @{@"page":@(self.page),@"size":@(self.size)};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

/**
 *  收藏--风险
 */
@implementation favourate_RISK

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/risk/social/favourate";
    
    self.params = @{@"targetId":@(self.targetId)};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

/**
 *  取消藏
 */
@implementation cancelFavourate_RISK

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/risk/social/cancelFavourite";
    
    self.params = @{@"targetId":@(self.targetId)};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}


@end

#pragma mark  **************app版本信息rest接口******************
@implementation getNewVersion

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/newVersion/getNewVersion";
    
    self.params = @{@"type":@(IS_IPAD?1:2)};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end

#pragma mark  **************销售记录rest接口******************

@implementation getMySaleRecord

- (void)startCallBack:(RequestCallBackBlock)callBack{
    self.urlPath = @"/rest/doctorSaleRecord/getMySaleRecord";
    
    self.params = @{@"":@(self.page),@"":@(self.size)};
    
    self.httpHeaderFields  = [RSToolRequest returnTttpHeaderFieldsWithVersion:@"1.0"];
    [super startCallBack:callBack];
}

@end
