//
//  EFSelecteSpecificationView.m
//  EF_MallDemo
//
//  Created by HqLee on 16/6/23.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFSelecteSpecificationView.h"

static CGFloat const kAnimationDuration = 0.25f;
static CGFloat const kSelectBtnH = 30;
static CGFloat const kMargin = 10;

@interface EFSelecteSpecificationView()
//弹出视图
@property (nonatomic, weak) UIView *popView;
//价格Label
@property (nonatomic, weak) UILabel *priceLabel;
//商品的图片
@property (nonatomic, weak) UIImageView *iconView;
//产品名字
@property (nonatomic, weak) UILabel *productNameLabel;
//产品价格
@property (nonatomic, weak) UILabel *productPriceLabel;
//滚动视图
@property (nonatomic, weak) UIScrollView *scrollView;
//保存选中的按钮的字典
@property (nonatomic, strong) NSMutableDictionary *selectBtnDict;
//有效产品的数组集合
@property (nonatomic, strong) NSMutableArray *validProducts;
//已选中的产品的ID
@property (nonatomic, assign) NSInteger objectId;
//当前选中的选项是否匹配有效规格
@property (nonatomic, assign) BOOL isMatch;
//当前选择是否匹配到有效产品
@property (nonatomic, assign) BOOL isFind;
@end

@implementation EFSelecteSpecificationView
#pragma mark --- lazy load
- (NSMutableDictionary *)selectBtnDict{
    if (_selectBtnDict == nil) {
        _selectBtnDict = [NSMutableDictionary dictionary];
    }
    return _selectBtnDict;
}

- (NSMutableArray *)validProducts{
    if (_validProducts == nil) {
        _validProducts = [NSMutableArray array];
    }
    return _validProducts;
}

#pragma mark --- life cycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [self setupPopView];
}

- (void)setupPopView{
    //弹出视图
    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 405)];
    popView.backgroundColor = [UIColor whiteColor];
    [self addSubview:popView];
    self.popView = popView;
    
    //头部视图
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    headerView.backgroundColor = [UIColor whiteColor];
    [popView addSubview:headerView];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.borderColor = [UIColor grayColor].CGColor;
    iconView.layer.borderWidth = 1;
    [headerView addSubview:iconView];
    iconView.sd_layout.topSpaceToView(headerView,10).leftSpaceToView(headerView,10).heightIs(70).widthIs(70);
    self.iconView = iconView;
    
    UILabel *productNameLabel = [[UILabel alloc] init];
    productNameLabel.font = [UIFont systemFontOfSize:15];
    productNameLabel.numberOfLines = 1;
//    productNameLabel.text = @"乐视电视";
    productNameLabel.textColor = EF_TextColor_TextColorPrimary;
    [headerView addSubview:productNameLabel];
    productNameLabel.sd_layout.rightSpaceToView(headerView,10).leftSpaceToView(iconView,10).topSpaceToView(headerView,30).autoHeightRatio(0);
    self.productNameLabel = productNameLabel;
    
    UILabel *productPriceLabel  = [[UILabel alloc] init];
    productPriceLabel.textColor = RGBColor(255, 119, 2);
    productPriceLabel.font = [UIFont systemFontOfSize:15];
//    productPriceLabel.text = @"¥189";
    [headerView addSubview:productPriceLabel];
    self.productPriceLabel = productPriceLabel;
    productPriceLabel.sd_layout.leftSpaceToView(iconView,10).rightSpaceToView(headerView,10).topSpaceToView(productNameLabel,10).autoHeightRatio(0);
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget: self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/close"]]  forState:0];
    [headerView addSubview:dismissButton];
    dismissButton.sd_layout.rightEqualToView(headerView).topEqualToView(headerView).widthIs(30).heightIs(30);
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [headerView addSubview:priceLabel];
    self.priceLabel = priceLabel;

    //底部确认按钮
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setBackgroundColor:RGBColor(255, 119, 2)];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:sureButton];
    sureButton.sd_layout.bottomEqualToView(popView).leftEqualToView(popView).rightEqualToView(popView).heightIs(45);
    
    //选择视图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [popView addSubview:scrollView];
    scrollView.sd_layout.topSpaceToView(headerView,10).leftEqualToView(popView).rightEqualToView(popView).bottomSpaceToView(sureButton,0);
    self.scrollView = scrollView;
}

