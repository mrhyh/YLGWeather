//
//  QFPushManager.h
//  QuickFix
//
//  Created by ylgwhyh on 
//  Copyright (c) 2015 KingYon LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RiskPushType_UpdateDrugInformation = 0,           //更新药品信息
    XMPushType_InviteBecomeRecommend = 1,           //邀请自己成为推荐人
    XMPushType_UserIdentityCardNumberSame = 2,      //自己的身份证号被用的时候的通知
    XMPushType_CancelAuthForCar = 3,                //汽车，取消了对我的授权，
    XMPushType_AuthForCarDriving = 4,               //有汽车对我进行了授权
    XMPushType_DriverLisenseReject = 5,             //驾照审核未通过的通知
    XMPushType_CarLisenseReject = 6,                //汽车审核未通过的通知
    XMPushType_CancelStroke = 7,                    //预约被取消
    
    XMPushType_DriverUpcomingTrip = 11,          //您有一个行程即将开始
    XMPushType_StrokeAccepted = 12,              //您的预约行程已经被接受(司机接受预约后发送给乘客的)
    XMPushType_Lock = 13,                         //账号被冻结
    XMPushType_Open = 14,                       //账号解冻
    
    XMPushType_OrderFinish = 15,            //订单完成
    XMPushType_OrderBeging = 16,            //订单激活
    
    XMPushType_DesignateDrivingAccepted = 17,   //代驾被接受
    XMPushType_DesignateDrivingBegin = 18,      //代驾激活
    
    XMPushType_CarAudiPass = 19,     //车辆审核通过
    XMPushType_DrivingLicenseAudiPass = 20,   //驾照审核通过
    XMPushType_RealNameNOPass = 21,    //实名认证不通过
    
}XMPushType;

typedef enum {                                    //type为12时，1表示乘客发布，2表示司机发布，3表示找代驾，4--帮代驾
    isPassenger = 1,
    isDriver = 2,
    isReplace = 3,
    isHelp = 4,
}XMPushType_Extra;

@interface QFPushManager : NSObject<UIAlertViewDelegate>{
    XMPushType pushType;
    XMPushType_Extra extra;
}
+ (QFPushManager *)shareInstance;
+ (void)handlerPushNotification : (NSDictionary *)_noti;
@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)NSString *RestName;
//@property(nonatomic,strong)Page_NoticeQuestionDetailsModel * pageModel;

@end
