//
//  EFRiskViewModel.m
//  Risk
//
//  Created by ylgwhyh on 16/7/20.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSRiskViewModel.h"
#import "RSRiskRequest.h"
#import "RSDateCenterModel.h"
#import "RSRiskDetailModel.h"
#import "RSFollowUpRecordModel.h"
#import "HealthEducationDetailsModel.h"


@implementation RSRiskViewModel

#pragma mark  **************优生优育风险分类rest接口******************

/***  获取FDA风险分类所有栏目*/
- (void)findAllFDARiskCategory:(NSInteger )page size:(NSInteger )size {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findAllFDARiskCategory;
    findAllFDARiskCategory *request = [findAllFDARiskCategory requestWithGET];
    request.page = page;
    request.size = size;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _rsRFDAModelArray = [[NSMutableArray alloc] init];
            _rsRFDAModelArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[RSRFDAModel class] json:result.jsonDict[@"content"]];
            for (int i=0; i<_rsRFDAModelArray.count ; i++ ) {
                RSRFDAModel *rsModel = _rsRFDAModelArray[i];
                rsModel.beans = [NSArray yy_modelArrayWithClass:[RSRFDAModel class] json:rsModel.beans];
            }
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  获取风险分类所有栏目*/
- (void)findAllRiskCategory {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findAllRiskCategory;
    findAllRiskCategory *request = [findAllRiskCategory requestWithGET];
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            if ([result.jsonDict[@"status"] intValue] == NetworkModelStatusTypeSuccess) {
                
                _riskBannerModelArray = [[NSMutableArray alloc] init];
                _riskBannerModelArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[RiskBannerModel class] json:result.jsonDict[@"content"]];
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for (int i=0; i<_riskBannerModelArray.count; i++ ) {
                    
                    RiskBannerModel *rbModel = _riskBannerModelArray[i];
                    NSArray <ChildrensModel *>*tempArray = [NSArray yy_modelArrayWithClass:[ChildrensModel class] json:rbModel.childrens];
                    rbModel.childrens = nil;
                    rbModel.childrens = [tempArray mutableCopy];
                    [array addObject:rbModel];
                }
                
                _riskBannerModelArray = nil;
                _riskBannerModelArray = [array mutableCopy];
            }
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  根据fda栏目id和fda类型获取风险因素*/
- (void)findFDARisk:(NSString * )type riskId:(NSInteger) riskId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findFDARisk;
    findFDARisk *request = [findFDARisk requestWithGET];
    request.type = type;
    request.riskId =riskId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _rsFDARiskModelArray = [[NSMutableArray alloc] init];
            _rsFDARiskModelArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[RSFDARiskModel class] json:result.jsonDict[@"content"]];
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  获取下级风险因素列表*/
- (void)findNextCategory:(NSInteger) riskId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findNextCategory;
    findNextCategory *request = [findNextCategory requestWithGET];
    request.riskId =riskId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _childrensModelArray = [[NSMutableArray alloc] init];
            _childrensModelArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[ChildrensModel class] json:result.jsonDict[@"content"]];
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}


/***  获取项目风险因素列表*/
- (void)findCategoryAllContent:(NSInteger) riskId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findCategoryAllContent;
    findCategoryAllContent *request = [findCategoryAllContent requestWithGET];
    request.riskId =riskId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _childrensModelArray = [[NSMutableArray alloc] init];
            _childrensModelArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[ChildrensModel class] json:result.jsonDict[@"content"]];
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}


#pragma mark  **************优生优育资料中心rest接口******************


/***  根据资料id拿到资料详情 */
- (void)findRiskFileById:(NSInteger) riskId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findRiskFileById;
    findRiskFileById *request = [findRiskFileById requestWithGET];
    request.riskId =riskId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _rsDataCenterDetailModel = [RSDataCenterDetailModel yy_modelWithDictionary:result.jsonDict[@"content"]];
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}


