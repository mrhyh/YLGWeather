//
//  KYTableView.m
//  KYiOS
//
//  Created by mini珍 on 15/9/15.
//  Copyright (c) 2015年 mini珍. All rights reserved.
//

#import "KYTableView.h"

@implementation KYTableView
- (instancetype)initWithFrame:(CGRect)frame andUpBlock:(tablePullingUpBlock)_blockUp andDownBlock:(tablePullingDownBlock)_blockDown andStyle:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            _blockUp();
        }];
        
        MJRefreshBackStateFooter * foot = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            _blockDown();
        }];
        
        //        foot.refreshingTitleHidden = YES;
        //        foot.stateLabel.hidden = YES;
        
        
        self.mj_footer = foot;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                   andUpBlock:(tablePullingUpBlock)_blockUp
                 andDownBlock:(tablePullingDownBlock)_blockDown{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            _blockUp();
        }];
        
        MJRefreshBackStateFooter * foot = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            _blockDown();
        }];
        
        //        foot.refreshingTitleHidden = YES;
        //        foot.stateLabel.hidden = YES;
        
        
        self.mj_footer = foot;
    }
    return self;
}

- (void)endLoading{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}
- (void)endNoticeStr{
    [self.mj_footer endRefreshingWithNoMoreData];
}
@end
