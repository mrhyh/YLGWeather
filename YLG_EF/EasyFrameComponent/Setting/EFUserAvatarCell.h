//
//  EFUserAvatarCell.h
//  EasyFrame_iOS2.0
//
//  Created by MH on 16/5/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFUserAvatarCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *avatarDict;
@property (nonatomic, strong) UIImage *avatarImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@end
