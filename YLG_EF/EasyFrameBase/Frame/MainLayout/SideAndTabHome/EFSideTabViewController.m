//
//  EFSideTabViewController.m
//  Risk-iPhone
//
//  Created by Cherie Jeong on 16/9/8.
//  Copyright © 2016年 Cherie Jeong. All rights reserved.
//

#import "EFSideTabViewController.h"
#import "EFSideMenuCell.h"
#import "AppDelegate.h"

@interface EFSideTabViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSDictionary *dictionary;
    /**
     *  侧边栏tableview
     */
    UITableView   * table;
    
    /**
     *  侧边栏选项标题及图片
     */
    NSArray       * titleArray;
    NSArray       * imageArray;
    
}

@end

@implementation EFSideTabViewController

- (instancetype)init {
    
    if (self = [super init]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EFSideHomeMenuConfig" ofType:@"plist"];
        dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        titleArray = [dictionary objectForKey:@"titleArray"];
        imageArray = [dictionary objectForKey:@"imageArray"];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = EF_BGColor_Secondary;
    self.view.backgroundColor = [UIColor colorWithPatternImage:Img(@"beijing")];
//    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)];
//    backView.backgroundColor = EF_BGColor_Secondary;
//    backView.userInteractionEnabled = YES;
//    [self.view addSubview:backView];

    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH/2, SCREEN_HEIGHT-64)];
    table.dataSource = self;
    table.delegate = self;
    table.scrollEnabled =NO;
    //table.backgroundColor = EF_BGColor_Secondary;
    table.separatorStyle = UITableViewCellAccessoryNone;
    table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    table.backgroundColor = [UIColor colorWithPatternImage:Img(@"beijing")];
    [self.view addSubview:table];
    
    //table.backgroundColor = [UIColor whiteColor];
}

#pragma mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIndeter = @"MenuCell";
    EFSideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndeter];
    if (!cell) {
        if (imageArray.count > 0) {
            cell = [[EFSideMenuCell alloc]initWithTitle:titleArray[indexPath.row] Image:imageArray[indexPath.row] andSuperVC:self];
        }else {
            cell = [[EFSideMenuCell alloc]initWithTitle:titleArray[indexPath.row] andSuperVC:self];
        }
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (CGRectGetHeight(table.frame) < titleArray.count*50) {
        table.scrollEnabled = YES;
    }else {
        table.scrollEnabled = NO;
    }
    
    return titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[EFAppManager shareInstance].sideAndTabHome navigateToViewControllerWithIndex:(int)indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
