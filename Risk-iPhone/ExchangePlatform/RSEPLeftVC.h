//
//  RSEPLeftVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RSEPLeftVC, RiskTypeModel;

@protocol RSEPLeftVCDelegate <NSObject>

@optional

- (void)rsEPLeftVC:(RSEPLeftVC *)RSEPLeftVC didSelectedRSEPLeftVC:(RiskTypeModel *)model;

@end

@interface RSEPLeftVC : UITableViewController

@property (nonatomic, weak) id <RSEPLeftVCDelegate > delegate;


@end