/***  根据栏目id获取该分类所有资料(查看更多) 第一级*/
- (void)moreRiskfilesOne:(NSInteger )page size:(NSInteger )size riskId:(NSInteger) riskId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_riskfilesOne;
    moreRiskfilesOne *request = [moreRiskfilesOne requestWithGET];
    request.page = page;
    request.size = size;
    request.riskId =riskId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _rsDateCenterMoreSecondArray = [[NSMutableArray alloc] init];
            _rsDateCenterMoreSecondArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[RSDateCenterModel class] json:result.jsonDict[@"content"]];
            
            for (int i=0; i<_rsDateCenterMoreSecondArray.count; i++ ) {
                
                RSDateCenterModel *dcModel = _rsDateCenterMoreSecondArray[i];
                NSArray <FilesitemsModel *>*tempArray = [NSArray yy_modelArrayWithClass:[FilesitemsModel class] json:dcModel.filesItems];
                dcModel.filesItems = nil;
                dcModel.filesItems = [tempArray mutableCopy];
            }
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  根据栏目id获取该分类所有资料(查看更多) 第二级*/
- (void)moreRiskfilesTwo:(NSInteger )page size:(NSInteger )size riskId:(NSInteger) riskId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_riskfilesTwo;
    moreRiskfilesTwo *request = [moreRiskfilesTwo requestWithGET];
    request.page = page;
    request.size = size;
    request.riskId =riskId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _rsDateCenterMoreModel = [RSDateCenterMoreModel yy_modelWithDictionary:result.jsonDict[@"content"]];
            NSArray *tempArray = [NSArray yy_modelArrayWithClass:[FilesitemsModel class] json:_rsDateCenterMoreModel.content];
            _rsDateCenterMoreModel.content = nil;
            _rsDateCenterMoreModel.content = [tempArray mutableCopy];
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  根据健康分类获取资料列表(查看更多)*/
- (void)findHealthByCategory:(NSInteger )page size:(NSInteger )size riskId:(NSInteger) riskId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findHealthByCategory;
    findHealthByCategory *request = [findHealthByCategory requestWithGET];
    request.page = page;
    request.size = size;
    request.riskId =riskId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _healthModel = [HealthModel yy_modelWithDictionary:result.content];
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  根据关键字搜索资的查看更多 第一级*/
- (void)findMoreRiskFileByTitleOne:(NSInteger )page size:(NSInteger )size riskId:(NSInteger) riskId keyWord:(NSString *)keyWord {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findMoreRiskFileByTitleOne;
    findMoreRiskFileByTitleOne *request = [findMoreRiskFileByTitleOne requestWithGET];
    request.page = page;
    request.size = size;
    request.riskId =riskId;
    request.keyWord = keyWord;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _searchResultSecondArray = [[NSMutableArray alloc] init];
            NSMutableArray * mutableArray = [[NSMutableArray alloc] init];
            mutableArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[RSDateCenterModel class] json:result.jsonDict[@"content"]];
            
            for (int i=0; i<mutableArray.count; i++ ) {
                
                RSDateCenterModel *dcModel = mutableArray[i];
                NSArray <FilesitemsModel *>*tempArray = [NSArray yy_modelArrayWithClass:[FilesitemsModel class] json:dcModel.filesItems];
                dcModel.filesItems = nil;
                dcModel.filesItems = [tempArray mutableCopy];
                
                if (tempArray.count > 0) {
                    [_searchResultSecondArray addObject:dcModel];
                }
            }
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}


