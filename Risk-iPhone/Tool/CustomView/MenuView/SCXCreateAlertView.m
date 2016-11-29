//
//  SCXCreateAlertView.m
//  自定义弹出视图
//
//  Created by  on 16/5/4.
//  Copyright © 2016年 All rights reserved.
//

#import "SCXCreateAlertView.h"
#import "ViewController.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define ALERTWIDTH 150
#define ALERTHEIGHT 50
#define BUTTONALERTVIEWWIDTH 280
#define BUTTONALERTVIEWHEIGHT (180)
#define CRACKWIDTH 50
#define COLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define HEIGHT [UIScreen mainScreen].bounds.size.height

//static SCXCreateAlertView *singCreateAlertView =nil;
@implementation SCXCreateAlertView

#pragma mark--自定义下拉菜单
-(instancetype)initWithNameArray:(NSArray *)nameArray andMenuOrigin:(CGRect)rect andMenuWidth:(CGFloat)width andHeight:(CGFloat)rowHeight andLayer:(CGFloat)layer andTableViewBackGroundColor:(UIColor *)color andIsSharp:(BOOL)sharp andType:(popType)poptype clickButton:(UIButton *)clickButton{
    
    CGFloat tableViewH = rowHeight*nameArray.count + 50;
    //背景view
    self=[super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREEN_HEIGHT) ];
    self.backgroundColor = [UIColor grayColor];
    NSLog(@"self.rect:%@",NSStringFromCGRect(self.frame));
    if (self) {
        
        self.clickButton = clickButton;
        _popViewType=poptype;
        _isSharp=sharp;
        _layerSize=layer;
        _width=width;
        _rect = rect;
        _height=rowHeight;
        _nameArray=nameArray;
        _color=color;
        self.backgroundColor=[UIColor clearColor];
        self.menuTableView=[[UITableView alloc]initWithFrame:CGRectMake(rect.origin.x+70,rect.origin.y,width, tableViewH) style:UITableViewStylePlain];
        
        self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.menuTableView setBackgroundColor:color];
        [self.menuTableView setDelegate:self];
        [self.menuTableView setDataSource:self];
        self.menuTableView.rowHeight=rowHeight;
        [self.menuTableView.layer setMasksToBounds:YES];
        [self.menuTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"downMenuCell"];
        UIColor *tableViewColor = EF_TextColor_BlackDivider;
        self.menuTableView.separatorColor=tableViewColor; // cell线的颜色
        [self.menuTableView setLayoutMargins:UIEdgeInsetsZero];
        [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        //设置下拉菜单边框颜色，如果不需要可以注掉 。
        [self.menuTableView.layer setMasksToBounds:YES];
        //        [self.menuTableView.layer setBorderWidth:0.5];
        //        [self.menuTableView.layer setBorderColor:[UIColor blackColor].CGColor];

        //self.menuTableView.backgroundColor = [UIColor redColor];
        [self addSubview:_menuTableView];
    }
    return self;
}

#pragma mark--tableView代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"downMenuCell"];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text=_nameArray[indexPath.row];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    UIColor *cellColor = EF_TextColor_BlackDivider;
//    cell.layer.borderColor = cellColor.CGColor;
//    cell.layer.borderWidth = 0.5;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.5, _height)];
    line.backgroundColor = cellColor;
    [cell addSubview:line];
    
    line = [[UIView alloc]initWithFrame:CGRectMake(_width-0.5, 0, 0.5, _height)];
    line.backgroundColor = cellColor;
    [cell addSubview:line];
    
    line = [[UIView alloc]initWithFrame:CGRectMake(0, _height-0.5, _width, 0.5)];
    line.backgroundColor = cellColor;
    [cell addSubview:line];
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _nameArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_height <= 0) {
        return 44;
    }else {
        return _height;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    if ([self.tableViewDelegate respondsToSelector:@selector(tableViewDidSelectRowAtIndexPath: andPopType:clickButton:)]) {
        [self.tableViewDelegate tableViewDidSelectRowAtIndexPath:indexPath andPopType:_popViewType clickButton:self.clickButton];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];

}

#pragma mark--消失事件
-(void)dismissWithCompletion:(void (^)(SCXCreateAlertView *))completion{
    if (self.dismiss) {
        self.dismiss();
    }
}
-(void)animation{
    if (self.dismiss) {
        self.dismiss();
    }
}
#pragma mark--touch取消事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textField resignFirstResponder];
    [self dismissWithCompletion:nil];
}

@end
