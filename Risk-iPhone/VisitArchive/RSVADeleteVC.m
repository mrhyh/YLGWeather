//
//  RSVADeleteVC.m
//  Risk
//
//  Created by ylgwhyh on 16/7/28.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSVADeleteVC.h"

@interface RSVADeleteVC ()

@end

@implementation RSVADeleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark initUI

- (void) initUI {
    
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    testButton.backgroundColor = [UIColor blueColor];
    testButton.backgroundColor = [UIColor redColor];
    [testButton setTitle:@"删除" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    self.view.frame = CGRectMake(0, 0, 100, 50);
}

- (void ) testButtonAction {
    
    WS(weakSelf)
    if ([self.delegate respondsToSelector:@selector(archiveDelete)] ) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"确定要删除当前患者的档案资料吗？"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.delegate rsva_dismissSelf];
            
            if ([weakSelf.delegate respondsToSelector:@selector(rsva_dismissSelf)]) {
                [weakSelf.delegate rsva_dismissSelf];
            }
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([weakSelf.delegate respondsToSelector:@selector(archiveDelete)]) {
                [weakSelf.delegate archiveDelete];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
@end
