//
//  MenuCell.m
//  Mileby
//
//  Created by MH on 16/2/4.
//  Copyright © 2016年 KingYon LTD. All rights reserved.
//

#import "EFSideMenuCell.h"

@implementation EFSideMenuCell
//+ (float)heightForReplayModel :(BaiKeDetailsModel *)model{
//    //TODO 计算model所需要的动态高度
//    float minHeight = 70*SCREEN_H_RATE;
//    NSString *str;
//    if (model.commentObject) {
//        if (model.restContent) {
//            str = [NSString stringWithFormat:@"@%@:%@",model.commentObject.restName,model.restContent];
//        }else{
//            str = @"无";
//        }
//    }else{
//        if (model.restContent) {
//            str = [NSString stringWithFormat:@"%@",model.restContent];
//        }else{
//            str = @"无";
//        }
//    }
//    CGSize size = [str sizeWithFont:Font(14) constrainedToSize:CGSizeMake(260 * SCREEN_W_RATE, 2000*SCREEN_H_RATE) lineBreakMode:NSLineBreakByCharWrapping];
//    float height = size.height+50*SCREEN_H_RATE;
//    if (height < minHeight) {
//        height = minHeight;
//    }
//    return height;
//}

- (instancetype)initWithTitle:(NSString*)_title Image:(NSString*)_img andSuperVC:(UIViewController *)_vc{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
    if (self) {
        VC = _vc;
        self.backgroundColor = [UIColor clearColor];
        KYMHImageView * ma = [[KYMHImageView alloc] initWithImage:Img(_img) BaseSize:CGRectMake(15,11, 27, 27) ImageViewColor:[UIColor clearColor]];
        [self addSubview:ma];
        
        KYMHLabel * NocLB = [[KYMHLabel alloc] initWithTitle:_title BaseSize:CGRectMake(57, 9, 120, 30) LabelColor:[UIColor clearColor] LabelFont:15 LabelTitleColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentLeft];
        [self addSubview:NocLB];
        
        self.selectionStyle = 0;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)_title andSuperVC:(UIViewController *)_vc {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
    if (self) {
        VC = _vc;
        self.backgroundColor = EF_BGColor_Secondary;
        
        KYMHLabel * NocLB = [[KYMHLabel alloc] initWithTitle:_title BaseSize:CGRectMake(15, 10, 120, 30) LabelColor:[UIColor clearColor] LabelFont:15 LabelTitleColor:[UIColor whiteColor]  TextAlignment:NSTextAlignmentLeft];
        [self addSubview:NocLB];

        self.selectionStyle = 0;
    }
    return self;
}


@end
