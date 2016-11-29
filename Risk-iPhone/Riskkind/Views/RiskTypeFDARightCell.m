//
//  RiskTypeFDARightCell.m
//  Risk
//
//  Created by ylgwhyh on 16/7/5.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RiskTypeFDARightCell.h"
#import "UIUtil.h"

@interface RiskTypeFDARightCell ()

@property (nonatomic, strong) KYMHImageView *leftImageView;
@property (nonatomic, strong) KYMHLabel *topLabel;
@property (nonatomic, strong) KYMHLabel *bottomLabel;

@property (nonatomic, copy) NSMutableAttributedString *attributedText;

@end

@implementation RiskTypeFDARightCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void) setup {
    
    _leftImageView = [KYMHImageView new];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    _leftImageView.clipsToBounds = YES;
    _leftImageView.image = Img(@"search_dataImg");
    
    _indicatorImageView = [UIImageView new];
    _indicatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    _indicatorImageView.clipsToBounds = YES;
    _indicatorImageView.image = Img(@"into_img");
    
    _topLabel = [KYMHLabel new];
    _topLabel.font = Font(smallFontSize);
    _topLabel.textColor = EF_TextColor_TextColorPrimary;
    _topLabel.textAlignment = NSTextAlignmentLeft;
    
    _bottomLabel = [KYMHLabel new];
    _bottomLabel.font = Font(smallFontSize-2);
    _bottomLabel.textColor = EF_TextColor_TextColorSecondary;
    _bottomLabel.textAlignment = NSTextAlignmentLeft;
    
    _lineView = [UIView new];
    _lineView.backgroundColor = EF_TextColor_TextColorDisable;
    
    
    NSArray *views = @[_leftImageView, _topLabel, _bottomLabel, _lineView, _indicatorImageView];
    
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    
    CGFloat spaceToLeft = 20;
    
    _leftImageView.sd_layout
    .topSpaceToView(contentView, 10)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(16)
    .heightIs(20);
    
    _indicatorImageView.sd_layout
    .centerYEqualToView(contentView)
    .rightSpaceToView(contentView, 10)
    .widthIs(10)
    .heightIs(16);
    
    _topLabel.sd_layout
    .topEqualToView(_leftImageView)
    .leftSpaceToView(_leftImageView, 10)
    .rightSpaceToView(contentView, spaceToLeft)
    .maxHeightIs(40)
    .autoHeightRatio(0);
    
    _bottomLabel.sd_layout
    .topSpaceToView(_topLabel, 5)
    .leftEqualToView(_topLabel)
    .rightSpaceToView(contentView, 2 * spaceToLeft)
    .maxHeightIs(30)
    .autoHeightRatio(0);
//    [_bottomLabel setMaxNumberOfLinesToShow:2];
    
    _lineView.sd_layout
    .topSpaceToView(_bottomLabel, 10)
    .leftSpaceToView(contentView, spaceToLeft)
    .rightSpaceToView(contentView, spaceToLeft/2)
    .heightIs(0.5);
}

//普通
- (void) setModel:(RSFDARiskModel *)model {
    
    _model = model;
    _model.name = [self rs_stringByReplacingOccurrencesOfString:_model.name];
     _model.otherName = [self rs_stringByReplacingOccurrencesOfString:_model.otherName];
    
    if ([_model.stype isEqualToString:@"file"]) {
        NSString * textStr = [NSString stringWithFormat:@"%@  %@",_model.name,_model.categoryShowName];
        
        NSString * sizeStr = @"";
        if (_model.size < 1024) {
            sizeStr = [NSString stringWithFormat:@"%d b",_model.size];
        }else if(_model.size < 1024*1024){
            sizeStr = [NSString stringWithFormat:@"%.2f Kb",_model.size/1024.0];
        }else {
            sizeStr = [NSString stringWithFormat:@"%.2f Mb",_model.size/(1024*1024.0)];
        }
        if ([UIUtil isEmptyStr:self.keyWord]) {
            _topLabel.text = textStr;
            _bottomLabel.text = [NSString stringWithFormat:@"大小：%@",sizeStr];
        }else {
            _topLabel.attributedText = [self setKeyWord:self.keyWord text:textStr fontSize:smallFontSize+1];
            _bottomLabel.attributedText = [self setKeyWord:self.keyWord text:[NSString stringWithFormat:@"大小：%@",sizeStr] fontSize:smallFontSize-2];
        }
    }else {
        NSString * textStr = [NSString stringWithFormat:@"%@(%@)  %@  FDA分类:  %@",_model.name,_model.englishName,_model.categoryShowName, _model.fdaType];
        if ([UIUtil isEmptyStr:_model.fdaType]) {
            textStr = [NSString stringWithFormat:@"%@(%@)  %@",_model.name,_model.englishName,_model.categoryShowName];
        }
        
        if ([UIUtil isEmptyStr:_keyWord] ) {
            _topLabel.text = textStr;
            _bottomLabel.text = _model.otherName;
        }else {  // 是从搜索界面进入的
            
            _topLabel.attributedText = [self setKeyWord:self.keyWord text:textStr fontSize:smallFontSize+1];
            _bottomLabel.attributedText = [self setKeyWord:self.keyWord text:_model.otherName fontSize:smallFontSize-2];
        }
    }
    
    
    
    //适配
    UIView *bottomView;
    bottomView = _lineView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}

