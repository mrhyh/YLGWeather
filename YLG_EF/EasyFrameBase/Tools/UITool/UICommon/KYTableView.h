//
//  KYTableView.h
//  KYiOS
//
//  Created by mini珍 on 15/9/15.
//  Copyright (c) 2015年 mini珍. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

#if NS_BLOCKS_AVAILABLE
typedef void (^tablePullingUpBlock)(void);
typedef void (^tablePullingDownBlock)(void);
#endif

@interface KYTableView : UITableView


- (instancetype)initWithFrame:(CGRect)frame
                   andUpBlock:(tablePullingUpBlock)_blockUp
                 andDownBlock:(tablePullingDownBlock)_blockDown;

- (instancetype)initWithFrame:(CGRect)frame andUpBlock:(tablePullingUpBlock)_blockUp andDownBlock:(tablePullingDownBlock)_blockDown andStyle:(UITableViewStyle )style;

- (void)endLoading;
- (void)endNoticeStr;
@end
