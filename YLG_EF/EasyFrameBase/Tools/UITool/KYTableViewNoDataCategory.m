//
//  KYTableViewNoDataCategory.m
//  QuickFlip
//
//  Created by Jack on 5/7/15.
//  Copyright (c) 2015 KingYon LLC. All rights reserved.
//

#import "KYTableViewNoDataCategory.h"
#import "MJRefresh.h"


#define KYTableViewNoDataKey 1843
@implementation UITableView (KYTableViewNoDataCategory)

- (void)addNoDataView{
    UIView *view = [self viewWithTag:KYTableViewNoDataKey];
    if (view) {
        [view removeFromSuperview];
    }
    
    
    UIImage * nodtaImg = Img(@"ic_nodata");
    
    UIView *noResultView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:noResultView];
    UIImageView  *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-nodtaImg.size.width)/2, 130*SCREEN_W_RATE,nodtaImg.size.width,nodtaImg.size.height)];
    backgroundImage.image = Img(@"ic_nodata");
    [noResultView addSubview:backgroundImage];
    
    
    UILabel *messageLB = [[UILabel alloc] initWithFrame:CGRectMake(0, backgroundImage.frame.origin.y + backgroundImage.frame.size.height + 10, self.bounds.size.width, 20*SCREEN_H_RATE)];
    messageLB.text = @"目前没有数据";
    messageLB.textAlignment = NSTextAlignmentCenter;
    messageLB.font = Font(14);
    messageLB.textColor = BCWhiteColor(160, 1);
    [noResultView addSubview:messageLB];
    noResultView.userInteractionEnabled = NO;
    noResultView.tag = KYTableViewNoDataKey;
    
    self.mj_footer.hidden = YES;
    
}

- (void)addNoDataViewStr:(NSString *)_str{
    UIView *view = [self viewWithTag:KYTableViewNoDataKey];
    if (view) {
        [view removeFromSuperview];
    }
    CGFloat height;
    if ([_str isEqualToString:@"发帖"]) {
        height = SCREEN_HEIGHT/2-30*SCREEN_H_RATE;
        _str = @"您还没有发帖！";
    }else if ([_str isEqualToString:@"回复"]){
        _str = @"还没有人回复您！";
        height = SCREEN_HEIGHT/2-30*SCREEN_H_RATE;
    }else if ([_str isEqualToString:@"发出"]){
        _str = @"您还没有发出评论！";
        height = SCREEN_HEIGHT/2-30*SCREEN_H_RATE;
    }else if ([_str isEqualToString:@"收藏"]){
        _str = @"您还没有收藏！";
        height = SCREEN_HEIGHT/2-30*SCREEN_H_RATE;
    }else if ([_str isEqualToString:@"即时消息"]){
        _str = @"您还没有即时消息！";
        height = SCREEN_HEIGHT/2-30*SCREEN_H_RATE;
    }
    
    UIImage * nodtaImg = Img(@"ic_nodata");
    
    UIView *noResultView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:noResultView];
    UIImageView  *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-nodtaImg.size.width)/2, 130*SCREEN_W_RATE,nodtaImg.size.width,nodtaImg.size.height)];
    backgroundImage.image = Img(@"ic_nodata");
    [noResultView addSubview:backgroundImage];
    
    
    UILabel *messageLB = [[UILabel alloc] initWithFrame:CGRectMake(0, height, self.bounds.size.width,40*SCREEN_H_RATE)];
    messageLB.text = [NSString stringWithFormat:@"%@",_str];
    messageLB.textAlignment = NSTextAlignmentCenter;
    messageLB.font = Font(16);
    messageLB.numberOfLines = 2;
    messageLB.lineBreakMode = NSLineBreakByCharWrapping;
    messageLB.textColor = BCWhiteColor(160, 1);
    
    
    [noResultView addSubview:messageLB];
    noResultView.userInteractionEnabled = NO;
    noResultView.tag = KYTableViewNoDataKey;
    
    self.mj_footer.hidden = YES;
}


- (void)removeNoDataView{
    
    UIView *view = [self viewWithTag:KYTableViewNoDataKey];
    if (view) {
        [view removeFromSuperview];
    }
}

@end
