//
//  MenuCell.h
//  Mileby
//
//  Created by MH on 16/2/4.
//  Copyright © 2016年 KingYon LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFSideMenuCell : UITableViewCell{
    UIViewController * VC;
}

- (instancetype)initWithTitle:(NSString*)_title Image:(NSString*)_img andSuperVC:(UIViewController *)_vc;

- (instancetype)initWithTitle:(NSString *)_title andSuperVC:(UIViewController *)_vc;

@end