/***  根据关键字搜索资的查看更多 第二级*/
- (void)findMoreRiskFileByTitleTwo:(NSInteger )page size:(NSInteger )size riskId:(NSInteger) riskId keyWord:(NSString *)keyWord {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findMoreRiskFileByTitleTwo;
    findMoreRiskFileByTitleTwo *request = [findMoreRiskFileByTitleTwo requestWithGET];
    request.page = page;
    request.size = size;
    request.riskId =riskId;
    request.keyWord = keyWord;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _rsDateCenterMoreModel = [RSDateCenterMoreModel yy_modelWithDictionary:result.jsonDict[@"content"]];
            NSArray *tempArray = [NSArray yy_modelArrayWithClass:[FilesitemsModel class] json:_rsDateCenterMoreModel.content];
            _rsDateCenterMoreModel.content = nil;
            _rsDateCenterMoreModel.content = [tempArray mutableCopy];
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  根据关键字搜索资料*/
- (void)findRiskFileByTitle:(NSString *)keyWord {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findRiskFileByTitle;
    findRiskFileByTitle *request = [findRiskFileByTitle requestWithGET];
    request.keyWord = keyWord;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _searchResultArray = [[NSMutableArray alloc] init];
            NSMutableArray * mutableArray = [[NSMutableArray alloc] init];
            mutableArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[RSDateCenterModel class] json:result.jsonDict[@"content"]];
            
            for (int i=0; i<mutableArray.count; i++ ) {
                
                RSDateCenterModel *dcModel = mutableArray[i];
                NSArray <FilesitemsModel *>*tempArray = [NSArray yy_modelArrayWithClass:[FilesitemsModel class] json:dcModel.filesItems];
                dcModel.filesItems = nil;
                dcModel.filesItems = [tempArray mutableCopy];
                
                if (tempArray.count > 0) {
                    [_searchResultArray addObject:dcModel];
                }
            }
            
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  获取健康教育页内容*/
- (void)findAllHealth {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findAllHealth;
    findAllHealth *request = [findAllHealth requestWithGET];
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _healthArrayModel = [[NSMutableArray alloc] init];
            _healthArrayModel = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[AllHealthModel class] json:result.jsonDict[@"content"]];
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  获取首页展示精品资料列表*/
- (void)findIndexFiles {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findIndexFiles;
    findIndexFiles *request = [findIndexFiles requestWithGET];
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _filesArray = [NSMutableArray array];
            NSArray * array = [NSArray yy_modelArrayWithClass:[RSHomeDataModel class] json:result.content];
            [_filesArray addObjectsFromArray:array];
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  获取资料中心页内容*/

- (void)findRiskfiles {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findRiskfiles;
    findRiskfiles *request = [findRiskfiles requestWithGET];
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _rsDateCenterModelArray = [[NSMutableArray alloc] init];
            _rsDateCenterModelArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[RSDateCenterModel class] json:result.jsonDict[@"content"]];
            
            for (int i=0; i<_rsDateCenterModelArray.count; i++ ) {
                
                RSDateCenterModel *dcModel = _rsDateCenterModelArray[i];
                NSArray <FilesitemsModel *>*tempArray = [NSArray yy_modelArrayWithClass:[FilesitemsModel class] json:dcModel.filesItems];
                dcModel.filesItems = nil;
                dcModel.filesItems = [tempArray mutableCopy];
            }
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}



#pragma mark  **************优生优育统计报表rest接口******************

/***  优生优育统计报表rest接口*/
- (void)findFollowUpRecords:(NSInteger )page size:(NSInteger )size recordsType:(NSInteger) recordsType isMine:(NSInteger )isMine year:(NSString *)year month:(NSString *)month type:(NSInteger )type {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findFollowUpRecords;
    findFollowUpRecords *request = [findFollowUpRecords requestWithGET];
    request.page = page;
    request.size = size;
    request.recordsType = recordsType;
    request.isMine = isMine;
    request.year = year;
    request.month = month;
    request.type = type;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _sreportModel = [RSSReportModel yy_modelWithDictionary:result.jsonDict[@"content"]];
            NSArray *tempArray = [NSArray yy_modelArrayWithClass:[reportModel class] json:_sreportModel.content];
            _sreportModel.content = nil;
            _sreportModel.content = [tempArray mutableCopy];
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

#pragma mark  **************优生优育风险rest接口******************

- (void ) findRiskDetails:(NSInteger ) riskId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findRiskDetails;
    findRiskDetails *request = [findRiskDetails requestWithGET];
    request.riskId = riskId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _rsRiskDetailModel = [RSRiskDetailModel yy_modelWithDictionary:result.jsonDict[@"content"]];
            NSArray <menuLsModel *>*teamArray = [NSArray yy_modelArrayWithClass:[menuLsModel class] json:_rsRiskDetailModel.menuLs];
            _rsRiskDetailModel.menuLs = nil;
            _rsRiskDetailModel.menuLs = [teamArray mutableCopy];
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/*** 全文检索接口*/
- (void ) findRiskByKeyWord:(NSInteger )page size:(NSInteger )size keyword:(NSString *)keyword {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findRiskByKeyWord;
    findRiskByKeyWord *request = [findRiskByKeyWord requestWithGET];
    request.page = page;
    request.size = size;
    request.keyword = keyword;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _rsSearchResultArr = [[NSArray alloc] init];
            _rsSearchResultArr = [NSArray yy_modelArrayWithClass:[RSFDARiskModel class] json:result.jsonDict[@"content"]];
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

#pragma mark  **************优生优育随访档案rest接口******************

- (void ) findFollowRecord:(NSString *)keyWord risk:(NSString *)risk year:(NSString *)year month:(NSString *)month  page:(NSInteger ) page size: (NSInteger )size {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findFollowRecord;
    findFollowRecord *request = [findFollowRecord requestWithGET];
    request.keyWord = keyWord;
    request.risk = risk;
    request.year = year;
    request.month = month;
    request.page = page;
    request.size = size;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
            _rsFollowUpRecordModel = [RSFollowUpRecordModel yy_modelWithDictionary:result.jsonDict[@"content"]];
            
            NSArray <RSVisitArchiveModel *>*teamArray = [NSArray yy_modelArrayWithClass:[RSVisitArchiveModel class] json:_rsFollowUpRecordModel.content];
            
            for (int i=0; i<teamArray.count ; i++ ) {
                
                RSVisitArchiveModel *vaModel = teamArray[i];
                
                NSArray *oneArray = [NSArray yy_modelArrayWithClass:[PatientrisksModel class] json:vaModel.patientRisks];
                NSArray *twoArray = [NSArray yy_modelArrayWithClass:[PatientfollowsModel class] json:vaModel.patientFollows];
                
                vaModel.patientRisks = nil;
                vaModel.patientRisks = [oneArray mutableCopy];
                
                vaModel.patientFollows = nil;
                vaModel.patientFollows = [twoArray mutableCopy];
                
            }
            
            _rsFollowUpRecordModel.content = nil;
            _rsFollowUpRecordModel.content = [teamArray mutableCopy];
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
    
}

- (void ) saveFollowRecord:(NSString *)json {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_saveFollowRecord;
    saveFollowRecord *request = [saveFollowRecord requestWithPOST];
    request.json = json;
    
    [self startWithJsonCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  编辑随访档案*/
- (void ) updateFollowRecord:(NSString *)json {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_updateFollowRecord;
    updateFollowRecord *request = [updateFollowRecord requestWithPOST];
    request.json = json;
    
    [self startWithJsonCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/***  删除随访档案*/
- (void ) deleteFollowRecord: (NSString * )patiendId {
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_deleteFollowRecord;
    deleteFollowRecord *request = [deleteFollowRecord requestWithPOST];
    request.patiendId = patiendId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}


- (void)getBirthNum {
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_getBirthNum;
    getBirthNum *request = [getBirthNum requestWithPOST];
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:efViewControllerCallBackAction];
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

#pragma mark  **************用户管理rest接口******************

- (void )getUserProfileByEasemob: (NSString *)easemobIds callBackBlock:(RequestCallBackBlock )callBackBlock {
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_getUserProfileByEasemob;
    getUserProfileByEasemob *request = [getUserProfileByEasemob requestWithGET];
    request.easemobIds = easemobIds;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _rsEaseMobUserListModel = [RSEaseMobUserListModel yy_modelWithDictionary:result.jsonDict[@"content"]];
            _rsEaseMobUserListModel.content = [NSArray yy_modelArrayWithClass:[HuanXinUserModel class] json:_rsEaseMobUserListModel.content];
        }
        callBackBlock(callBackStatus, result);
        //[self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
    
}
- (void )getUserProfileByEasemob: (NSString *)easemobIds {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_getUserProfileByEasemob;
    getUserProfileByEasemob *request = [getUserProfileByEasemob requestWithGET];
    request.easemobIds = easemobIds;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _rsEaseMobUserListModel = [RSEaseMobUserListModel yy_modelWithDictionary:result.jsonDict[@"content"]];
            _rsEaseMobUserListModel.content = [NSArray yy_modelArrayWithClass:[HuanXinUserModel class] json:_rsEaseMobUserListModel.content];
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}



#pragma mark  **************广告管理rest接口******************

- (void)getSystemAdvertisementsByPositions:(NSString*)_position{
    GetSystemAdvertisementsByPositions * request = [GetSystemAdvertisementsByPositions requestWithPOST];
    request.position = _position;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_getSystemAdvertisementsByPositions];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _advertisArray = [NSMutableArray array];
            NSArray * array = [NSArray yy_modelArrayWithClass:[RSADModel class] json:result.jsonDict[@"content"][@"home"]];
            [_advertisArray addObjectsFromArray:array];
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_getSystemAdvertisementsByPositions Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_getSystemAdvertisementsByPositions];
}

- (void)updateAdClickCount:(int)_advertisementId {
    updateAdClickCount * request = [updateAdClickCount requestWithPOST];
    request.advertisementId = _advertisementId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_updateAdClickCount];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_updateAdClickCount Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_updateAdClickCount];
    
}


#pragma mark  **************优生优育资料中心社交rest接口******************


/**获得所有健康教育资料*/
- (void)getAllHealthFiles:(NSInteger)page size:(NSInteger)size {
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_getAllHealthFiles;
    getAllHealthFiles *request = [getAllHealthFiles requestWithGET];
    request.page = page;
    request.size = size;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _healthEducationDetailsModel = [HealthEducationDetailsModel yy_modelWithJSON:result.jsonDict[@"content"]];
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/**收藏*/
- (void ) favourate:(NSInteger ) targetId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_favourate;
    favourate *request = [favourate requestWithGET];
    request.targetId = targetId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/**取消收藏*/
- (void ) cancelFavourite:(NSInteger ) targetId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_cancelFavourite;
    cancelFavourite *request = [cancelFavourite requestWithGET];
    request.targetId = targetId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/**取消点赞*/
- (void ) cancelPraise:(NSInteger ) targetId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_cancelPraise;
    cancelPraise *request = [cancelPraise requestWithGET];
    request.targetId = targetId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/**点赞*/
- (void ) praise:(NSInteger ) targetId {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_praise;
    praise *request = [praise requestWithGET];
    request.targetId = targetId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/* 获取我收藏的对象列表 **/
- (void)findMyFavourateTargetsWithPage:(int)_page Size:(int)_size {
    findMyFavourateTargets * request  = [findMyFavourateTargets requestWithGET];
    request.page = _page;
    request.size = _size;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_findMyFavourateTargets];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _collecttionFilesModel = [RSMyCollectFilesModel yy_modelWithDictionary:result.jsonDict[@"content"]];
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_findMyFavourateTargets Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_findMyFavourateTargets];
}

#pragma mark  **************优生优育个人中心rest接口******************
/**
 *  提交记录列表
 */
- (void)findSubmitRecordsWithPage:(int)_page size:(int)_size {
    
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_findSubmitRecords;
    findSubmitRecords *request = [findSubmitRecords requestWithGET];
    request.page = _page;
    request.size = _size;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _recordModel = [RSRecordModel yy_modelWithDictionary:result.jsonDict[@"content"]];
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
    
}

/**
 *  提交风险名词
 */
- (void)submitRisk:(NSString *)_name {
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_submitRisk;
    submitRisk *request = [submitRisk requestWithPOST];
    request.name = _name;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

/**
 *  提交意见反馈
 *
 *  @param _suggestion 意见、建议
 */
- (void)submitFeedback:(NSString *)_suggestion {
    EFViewControllerCallBackAction efViewControllerCallBackAction = RSRisk_NS_ENUM_submitFeedback;
    submitFeedback *request = [submitFeedback requestWithPOST];
    request.suggestion = _suggestion;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        
        [self delRequestWithTag:efViewControllerCallBackAction];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        [self.viewController callBackAction:efViewControllerCallBackAction Result:result];
    } Request:request WithTag:(int)efViewControllerCallBackAction];
}

#pragma mark  **************消息管理rest接口******************
/**
 *  我的消息列表
 *
 *  @param _page 页数
 *  @param _size 每页数量
 */
- (void)getMyMessagesWithPage:(int)_page Size:(int)_size {
    getMyMessages * request = [getMyMessages requestWithGET];
    request.page = _page;
    request.size = _size;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_getMyMessages];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _msgModel = [RSMsgMdoel yy_modelWithDictionary:result.jsonDict[@"content"]];
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_getMyMessages Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_getMyMessages];
}

