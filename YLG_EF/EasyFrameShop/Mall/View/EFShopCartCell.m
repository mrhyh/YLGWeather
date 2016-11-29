//
//  EFShopCartCell.m
//  EF_MallDemo
//
//  Created by ylgwhyh on 16/6/15.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFShopCartCell.h"
#import "EFCartModel.h"
#import "UIButton+TouchAreaInsets.h"

@interface EFShopCartCell ( ) <UITextFieldDelegate>
{
    EFNumberChangedBlock numberAddBlock;
    EFNumberChangedBlock numberCutBlock;
    EFCellSelectedBlock cellSelectedBlock;
}

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) KYMHLabel *nameLabel;
@property (nonatomic, strong) KYMHLabel *priceLabel; //一种商品的总金额
@property (nonatomic, strong) KYMHLabel *numLabel; //商品数量

//选中按钮
@property (nonatomic,retain) UIButton *selectBtn;
//显示照片
@property (nonatomic,retain) UIImageView *efImageView;
@property (nonatomic, strong ) UITextField *textField;

@end

@implementation EFShopCartCell {
    CGFloat nameFontSize;
    CGFloat priceFontSize;
    CGFloat sumLabelFontSize;
    CGFloat spaceToLeft;
    CGFloat selectButtonH;
    CGFloat cellH;
    ShopCartContentModel* _model;
}

#define NUMBERS @"0123456789"

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupMainView];
    }
    return self;
}


#pragma mark - public method
- (void)EFReloadDataWithModel:(ShopCartContentModel*)model {
    _model = model;
    self.nameLabel.text = model.productItem.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%ld",(long)model.productItem.price*(long)model.quantity];
    self.textField.text = [NSString stringWithFormat:@"%ld",(long)model.quantity];
    self.selectBtn.selected = model.select;
    self.numLabel.text =  [NSString stringWithFormat:@"x%ld",(long)model.quantity];
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.productItem.image.url] placeholderImage:nil];
}

- (void)EFNumberAddWithBlock:(EFNumberChangedBlock)block {
    numberAddBlock = block;
}

- (void)EFNumberCutWithBlock:(EFNumberChangedBlock)block {
    numberCutBlock = block;
}

- (void)EFCellSelectedWithBlock:(EFCellSelectedBlock)block {
    cellSelectedBlock = block;
}

- (void)EFShopCartCellTextFieldChange:(EFNumberChangedBlock)block{
    numberAddBlock = block;
}

#pragma mark - 重写setter方法
- (void)setEfNumber:(NSInteger)efNumber {
    _efNumber = efNumber;
    self.textField.text = [NSString stringWithFormat:@"%ld",(long)efNumber];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%ld",(long)_model.productItem.price*(long)efNumber];
    self.numLabel.text =  [NSString stringWithFormat:@"x%ld",(long)efNumber];
}

- (void)setEfSelected:(BOOL)efSelected {
    _efSelected = efSelected;
    self.selectBtn.selected = efSelected;
}

#pragma mark - 按钮点击方法
- (void)selectBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    if (cellSelectedBlock) {
        cellSelectedBlock(button.selected);
    }
}

- (void)addBtnClick:(UIButton*)button {
    
    NSInteger count = [self.textField.text integerValue];
    count++;
    
    if (numberAddBlock) {
        numberAddBlock(count);
    }
}

- (void)cutBtnClick:(UIButton*)button {
    NSInteger count = [self.textField.text integerValue];
    count--;
    if(count <= 0){
        return ;
    }
    
    if (numberCutBlock) {
        numberCutBlock(count);
    }
}

#pragma mark TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}


