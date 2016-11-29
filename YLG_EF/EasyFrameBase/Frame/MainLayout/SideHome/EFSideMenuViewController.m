//
//  MenuVC.m
//  Symiles
//
//  Created by MH on 16/2/17.
//  Copyright © 2016年 KingYon LTD. All rights reserved.
//

#import "EFSideMenuViewController.h"
#import "EFSideMenuCell.h"
#import "AppDelegate.h"



@interface EFSideMenuViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSDictionary *dictionary;
    /**
     *  侧边栏tableview
     */
    UITableView   * table;
    
    /**
     *  侧边栏顶部View
     */
    UIView        * headView;
    KYMHImageView * headImageView;
    KYMHLabel     * nameLB;
    KYMHLabel     * selfLB;
    NSString      * nameStr;
    NSString      * placeholderImage;
    NSString      * mottoStr;
    
    /**
     *  侧边栏底部View
     */
    UIView        * bottomView;
    KYMHImageView * bottomImgView;
    KYMHLabel     * bottomLB;
    NSString      * bottomStr;
    NSString      * bottomImage;
    
    /**
     *  侧边栏选项标题及图片
     */
    NSArray       * titleArray;
    NSArray       * imageArray;
}

/**
 *  用户名，头像，个性签名
 */
@property (strong,nonatomic) NSString * userName;
@property (strong,nonatomic) NSString * headImage;
@property (strong,nonatomic) NSString * motto;

@end

@implementation EFSideMenuViewController

- (instancetype)init {
    
    if (self = [super init]) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EFSideHomeMenuConfig" ofType:@"plist"];
        dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        titleArray = [dictionary objectForKey:@"titleArray"];
        imageArray = [dictionary objectForKey:@"imageArray"];
        
        NSDictionary *bottomDic = [dictionary objectForKey:@"bottomView"];
        bottomStr = [bottomDic objectForKey:@"bottomLB"];
        bottomImage = [bottomDic objectForKey:@"bottomImgView"];
        
        NSDictionary *headDic = [dictionary objectForKey:@"headView"];
        nameStr = [headDic objectForKey:@"nameLB"];
        mottoStr = [headDic objectForKey:@"selfLB"];
        placeholderImage = [headDic objectForKey:@"headImageView"];
    }
    return self;
}

