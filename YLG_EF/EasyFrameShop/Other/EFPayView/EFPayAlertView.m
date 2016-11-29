//
//  EFPayAlertView.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/16.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFPayAlertView.h"

@interface EFPayAlertView()<UITableViewDelegate,UITableViewDataSource>
//完成的block回调
@property (nonatomic, copy) CompleteBlock completeBlock;
//主视图
@property (strong, nonatomic)KYTableView * table;
//付款类型
@property (nonatomic, copy) NSString * Type;
//
@property (nonatomic, assign) int num;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSArray *imgArray;

//是否需要钱包支付
@property (nonatomic, assign) BOOL isShowWalletPay;

@property (nonatomic, copy) NSString *choose;
@end
@implementation EFPayAlertView
- (instancetype)initWithType:(NSString*)_type andIsShowWalletPay:(BOOL)isShow CallBack:(CompleteBlock)callBack{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.completeBlock = callBack;
        self.Type = _type;
        self.isShowWalletPay = isShow;
        
        WS(weakSelf);
        weakSelf.table = [[KYTableView alloc]initWithFrame:CGRectMake(35, SCREEN_HEIGHT/2-60*SCREEN_H_RATE, SCREEN_WIDTH-70,self.isShowWalletPay ? 160*SCREEN_H_RATE:120*SCREEN_H_RATE
                                                                      ) andUpBlock:^{
            [weakSelf.table endLoading];
        } andDownBlock:^{
            [weakSelf.table endLoading];
        }];
        [self addSubview:weakSelf.table];
        weakSelf.table.dataSource = self;
        weakSelf.table.delegate = self;
        weakSelf.table.scrollEnabled = NO;
        weakSelf.table.layer.masksToBounds = YES;
        weakSelf.table.layer.cornerRadius = 5;
        weakSelf.table.backgroundColor = [UIColor whiteColor];
        weakSelf.table.separatorStyle = UITableViewCellAccessoryNone;
        [weakSelf.table reloadData];
        
        if (isShow == YES) {
            self.array= @[@"关闭",@"我的钱包",@"支付宝",@"微信支付"];
            self.imgArray = @[@"ic_my_wallet",@"ic_payment_alipay",@"ic_payment_wxpay"];
        }else{
            self.array= @[@"关闭",@"支付宝",@"微信支付"];
            self.imgArray = @[@"ic_payment_alipay",@"ic_payment_wxpay"];
        }
        
    }
    return self;
}


#pragma mark TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MineListCell"];
    cell.textLabel.text = self.array[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = EF_TextColor_TextColorDisable;
    [cell addSubview:line];
    if (indexPath.row != 0) {
        line.frame = CGRectMake(15, 40*SCREEN_H_RATE, SCREEN_WIDTH-85, 0.5);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/%@",self.imgArray[indexPath.row-1]]];
    }else{
        line.frame = CGRectMake(0, 40*SCREEN_H_RATE, SCREEN_WIDTH-70, 0.5);
        UIColor * color = EF_TextColor_TextColorLoginPrimary;
        KYMHLabel * redCountLB = [[KYMHLabel alloc] initWithTitle:@"支付" BaseSize:CGRectMake(0, 0, SCREEN_WIDTH-70, 40*SCREEN_H_RATE) LabelColor:[UIColor clearColor] LabelFont:20 LabelTitleColor:color TextAlignment:NSTextAlignmentCenter];
        [cell addSubview:redCountLB];
    }
    return cell;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*SCREEN_H_RATE;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self hidePopupWithAnimate:YES];
    }else{
        self.choose = self.array[indexPath.row];
        UIAlertView * alert1 = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"是否使用%@支付",self.choose] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert1 show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            
        }
            break;
        case 1:{
            [self hidePopupWithAnimate:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                !self.completeBlock? : self.completeBlock(self.choose);
            });
        }
            break;
            
        default:
            break;
    }
}



@end
