////
////  QFPushManager.m
////  QuickFix
////
////  Created by ylgwhyh on 4/20/15.
////  Copyright (c) 2015 KingYon LLC. All rights reserved.
////
//
#import "QFPushManager.h"
#import "AppDelegate.h"
#import "UserModel.h"

#define HideRemindViewNotification @"HideRemindViewNotification" //关闭预约提醒
#define FinishOrder @"FinishOrder"  //订单结束推送

@implementation QFPushManager{
    UIViewController * VC;

}


static QFPushManager * singleton;
+ (QFPushManager *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[QFPushManager alloc] init];
    });
    return singleton;
}

+ (void)handlerPushNotification : (NSDictionary *)_noti {
    [[QFPushManager shareInstance] handlerPushNotification:_noti];
}

- (void)handlerPushNotification : (NSDictionary *)_noti{
    pushType = 0;
    int logicID = 0;
    extra = 0;
    NSString *message = @"";
    NSLog(@"------------------notification-----------%@",_noti);
    if ([[_noti allKeys] containsObject:@"custom"]) {
        //NSString * customKey = [_noti objectForKey:@"custom"];
        NSDictionary * dic = @{};
        if ([dic count] > 0 && [dic objectForKey:@"type"]) {
            pushType = [[dic objectForKey:@"type"] intValue];
            logicID = [[dic objectForKey:@"notice_id"] intValue];
            extra = [[dic objectForKey:@"extra"] intValue];
        }
    }
    else if ([[_noti allKeys] containsObject:@"aps"] && [[_noti allKeys] containsObject:@"type"]) {
        pushType = [[_noti objectForKey:@"type"] intValue];
        logicID = [[_noti objectForKey:@"notice_id"] intValue];
        message = [[_noti objectForKey:@"aps"] objectForKey:@"alert"];
        extra = [[_noti objectForKey:@"extra"] intValue];
    }
    
    NSMutableDictionary *notificaiton = [NSMutableDictionary dictionary];
    [notificaiton setObject:[NSString stringWithFormat:@"%d",pushType] forKey:@"type"];
    [notificaiton setObject:[NSString stringWithFormat:@"%d",logicID] forKey:@"logicID"];
    [notificaiton setObject:message forKey:@"alert"];
    self.ID = [notificaiton objectForKey:@"logicID"];
    self.RestName = [_noti objectForKey:@"restName"];
    
    
    switch (pushType) {
        case RiskPushType_UpdateDrugInformation:
        case XMPushType_InviteBecomeRecommend:
        case XMPushType_UserIdentityCardNumberSame:
        case XMPushType_CancelAuthForCar:
        case XMPushType_AuthForCarDriving:
        case XMPushType_DriverLisenseReject:
        case XMPushType_CarLisenseReject:
        case XMPushType_CancelStroke:
        case XMPushType_DriverUpcomingTrip:
        case XMPushType_StrokeAccepted:
        case XMPushType_Lock:
        case XMPushType_Open:
        case XMPushType_DesignateDrivingAccepted:
        case XMPushType_CarAudiPass:
        case XMPushType_DrivingLicenseAudiPass:
        case XMPushType_OrderFinish:
        case XMPushType_RealNameNOPass: {
        }
            break;
            
        default:
            break;
    }
    
    /* 请勿删除，暂不弹出AlertViewController那样的提示
    if (pushType == XMPushType_OrderFinish) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FinishOrder object:nil];
    }else if (pushType == XMPushType_CancelStroke ||
              pushType == XMPushType_OrderBeging  ||
              pushType == XMPushType_CarAudiPass  ||
              pushType == XMPushType_DrivingLicenseAudiPass ||
              pushType == XMPushType_DesignateDrivingBegin) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新消息提醒" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新消息提醒" message:message delegate:self cancelButtonTitle:@"查看" otherButtonTitles:@"忽略", nil];
        [alert show];
    }
    */
    
//#warning 后台走了，测试使用
//    
//#ifdef DEBUG
//    pushType = 0;
//#endif
    
    if (pushType == RiskPushType_UpdateDrugInformation) {
        [self setTabBarItemBadge];
    }else if (pushType == XMPushType_Lock) {

    }else if (pushType == XMPushType_Open) {

    }else if (pushType == XMPushType_RealNameNOPass) {

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        switch (pushType) {
            case RiskPushType_UpdateDrugInformation:
            {
                
            }break;
                
            default:
                break;
        }
    }
}

- (void)setTabBarItemBadge {
    [UserModel ShareUserModel].isDurgUpdate = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:MF_Notification_DrugInformationUpdate object:nil];
}
@end