+ (instancetype)SelecteSepacificationView{
    return [[self alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)push{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.popView.top = SCREEN_HEIGHT - 405;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.popView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark --- setter
- (void)setProductDetailModel:(ProductDetailModel *)productDetailModel{
    _productDetailModel = productDetailModel;
    OtherProductSpecification *currentProductSpecification = [[OtherProductSpecification alloc] init];
    currentProductSpecification.productSpecification = productDetailModel.productSpecification;
    currentProductSpecification.name = productDetailModel.name;
    currentProductSpecification.price = productDetailModel.price;
    currentProductSpecification.sn = productDetailModel.sn;
    currentProductSpecification.objectId = productDetailModel.objectId;
    currentProductSpecification.stock = productDetailModel.stock;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_productDetailModel.image.url] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_loadingimg"]] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
//            self.iconView.contentMode =  UIViewContentModeScaleAspectFill;
//            self.iconView.clipsToBounds = YES;
            self.iconView.image = image;
        }else{
            self.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"MallImage.bundle/ic_loadingimg"]];
        }
        
    }];
    self.productNameLabel.text = productDetailModel.name;
    self.productPriceLabel.text = [NSString stringWithFormat:@"¥%zd",productDetailModel.price];
//    [self.validProducts addObject:currentProductSpecification];//如果接口返回的其他规格不包含当前规格 就解开
    for (OtherProductSpecification *otherProductSpecification in productDetailModel.otherProductSpecifications) {
        [self.validProducts addObject:otherProductSpecification];
    }
    
    UIView *lastView = nil;
    for (Specifications *specification in productDetailModel.specifications) {
        UIView *selectView = [self creatSelectViewWith:specification.name andSelects:specification.values andObjectId:specification.objectId];
        [self.scrollView addSubview:selectView];
        selectView.top += kMargin + lastView.bottom;
        lastView = selectView;
    }
    
    [self.scrollView setupAutoContentSizeWithBottomView:lastView bottomMargin:10];
}

#warning TODO 这里有问题，为什么是出现的时候调这句话····
- (void)dealloc{
    NSLog(@"规格选择视图被销毁了!");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (touchPoint.y < 405) {
        [self dismiss];
    }
}

#pragma mark --- utility
/**
 *  创建一种规格视图
 *
 *  @param title    规格视图的标题
 *  @param selects  规格对应的值
 *  @param objectId 该规格的ID
 *
 *  @return 规格视图
 */
