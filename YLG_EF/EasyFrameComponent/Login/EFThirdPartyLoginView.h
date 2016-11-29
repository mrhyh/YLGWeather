//
//  EFThirdPartyLoginView.h
//  demo
//
//  Created by HqLee on 16/5/20.
//  Copyright © 2016年 KingYon LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EFThirdPartyLoginViewDelegate <NSObject>

@optional
//微信按钮点击
- (void)weixinBtnClick;
//微博按钮点击
- (void)weiboBtnClick;
//QQ按钮点击
- (void)QQBtnClick;
//点击Label
- (void)tapThirdPartyLabel;
@end
@interface EFThirdPartyLoginView : UIView
@property (nonatomic, weak) id<EFThirdPartyLoginViewDelegate>delegate;
+ (instancetype)thirdPartyView;
@property (weak, nonatomic) IBOutlet UILabel *thirdPartyLabel;
@end
