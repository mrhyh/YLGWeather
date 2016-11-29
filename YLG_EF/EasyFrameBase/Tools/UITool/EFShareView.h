//
//  EFShareView.h
//  QuickFlip
//
//  Created by KingYon on 15/5/9.
//  Copyright (c) 2015年 KingYon LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#if NS_BLOCKS_AVAILABLE
typedef void (^shareViewCallBack)(BOOL isMore);
#endif
@interface EFShareView : UIView
@property (nonatomic,assign)BOOL isShareHidden;
@property (strong, nonatomic)shareViewCallBack  callBack;
+ (EFShareView *)shareInstance;
- (void)openShareView;
- (void)openShareViewWithContent : (NSDictionary *)_content CallBack:(shareViewCallBack)callBack;


@end