- (UIView *)creatSelectViewWith:(NSString *)title andSelects:(NSArray *)selects andObjectId:(NSInteger)objectId{
    
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    
    CGFloat titleLabelH = 20.f;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = EF_TextColor_TextColorSecondary;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [containerView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(10, 0, 100, titleLabelH);
    
    NSInteger count = selects.count;
    CGFloat rowTotalWidth = kMargin;//记录每次循环，改行已经使用的宽度
    CGFloat row = 0;//记录当前的行数
    UIView *lastView = nil;//记录最后一个视图，方便计算高度
    
    for (NSInteger i = 0; i < count; i ++) {
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [containerView addSubview:selectBtn];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        Values *value = selects[i];
        [selectBtn setTitle:value.text forState:UIControlStateNormal];
        selectBtn.layer.cornerRadius = 15;
        [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        selectBtn.layer.masksToBounds = YES;
        selectBtn.layer.borderColor = [UIColor grayColor].CGColor;
        selectBtn.layer.borderWidth = 1;
        selectBtn.selected = NO;
         UIImage * image1 = [self imageWithColor:BCWhiteColor(230, 1)];
         UIImage * image = [self imageWithColor:[UIColor clearColor]];
        [selectBtn setBackgroundImage:image forState:0];
        [selectBtn setBackgroundImage:image1 forState:UIControlStateDisabled];
        for (ProductSpecification *productSpecification in self.productDetailModel.productSpecification) {
            Values *currentValue = productSpecification.value;
            if ([productSpecification.name isEqualToString:title] && [currentValue.text isEqualToString:value.text]) {
                selectBtn.layer.borderColor = [UIColor redColor].CGColor;
                selectBtn.selected = YES;
                //使用规格的objectId作为key 存取选中的按钮,为了和按钮的tag联系起来
                [self.selectBtnDict setObject:selectBtn forKey:[NSString stringWithFormat:@"%zd",objectId]];
            }
        }
        selectBtn.tag = i + objectId * 100;
        [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [selectBtn sizeToFit];
        selectBtn.width += 2 * kMargin;
        selectBtn.height = kSelectBtnH;
        if(rowTotalWidth > 0.8 * SCREEN_WIDTH){
            rowTotalWidth = kMargin;
            row += 1;
        }
        selectBtn.left = rowTotalWidth;
        selectBtn.top = titleLabelH + kMargin + (kMargin + kSelectBtnH) * row;
        rowTotalWidth += selectBtn.width + kMargin;
        lastView = selectBtn;
    }
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor grayColor];
    [containerView addSubview:separateLine];
    separateLine.frame = CGRectMake(kMargin, lastView.bottom + kMargin, SCREEN_WIDTH - 2 * kMargin, 1);
    
    containerView.height = CGRectGetMaxY(separateLine.frame);
    return containerView;
}

//根据颜色生成图片
- (UIImage *) imageWithColor: (UIColor *) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark --- event response
- (void)dismissBtnClick{
    [self dismiss];
}

- (void)selectBtnClick:(UIButton *)sender{
    //1、点击的按钮处于第几个区域
    NSInteger index = sender.tag / 100;
    //2、取出存储选中按钮的字典中对于的key
    NSString *key = [NSString stringWithFormat:@"%zd",index];
    //3、设置按钮的状态
    //取出存放在字典中的按钮
    UIButton *selectBtn = self.selectBtnDict[key];
    selectBtn.layer.borderColor = [UIColor grayColor].CGColor;
    selectBtn.selected = NO;

    sender.selected = YES;
    sender.layer.borderColor = [UIColor redColor].CGColor;
    //将新的按钮存储起来
    [self.selectBtnDict setObject:sender forKey:key];
    
    
    [self checkChoseResultIsValid];
}

#pragma mark --- setter
- (void)setSelectHandler:(SelectHandler)selectHandler{
    _selectHandler = [selectHandler copy];
}

//检查每次所选的结果是否合法有效
- (void)checkChoseResultIsValid{
    
//    self.isMatch = YES;  卡了我一天，就因为这句话应该写在下面！！！！
    //遍历有效产品
    [self.validProducts enumerateObjectsUsingBlock:^(OtherProductSpecification *otherSpecification, NSUInteger idx, BOOL * _Nonnull stop3) {
        
        self.isMatch = YES;
        //遍历产品的规格
       [otherSpecification.productSpecification enumerateObjectsUsingBlock:^(ProductSpecification * specification, NSUInteger idx, BOOL * _Nonnull stop2) {
           
           //遍历所选项
           [self.selectBtnDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, UIButton *selectBtn, BOOL * _Nonnull stop1) {
               if ([specification.objectId isEqualToString:key]) {
                   if (![selectBtn.currentTitle isEqualToString:specification.value.text]) {
                       self.isMatch = NO;
                       *stop1 = YES;
                   }
               }
           }];
           
       }];


        if (self.isMatch == YES&&otherSpecification.stock>0) {
            
            self.productNameLabel.text = otherSpecification.name;
            self.productPriceLabel.text = [NSString stringWithFormat:@"¥%zd",otherSpecification.price];
            self.objectId = otherSpecification.objectId;
            *stop3 = YES;
        }else{
            self.productNameLabel.text = @"该产品暂无!";
            self.productPriceLabel.text = @"¥0";
        }
        
    }];
    
}
- (void)sureButtonClick{
    if (self.isMatch == YES) {
        NSString *string = @"";
        for (UIButton *selectBtn in self.selectBtnDict.allValues) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@" %@",selectBtn.currentTitle]];
        }
        !self.selectHandler ? : self.selectHandler(string,self.objectId);
        [self dismiss];
    }else{
        [self dismiss];
    }
}
@end
