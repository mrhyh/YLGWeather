//
//  EFMineProfileCell.h
//  EasyFrame_iOS2.0
//
//  Created by MH on 16/5/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFMineProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *profileInputView;
@property (nonatomic, strong) NSDictionary *profileDict;
@property (copy, nonatomic)NSString      * defaultStr;
@end
