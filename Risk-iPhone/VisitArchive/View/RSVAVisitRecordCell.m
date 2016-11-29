//
//  RSVAVisitRecordCell.m
//  Risk
//
//  Created by ylgwhyh on 16/7/7.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSVAVisitRecordCell.h"
#import "RSFollowUpRecordModel.h"
#import "RSMethod.h"

@interface RSVAVisitRecordCell () {
    
    RSVAVisitRecordCellHeadBlock rsVAVisitRecordCellHeadBlock;
}

@property (nonatomic, strong) KYMHLabel *indexLabel;
@property (nonatomic, strong) KYMHLabel *medicalRecordNumLabel;
@property (nonatomic, strong) KYMHLabel *nameLabel;

@end

@implementation RSVAVisitRecordCell {
    CGFloat cellH;
    UIColor *textColor;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void) setup {
    
    cellH = 44;
    textColor = EF_TextColor_TextColorPrimary;
    CGFloat spaceToTop = 10;
    CGFloat spaceToLeft = 10;
    CGFloat labelH = 20;
    
    _topLineView = [UIView new];
    _topLineView.backgroundColor = EF_TextColor_TextColorDisable;
    _topLineView.hidden = YES; //默认隐藏
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    _indexLabel = [self createLabelWithX:0 width:cellH];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat labelW = (SCREEN_WIDTH/2 - cellH )/2;
    _medicalRecordNumLabel = [self createLabelWithX:cellH width:labelW];
    _nameLabel = [self createLabelWithX:cellH+labelW width:labelW];

    NSArray *views = @[_topLineView,  _indexLabel, _medicalRecordNumLabel, _nameLabel , _bottomLineView];
    [self.contentView sd_addSubviews:views];
    
    _nameLabel.sd_layout
    .topSpaceToView(self.contentView, spaceToTop)
    .leftSpaceToView(self.contentView, spaceToLeft)
    .widthIs (SCREEN_WIDTH/5*4)
    .heightIs(labelH);
    
    _medicalRecordNumLabel.sd_layout
    .topSpaceToView(_nameLabel, spaceToTop)
    .leftSpaceToView(self.contentView, spaceToLeft)
    .widthIs (SCREEN_WIDTH/5*4)
    .heightIs(labelH);
    
    _bottomLineView.sd_layout
//    .bottomSpaceToView(self.cellBGView, 0)
    .topSpaceToView(_medicalRecordNumLabel,spaceToTop)
    .leftSpaceToView(self.contentView, 0)
    .widthIs(SCREEN_WIDTH)
    .heightIs(0.5);
}


- (KYMHLabel *)createLabelWithX:(CGFloat )x width:(CGFloat )width {
    
    KYMHLabel *label = [[KYMHLabel alloc] initWithTitle:nil BaseSize:CGRectMake(x, 0, width, cellH) LabelColor:nil LabelFont:smallFontSize LabelTitleColor:textColor TextAlignment:NSTextAlignmentLeft];
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 0.5, cellH-2)];
//    lineView.backgroundColor = EF_TextColor_TextColorDisable;
//    [label addSubview:lineView];
    
    return label;
}

#pragma mark Set

- (void) setModel:(PatientfollowsModel *)model {
    
    _model = model;
    
    //_indexLabel.text = [NSString stringWithFormat:@"%ld", (long)_numberInteger];
    
    _medicalRecordNumLabel.text = [NSString stringWithFormat:@"随访日期: %@",[RSMethod returnDateStringWithTimestamp: model.flowTime]];
    _nameLabel.text = [NSString stringWithFormat:@"随访结果: %@",model.flowResult];


    //cell高度适配
    UIView *bottomView;
    bottomView = _bottomLineView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}

#pragma mark Button Action

- (void)RSVAVisitRecordCellHeadSelectBlock:(RSVAVisitRecordCellHeadBlock )block{
    
    rsVAVisitRecordCellHeadBlock = block;
}

#pragma mark 重写 setEditing: animated:方法

//-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
//    
//    if (self.editing == editing)
//    {
//        return;
//    }
//    
//    [super setEditing:editing animated:animated];
//    
//    CGFloat moveSpace = 38;
//    
//    //cell本会右移，这里讲其往左边移动30，抵消编辑模式的右移距离
//    if (editing) {
//        
//        [self.cellBGView setFrame:CGRectMake(self.cellBGView.frame.origin.x - moveSpace, self.cellBGView.frame.origin.y, self.cellBGView.frame.size.width, self.cellBGView.frame.size.height)];
//    }
//    else {
//        [self.cellBGView setFrame:CGRectMake(self.cellBGView.frame.origin.x + moveSpace, self.cellBGView.frame.origin.y, self.cellBGView.frame.size.width, self.cellBGView.frame.size.height)];
//    }
//    
//}

@end