- (void)setUserName:(NSString *)userName HeadImage:(NSString *)headImage {
    self.userName = userName;
    self.headImage = headImage;
    [self refreshTheMenuView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = EF_BGColor_Secondary;
    
    /**
     头部View
     */
    UIColor *topBackColor = HEX_COLOR([dictionary objectForKey:@"topBackColor"]);
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20 + 72*SCREEN_H_RATE)];
    headView.backgroundColor = topBackColor;
    headView.userInteractionEnabled = YES;
    [self.view addSubview:headView];

    headImageView = [[KYMHImageView alloc] initWithImage:Img(@"")
                                            BaseSize:CGRectMake(10 * SCREEN_W_RATE, 20 + 10*SCREEN_H_RATE, 50*SCREEN_W_RATE, 50*SCREEN_W_RATE)
                                      ImageViewColor:[UIColor lightGrayColor]];
    [headImageView RectSize:25*SCREEN_H_RATE SideWidth:0 SideColor:[UIColor clearColor]];
    [headView addSubview:headImageView];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:Img(placeholderImage)];
  
    KYMHButton * headBT = [[KYMHButton alloc] initWithbarButtonItem:self
                                                              Title:@""
                                                           BaseSize:headImageView.frame /*CGRectMake(0, 20, SCREEN_WIDTH, 72*SCREEN_H_RATE)*/
                                                        ButtonColor:[UIColor clearColor]
                                                         ButtonFont:0
                                                   ButtonTitleColor:[UIColor clearColor]
                                                              Block:^{
        [[EFAppManager shareInstance].sideHome navigateToViewControllerWithIndex:0];
    }];
    [headView addSubview:headBT];
    
    nameLB = [[KYMHLabel alloc] initWithTitle:nameStr
                                     BaseSize:CGRectMake(CGRectGetMaxX(headImageView.frame)+10, 20+10*SCREEN_H_RATE, 100*SCREEN_W_RATE, 20*SCREEN_H_RATE)
                                   LabelColor:[UIColor clearColor]
                                    LabelFont:17
                              LabelTitleColor:[UIColor whiteColor]
                                TextAlignment:NSTextAlignmentLeft];
    [headView addSubview:nameLB];
    
    selfLB = [[KYMHLabel alloc]initWithTitle:mottoStr
                                    BaseSize:CGRectMake(CGRectGetMaxX(headImageView.frame)+10, CGRectGetMaxY(nameLB.frame)+5*SCREEN_H_RATE, 150*SCREEN_W_RATE, 30*SCREEN_H_RATE)
                                  LabelColor:[UIColor clearColor]
                                   LabelFont:15
                             LabelTitleColor:[UIColor whiteColor]
                               TextAlignment:NSTextAlignmentLeft];
    [headView addSubview:selfLB];
    
    /**
     底部View
     */
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    bottomView.userInteractionEnabled = YES;
    bottomView.backgroundColor = HEX_COLOR(@"#262626");
    [self.view addSubview:bottomView];
    
    bottomImgView = [[KYMHImageView alloc] initWithImage:Img(bottomImage)
                                                BaseSize:CGRectMake(15,15, 20, 20)
                                          ImageViewColor:[UIColor clearColor]];
    [bottomView addSubview:bottomImgView];
    
    bottomLB = [[KYMHLabel alloc] initWithTitle:bottomStr
                                       BaseSize:CGRectMake(50, 10, 120, 30)
                                     LabelColor:[UIColor clearColor]
                                      LabelFont:13
                                LabelTitleColor:[EFSkinThemeManager getTextColorWithKey:SkinThemeKey_WhiteSecondary]
                                  TextAlignment:NSTextAlignmentLeft];
    [bottomView addSubview:bottomLB];
    
    if ([UIUtil isEmptyStr:bottomImage]) {
        bottomImgView.hidden = YES;
        [bottomLB setFrame:CGRectMake(15, 10, 120, 30)];
    }else {
        bottomImgView.hidden = NO;
        [bottomLB setFrame:CGRectMake(50, 10, 120, 30)];
    }
    
    KYMHButton * bottomBT = [[KYMHButton alloc] initWithbarButtonItem:self
                                                                Title:@""
                                                             BaseSize:CGRectMake(0, 0, 160, 50)
                                                          ButtonColor:[UIColor clearColor]
                                                           ButtonFont:0
                                                     ButtonTitleColor:[UIColor clearColor]
                                                                Block:^{
        [[EFAppManager shareInstance].sideHome navigateToViewControllerWithIndex:7];
    }];
    [bottomView addSubview:bottomBT];
    
    /**
     tableView
     */
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, headView.frame.size.height, SCREEN_WIDTH/5*4, SCREEN_HEIGHT-headView.frame.size.height-50)];
    [self.view addSubview:table];
    table.dataSource = self;
    table.delegate = self;
    table.scrollEnabled =NO;
    table.backgroundColor = EF_BGColor_Secondary;
    table.separatorStyle = UITableViewCellAccessoryNone;
    table.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
}

- (void)refreshTheMenuView {
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.headImage] placeholderImage:Img(placeholderImage)];
    if ([UIUtil isEmptyStr:self.userName]) {
        [nameLB setText:self.userName];
        [selfLB setText:self.motto];
    }else {
        [nameLB setText:nameStr];
        [selfLB setText:mottoStr];
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[EFAppManager shareInstance].sideHome navigateToViewControllerWithIndex:(int)indexPath.row+1];
}
@end
