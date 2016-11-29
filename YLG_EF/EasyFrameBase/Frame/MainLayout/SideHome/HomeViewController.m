//
//  HomeViewController.m
//  EasyFrame
//
//  Created by MH on 16/4/19.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
- (void)initNavigateView{
    UIView *leftBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 44)];
    UIButton *btn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [btn setImage:Img(@"Menu") forState:UIControlStateNormal];
    [btn setTitle:@"左" forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    [btn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBarView addSubview:btn];

    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
    self.navigationItem.leftBarButtonItem = barBtnItem;
    
    UIView *rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [btn2 setImage:Img(@"Search") forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"右" forState:0];
    [btn2 setTitleColor:[UIColor blackColor] forState:0];
    [rightBarView addSubview:btn2];
    UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBarView];
    self.navigationItem.rightBarButtonItem = myBtn;
}

- (void)leftAction{
    [[EFAppManager shareInstance].sideHome showLeftViewController:YES];
}

- (void)rightAction{
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigateView];
    KYMHLabel *  label = [[KYMHLabel alloc] initWithTitle:@"EasyFrame" BaseSize:CGRectMake(0, 100, SCREEN_WIDTH, 40) LabelColor:[UIColor clearColor] LabelFont:22 LabelTitleColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
