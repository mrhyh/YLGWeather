//
//  RSSRLeftVC.h
//  Risk
//
//  Created by ylgwhyh on 16/7/12.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSRLeftVC, RiskTypeModel;

@protocol RSSRLeftVCDelegate <NSObject>

@optional

- (void)rsSRLeftVC:(RSSRLeftVC *)RSSRLeftVC didSelectedRSSRLeftVC:(RiskTypeModel *)model;

@end

@interface RSSRLeftVC : UITableViewController

@property (nonatomic, weak) id <RSSRLeftVCDelegate> delegate;


@end