//只允许输入数字
- (BOOL)validateNumber:(NSString*)number {
    
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (void) textFieldDidChange:(UITextField *) textField {
    NSLog(@"%@",textField.text);
    
    NSInteger count = [self.textField.text integerValue];
    if(count == 0) {  //textField内容为"0"、“000”之类
        _textField.text = @"1";
        count = 1;
    }
    
    if (numberAddBlock) {
        numberAddBlock(count);
    }
}

#pragma mark - 布局主视图
-(void)setupMainView {

    spaceToLeft = 10;
    selectButtonH = 20;
    nameFontSize = 13;
    priceFontSize = 14;
    sumLabelFontSize = 16;
    cellH = 101;
    
    //初始化控件
    _goodImageView = [KYMHImageView new];
    _goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    _goodImageView.layer.borderWidth = 1;
    _goodImageView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.15].CGColor;
    _goodImageView.clipsToBounds = YES;
    
    
    //选中按钮
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setTouchAreaInsets:UIEdgeInsetsMake(20, 20, 20, 0)];
    [_selectBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_pass"]] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_select"]] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    

    _nameLabel = [KYMHLabel new];
    _nameLabel.textColor = EF_TextColor_TextColorPrimary;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text = @"Lebond 电动牙刷三合一";
    _nameLabel.font = Font(nameFontSize);
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/btn_increase"]] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _textField = [UITextField new];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.text = @"1";
    _textField.font = Font(15);
    _textField.delegate = self;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.backgroundColor = RGBColor(225, 230, 233);
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cutBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/btn_decrease"]] forState:UIControlStateNormal];
    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    _priceLabel = [KYMHLabel new];
    _priceLabel.textColor = EF_TextColor_TextColorPrimary;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.font = Font(priceFontSize);
    _priceLabel.text = @"￥599";
    
    
    _numLabel = [KYMHLabel new];
    _numLabel.textColor = EF_TextColor_TextColorSecondary;
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.font = Font(nameFontSize);
    _numLabel.text = @"x1";
    
    _lineView = [UIView new];
    _lineView.backgroundColor = RGBColor(246, 246, 246);
    
    //布局
    NSArray *views = @[addBtn, cutBtn, _textField,_goodImageView, _nameLabel, _priceLabel, _numLabel, _lineView, _selectBtn];
    [self.contentView sd_addSubviews:views];
    UIView *contentView = self.contentView;
    
    _goodImageView.sd_layout
    .leftSpaceToView (contentView, 2*spaceToLeft+selectButtonH)
    .topSpaceToView (contentView, spaceToLeft)
    .widthIs(75)
    .heightIs(75);
    
    _selectBtn.sd_layout
    .leftSpaceToView(contentView, spaceToLeft)
    .centerYEqualToView(_goodImageView)
    .widthIs(selectButtonH)
    .heightIs(selectButtonH);
    
    _nameLabel.sd_layout
    .leftSpaceToView (_goodImageView, spaceToLeft)
    .topEqualToView(_goodImageView)
    .heightIs(20);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH/2];
    
    CGFloat addButtonH = 25;
    
    cutBtn.sd_layout
    .leftSpaceToView (_goodImageView, spaceToLeft)
    .topSpaceToView (_nameLabel, 25)
    .widthIs(addButtonH)
    .heightIs(addButtonH);
    cutBtn.layer.cornerRadius = addButtonH/2;
    
    _textField.sd_layout
    .centerYEqualToView(cutBtn)
    .leftSpaceToView (cutBtn, 5)
    .heightIs(addButtonH)
    .widthIs (70);
    _textField.layer.cornerRadius = 10;
    
    addBtn.sd_layout
    .leftSpaceToView (_textField, 5)
    .centerYEqualToView(cutBtn)
    .widthIs(addButtonH)
    .heightIs(addButtonH);
    addBtn.layer.cornerRadius = addButtonH/2;
    
    _priceLabel.sd_layout
    .rightSpaceToView(contentView, spaceToLeft)
    .topEqualToView(_nameLabel)
    .heightIs(20);
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:70];
    
    
    _numLabel.sd_layout
    .rightSpaceToView(contentView, spaceToLeft)
    .topSpaceToView(_priceLabel, 8)
    .heightIs(20);
    [_numLabel setSingleLineAutoResizeWithMaxWidth:70];
    
    _lineView.sd_layout
    .topSpaceToView(_goodImageView, 10)
    .leftSpaceToView(contentView, spaceToLeft)
    .widthIs(SCREEN_WIDTH-2*spaceToLeft)
    .heightIs(2);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
