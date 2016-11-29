//
//  RSHuanXinVC.h
//  Risk
//
//  Created by ylgwhyh on 16/8/4.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSHuanXinVC : UIViewController

+ (void  ) rs_asyncJoinPublicGroup;

+ (void ) rs_loginEasemob ;

/**
 *  设置推送昵称
 */
+ (void)rs_asyncSetApnsNickname;

@end