//历史记录
- (void)setHistroyModel:(RSFDARiskModel *)histroyModel {
    _histroyModel = histroyModel;
    
    _histroyModel.name = [self rs_stringByReplacingOccurrencesOfString:_histroyModel.name];
    _histroyModel.otherName = [self rs_stringByReplacingOccurrencesOfString:_histroyModel.otherName];
    NSString * textStr = [NSString stringWithFormat:@"%@(%@)  %@  FDA分类:  %@",_histroyModel.name,_histroyModel.englishName,_histroyModel.categoryShowName, _histroyModel.fdaType];
    
    if ([UIUtil isEmptyStr:_histroyModel.fdaType]) {
        textStr = [NSString stringWithFormat:@"%@(%@)  %@",_histroyModel.name,_histroyModel.englishName,_histroyModel.categoryShowName];
    }
    _topLabel.text = textStr;
    _bottomLabel.text = _histroyModel.otherName;
    
    
    //适配
    UIView *bottomView;
    bottomView = _lineView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}


//资讯
- (void)setFileModel:(RSFDARiskModel *)fileModel {
    _fileModel = fileModel;
    
    _fileModel.name = [self rs_stringByReplacingOccurrencesOfString:_fileModel.name];
    
    NSString * sizeStr = @"";
    if (_fileModel.size < 1024) {
        sizeStr = [NSString stringWithFormat:@"%d b",_fileModel.size];
    }else if(_fileModel.size < 1024*1024){
        sizeStr = [NSString stringWithFormat:@"%.2f Kb",_fileModel.size/1024.0];
    }else {
        sizeStr = [NSString stringWithFormat:@"%.2f Mb",_fileModel.size/(1024*1024.0)];
    }
    if ([UIUtil isEmptyStr:self.keyWord]) {
        _topLabel.text = _fileModel.name;
        _bottomLabel.text = [NSString stringWithFormat:@"%@      大小：%@",_fileModel.categoryShowName,sizeStr];
    }else {
        _topLabel.attributedText = [self setKeyWord:self.keyWord text:_fileModel.name fontSize:smallFontSize+1];
        _bottomLabel.attributedText = [self setKeyWord:self.keyWord text:[NSString stringWithFormat:@"%@      大小：%@",_fileModel.categoryShowName,sizeStr] fontSize:smallFontSize-2];
    }
    
    //适配
    UIView *bottomView;
    bottomView = _lineView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:0];
}

- (NSString * ) rs_stringByReplacingOccurrencesOfString:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
    return string;
}

- (void)setKeyWord:(NSString *)keyWord {
    _keyWord = keyWord;
}

#pragma mark 高亮判断

/**
 *  返回关键字在字符串中的位置
 *
 *  @param keyWord 关键字
 *  @param text    字符串
 *
 *  @return
 */
- (NSMutableAttributedString *) setKeyWord:(NSString *)keyWord text:(NSString *)text fontSize:(CGFloat )fontSize
{
    _keyWord = keyWord;
    
    NSString *keyChar = keyWord;
    
    NSRange range;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    NSStringCompareOptions mask = NSCaseInsensitiveSearch | NSNumericSearch;
    
    if ([self IsChinese:keyWord].count) {
        
        for (NSString *keyChinese in [self IsChinese:keyWord]) {
            
            range = [text rangeOfString:keyChinese options:mask];
            
            while (range.length) {
                [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor],   NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} range:range];
                range = [text rangeOfString:keyChinese options:mask range:(NSRange){range.location + range.length, text.length - range.location - range.length}];
            }
            
            keyChar = [keyChar stringByReplacingOccurrencesOfString:keyChinese withString:@""];
        }
    }
    
    keyChar = [keyChar stringByReplacingOccurrencesOfString:@" " withString:@""];
    range = [text rangeOfString:keyChar options:mask];
    
    while (range.length) {
        [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor],   NSFontAttributeName : [UIFont systemFontOfSize:14]} range:range];
        range = [text rangeOfString:keyChar options:mask range:(NSRange){range.location + range.length, text.length - range.location - range.length}];
    }
    
    return attributeString;
}


//判断字符串中是否含有中文字符
- (NSArray *)IsChinese:(NSString *)str
{
    NSArray *chineses;
    NSMutableArray *mChineses = [NSMutableArray array];
    
    for (int i = 0; i < [str length]; ++i)
    {
        int a = [str characterAtIndex:i];
        
        if (a > 0x4e00 && a < 0x9fff)
        {
            [mChineses addObject:[str substringWithRange:(NSRange){i, 1}]];
        }
    }
    
    chineses = mChineses;
    return chineses;
}

@end
