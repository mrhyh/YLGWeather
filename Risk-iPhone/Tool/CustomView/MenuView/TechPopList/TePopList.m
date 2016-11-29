//
//  TePopList.m
//  DSActionSheetDemo
//
//  Created by Techistoner on 15/8/27.
//  Copyright (c) 2015年 LS. All rights reserved.
//

#import "TePopList.h"
#import "TePopListCell.h"
#import <objc/runtime.h>
static NSString *poplistKey = @"poplistKey";

#define TeRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define TescreenFrame         [UIScreen mainScreen].bounds
#define TecellH       44 * SCREEN_H_RATE
#define TedefauleShow      5
#define TePoplistImage(file) [@"TePoplistImage.bundle" stringByAppendingPathComponent:file]

@implementation TePopList{
    UITableView *tableview;
    NSArray *datasource;
    UIImage *normal;
    UIImage *selected;
    NSInteger selectedIndex;
}

- (instancetype)initWithListDataSource:(NSArray *)source withSelectedBlock:(PopListSelectedBlock)selecteblock{
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self)
    {
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.001];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
#warning TODO 暂时注释
        //normal = [UIImage imageNamed:TePoplistImage(@"RadioButton-Unselected")];
        //selected = [UIImage imageNamed:TePoplistImage(@"RadioButton-Selected")];

        tableview = [[UITableView alloc
                      ]initWithFrame:CGRectMake(0, 0, 0,0) style:UITableViewStylePlain];
        [tableview setDataSource:self];
        [tableview setDelegate:self];
        [self addSubview:tableview];
        tableview.scrollEnabled = NO;
        //    tableview.layer.shadowColor = [UIColor blackColor].CGColor;
        //    tableview.layer.shadowOffset = CGSizeMake(4,4);
        //    tableview.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        //    tableview.layer.shadowRadius = 4;//阴影半径，默认3
        tableview.layer.shadowColor = [UIColor whiteColor].CGColor;
        tableview.showsVerticalScrollIndicator = NO;
        tableview.tableFooterView = [[UIView alloc]init];
        datasource = [NSArray arrayWithArray:source];
        if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableview setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableview respondsToSelector:@selector(setLayoutMargins:)])  {
            [tableview setLayoutMargins:UIEdgeInsetsZero];
        }
        NSInteger listcount = source.count;
        if (listcount > TedefauleShow) {
            listcount = TedefauleShow;
        }
    
        CGFloat TEScreen_Width =[[UIScreen mainScreen] bounds].size.width;
        
        //位置
        CGSize size = CGSizeMake(80, TecellH*listcount);
        [tableview setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/6*4, 64, TEScreen_Width/6*2, listcount*TecellH)];
        
        if(SCREEN_HEIGHT<= 568){ //5s以及更小的屏膜
            CGSize size = CGSizeMake(80, 44*listcount);
            [tableview setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/6*4-20, 64, 126, TecellH * listcount)];

        }
         self.selecteblock =selecteblock ;
    }
    
    return self;

}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return datasource.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TecellH;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdenti = @"TePopListCell";
    TePopListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenti];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TePopListCell" owner:self options:nil] objectAtIndex:0];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    [cell.checkBtn setTag:indexPath.row];
    [cell.checkBtn addTarget:self action:@selector(checkBtnfunction:) forControlEvents:UIControlEventTouchDown];
    
    if (indexPath.row == selectedIndex) {
        [cell.checkBtn setImage:selected forState:UIControlStateNormal];
    }
    else{
        [cell.checkBtn setImage:normal forState:UIControlStateNormal];

    }
    [cell.title setText:datasource[indexPath.row]];
    cell.tintColor = [UIColor grayColor];
    
    UIColor *cellColor = EF_TextColor_BlackDivider;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, TecellH-0.5, cell.frame.size.width, 0.5)];
    line.backgroundColor = cellColor;
    [cell addSubview:line];
    
    if (indexPath.row == 0) {
        line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 0.5)];
        line.backgroundColor = cellColor;
        [cell addSubview:line];
    }
    
    cell.title.textColor = [UIColor grayColor];
    cell.title.font = [UIFont systemFontOfSize:15];
    return cell;
}
- (void)setSelecteblock:(PopListSelectedBlock)selecteblock {
    
    [self willChangeValueForKey:@"callbackBlock"];
    objc_setAssociatedObject(self, &poplistKey, selecteblock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"callbackBlock"];
}

- (PopListSelectedBlock)selecteblock {
    
    return objc_getAssociatedObject(self, &poplistKey);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selecteblock) {
        self.selecteblock(indexPath.row);
        selectedIndex = indexPath.row;
        [tableview reloadData];
        [self hide];
    }
}

-(IBAction)checkBtnfunction:(UIButton *)sender{
    if (self.selecteblock) {
        self.selecteblock(sender.tag);
        selectedIndex = sender.tag;
        [tableview reloadData];
        [self hide];
    }
}


- (void)show{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
}


- (void)hide
{
    [UIView animateWithDuration:2 animations:^{

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Action Event
- (void)selectIndex:(NSInteger )index{
        selectedIndex = index;
        [tableview reloadData];
}

- (void)singleTapAction:(UITapGestureRecognizer *)gestureRecognizer
{
  [self hide];
}
@end