/**
 *  我的未读消息数量
 */
- (void)getUnReadMsgCount{
    getUnReadMsgCount * request = [getUnReadMsgCount requestWithGET];
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_getUnReadMsgCount];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _unReadMsgCount = [result.jsonDict[@"content"] intValue];
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_getUnReadMsgCount Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_getUnReadMsgCount];
}

/**
 *  更新消息未读表示
 */
- (void)updateUnReadMessage{
    updateUnReadMessaage * request = [updateUnReadMessaage requestWithPOST];
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_updateUnReadMessage];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_updateUnReadMessage Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_updateUnReadMessage];
}


/**
 *  获取系统公告消息
 */
- (void)getSystemNotice {
    getSystemNotice * request = [getSystemNotice requestWithGET];
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_getSystemNotice];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _tMsgArray = [NSArray yy_modelArrayWithClass:[MSGContent class] json:result.jsonDict[@"content"]];
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_getSystemNotice Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_getSystemNotice];
    
}

#pragma mark  **************静态页面rest接口******************

/**
 *  获取个人中心静态界面url
 *
 *  @param _urlPath 地址
 */
- (void)getStaticViewUrlWithPath:(NSString * )_urlPath {
    getStaticView * request = [getStaticView requestWithGET];
    request.urlStr = _urlPath;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_getStaticViewPath];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _path = result.jsonDict[@"content"];
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_getStaticViewPath Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_getStaticViewPath];
}


