//
//  AppDelegate+Payment.m
//  Dentist
//
//  Created by HqLee on 16/7/15.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import "AppDelegate+Payment.h"

@implementation AppDelegate (Payment)

//============================================================
//支付流程实现
//============================================================
- (void)sendPay
{
    NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:WEIXIN_Info];
    NSMutableString *stamp  = [dic objectForKey:@"timestamp"];
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [dic objectForKey:@"appid"];
    req.partnerId           = [dic objectForKey:@"partnerid"];
    req.prepayId            = [dic objectForKey:@"prepayid"];
    req.nonceStr            = [dic objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dic objectForKey:@"packages"];
    req.sign                = [dic objectForKey:@"sign"];
    [WXApi sendReq:req];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *urlStr = [url absoluteString];
    if([urlStr containsString:WEIXIN_APPID]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if([urlStr containsString:@"safepay"]){
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"resultDic = %@", resultDic);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"PaySuccessNotification" object:nil];
        }];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlStr = [url absoluteString];
    if (CurrentSystemVersion < 8) {
        if([self myContainsString:WEIXIN_APPID base:urlStr]){
            return [WXApi handleOpenURL:url delegate:self];
        }
        else if([self myContainsString:@"safepay" base:urlStr]){
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"resultDic = %@", resultDic);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PaySuccessNotification" object:nil];
            }];
        }
        
    }else{
        if([urlStr containsString:WEIXIN_APPID]){
            return [WXApi handleOpenURL:url delegate:self];
        }
        else if([urlStr containsString:@"safepay"]){
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"resultDic = %@", resultDic);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PaySuccessNotification" object:nil];
            }];
        }
    }
    
    return YES;
}

- (BOOL)myContainsString:(NSString*)other base:(NSString *)base{
    NSRange range = [base rangeOfString:other];
    return range.length != 0;
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PaySuccessNotificationWX" object:nil];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"retcodeNotification" object:nil];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}
@end