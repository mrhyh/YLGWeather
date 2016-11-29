//
//  RSTableViewController.m
//  Risk
//
//  Created by ylgwhyh on 16/8/9.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSTableViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface RSTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation RSTableViewController{
    UIColor *textColor;
}


#pragma mark DZNEmptyDataSetDelegate

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

- (void ) initData {
    textColor = EF_TextColor_TextColorSecondary;
}

- (void ) initUI {
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: textColor};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

@end