#pragma mark  **************风险社交rest接口******************
/**
 *  取消收藏
 */
- (void)cancelFavouriteRISK:(NSInteger)targetId {
    cancelFavourate_RISK * request = [cancelFavourate_RISK requestWithGET];
    request.targetId = (int)targetId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_cancelFavourate_RISK];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_cancelFavourate_RISK Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_cancelFavourate_RISK];
}

/**
 *  收藏
 */
- (void)favourateRISK:(NSInteger)targetId {
    favourate_RISK * request = [favourate_RISK requestWithGET];
    request.targetId = (int)targetId;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_favourate_RISK];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_favourate_RISK Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_favourate_RISK];
}

/**
 *  获取我的收藏列表
 */
- (void)findMyFavourateTargetsRISKWithPage:(int)_page Size:(int)_size {
    findMyFavourateTargets_RISK * request = [findMyFavourateTargets_RISK requestWithGET];
    request.page = _page;
    request.size = _size;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_findMyFavourateTargets_RISK];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _riskModel = [RSMyCollectRiskModel yy_modelWithDictionary:result.jsonDict[@"content"]];
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_findMyFavourateTargets_RISK Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_findMyFavourateTargets_RISK];
    
    
}

#pragma mark  **************App版本管理rest接口******************
/**
 *  获取app最新版本信息
 */
- (void)getNewVersion {
    getNewVersion * request = [getNewVersion requestWithGET];
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_getNewVersion];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _versionModel = [VersionInfoModel yy_modelWithDictionary:result.jsonDict[@"content"]];
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_getNewVersion Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_getNewVersion];
    
}

#pragma mark  **************销售记录rest接口******************
/**
 *  获取销售记录
 */
- (void)getMySaleRecordWithPage:(int)_page Size:(int)_size {
    getMySaleRecord * request = [getMySaleRecord requestWithGET];
    request.page = _page;
    request.size = _size;
    
    [self startCallBack:^(CallBackStatus callBackStatus, NetworkModel *result) {
        [self delRequestWithTag:RSRisk_NS_ENUM_getMySaleRecord];
        if (callBackStatus == CallBackStatusRequestFailure) {
            
        }else if (callBackStatus == CallBackStatusRequestError){
            
        }else if (callBackStatus == CallBackStatusSuccess){
            _saleMdoel = [SaleModel yy_modelWithDictionary:result.jsonDict[@"content"]];
        }
        [self.viewController callBackAction:RSRisk_NS_ENUM_getMySaleRecord Result:result];
    } Request:request WithTag:RSRisk_NS_ENUM_getMySaleRecord];
}



@end
