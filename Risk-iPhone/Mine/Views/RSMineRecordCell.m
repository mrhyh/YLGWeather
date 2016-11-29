//
//  RSMineRecordCell.m
//  Risk
//
//  Created by Cherie Jeong on 16/7/15.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSMineRecordCell.h"

@interface RSMineRecordCell ()

@property (nonatomic,strong) KYMHLabel * leftLB;
@property (nonatomic,strong) KYMHLabel * rightLB;
@property (nonatomic,strong) KYMHLabel * beginTimeLB;
@property (nonatomic,strong) KYMHLabel * finishTimeLB;

@end

@implementation RSMineRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setUp {
    
    _leftLB = [[KYMHLabel alloc]init];
    _leftLB.font = Font(15);
    _leftLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackNormal];
    _leftLB.textAlignment = NSTextAlignmentLeft;
    _leftLB.backgroundColor = [UIColor clearColor];
    
    _rightLB = [[KYMHLabel alloc]init];
    _rightLB.font = Font(15);
    _rightLB.textAlignment = NSTextAlignmentCenter;
    
    _beginTimeLB = [[KYMHLabel alloc]init];
    _beginTimeLB.font = Font(13);
    _beginTimeLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    _beginTimeLB.textAlignment = NSTextAlignmentLeft;
    _beginTimeLB.backgroundColor = [UIColor clearColor];
    
    _finishTimeLB = [[KYMHLabel alloc]init];
    _finishTimeLB.font = Font(13);
    _finishTimeLB.textColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackSecondary];
    _finishTimeLB.textAlignment = NSTextAlignmentRight;
    _finishTimeLB.backgroundColor = [UIColor clearColor];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [EFSkinThemeManager getTextColorWithKey:SkinThemeKey_BlackDivider];
    
    NSArray * views = @[_leftLB,_rightLB,_beginTimeLB,_finishTimeLB,line];
    UIView * contentView = self.contentView;
    [contentView sd_addSubviews:views];
    
    CGFloat lbW = (contentView.frame.size.width-20)/2;
    
    CGFloat spaceToTop = 15;
    
    _leftLB.sd_layout
    .leftSpaceToView(contentView,10)
    .topSpaceToView(contentView,spaceToTop)
    .widthIs(200)
    .heightIs(20);
    
    _rightLB.sd_layout
    .rightSpaceToView(contentView,10)
    .topEqualToView(_leftLB)
    .widthIs(100)
    .heightIs(20);
    _rightLB.sd_cornerRadius = [NSNumber numberWithInt:4];
    
    _beginTimeLB.sd_layout
    .leftSpaceToView(contentView,10)
    .bottomSpaceToView(contentView,spaceToTop)
    .heightIs(20)
    .widthIs(lbW);
    
    _finishTimeLB.sd_layout
    .rightSpaceToView(contentView,10)
    .bottomSpaceToView(contentView,10)
    .heightIs(20)
    .widthIs(lbW);
    
    line.sd_layout
    .leftSpaceToView(contentView,10)
    .bottomEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(0.5);
    
}

- (void)setModel:(Record *)model {
    _model = model;
    
    _leftLB.text  = model.conent;
    if ([_model.status intValue] == 0) {
        _rightLB.text = @"未处理";
        _rightLB.textColor = [UIColor colorWithHexString:@"#FF7F00"];
        _rightLB.backgroundColor = [UIColor colorWithHexString:@"#FFEC8B"];
    }else if ([_model.status intValue] == 1) {
        _rightLB.text = @"已经收录";
        _rightLB.textColor = [UIColor colorWithHexString:@"#90EE90"];
        _rightLB.backgroundColor = [UIColor colorWithHexString:@"#008B00"];
        _finishTimeLB.text = [NSString stringWithFormat:@"处理日期:%@",[UIUtil getDateFromMiao:[NSString stringWithFormat:@"%lld",_model.handleTime]]];
    }else {
        _rightLB.text = @"驳回收录";
        _rightLB.textColor = EF_MainColor;
        _rightLB.backgroundColor = [UIColor colorWithHexString:@"#87CEFA"];
        _finishTimeLB.text = [NSString stringWithFormat:@"处理日期:%@",[UIUtil getDateFromMiao:[NSString stringWithFormat:@"%lld",_model.handleTime]]];
    }
    
    
    
    
    _beginTimeLB.text = [NSString stringWithFormat:@"提交日期:%@",[UIUtil getDateFromMiao:[NSString stringWithFormat:@"%lld",_model.submitTime]]];
    
}

@end
