//
//  RSVADeleteVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/28.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "EFBaseViewController.h"

@class RSVADeleteVC;
@protocol RSVADeleteVCDelegate <NSObject>

@optional

- (void)archiveDelete;
- (void)rsva_dismissSelf;

@end

@interface RSVADeleteVC : EFBaseViewController

@property (nonatomic, weak) id <RSVADeleteVCDelegate >delegate;

@end
