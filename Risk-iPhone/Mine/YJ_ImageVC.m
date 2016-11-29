//
//  YJ_ImageVC.m
//  KYiOS
//
//  Created by MH on 16/4/28.
//  Copyright © 2016年 mini珍. All rights reserved.
//

#import "YJ_ImageVC.h"

@interface YJ_ImageVC ()<UIScrollViewDelegate>{
    KYMHLabel * tagLB;
    NSMutableArray * headPicArr;
    NSMutableArray * HeightArr;
    UIScrollView * scroll;
    NSArray * arr;
    int       index;
    BOOL     isDelect;
    UIImage * image1;
}

@end

@implementation YJ_ImageVC

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (instancetype)initWithImageArr:(NSMutableArray*)_array HeightArr:(NSMutableArray*)_heightarray Index:(int)_index SelectCallBack : (YJ_ImageVCBlock)_callBack{
    self = [super init];
    if (self) {
        headPicArr = [NSMutableArray array];
        HeightArr = [NSMutableArray array];
        headPicArr = _array;
        HeightArr = _heightarray;
        index = _index;
        self.imageBlock = _callBack;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage*)_image{
    self = [super init];
    if (self) {
        image1 = _image;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    isDelect = NO;
    
    
    if (!image1) {
        KYMHButton * rightBT = [[KYMHButton alloc] initWithbarButtonItem:self Title:@"删除" BaseSize:CGRectMake(SCREEN_WIDTH-50, 20, 50, 40) ButtonColor:[UIColor clearColor] ButtonFont:17 ButtonTitleColor:[UIColor whiteColor] Block:^{
            if (headPicArr.count>1) {
                [self removeImageAction:index];
            }else{
                [self removeImageAction:index];
                if (_imageBlock) {
                    _imageBlock(headPicArr);
                    _imageBlock = nil;
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
        [rightBT ButtonImage:Img(@"Delete")];
        [self.view addSubview:rightBT];
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104,SCREEN_WIDTH , SCREEN_HEIGHT-144)];
        scroll.scrollEnabled = YES;
        scroll.delegate = self;
        scroll.pagingEnabled = YES;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH*headPicArr.count, SCREEN_HEIGHT-144);
        [scroll setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:NO];
        [self.view addSubview:scroll];
        
        tagLB = [[KYMHLabel alloc] initWithTitle:[NSString stringWithFormat:@"%d/%d",index+1,(int)headPicArr.count] BaseSize:CGRectMake(0, 20, SCREEN_WIDTH, 40) LabelColor:[UIColor clearColor] LabelFont:17 LabelTitleColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:tagLB];
        [self refreshImagesView];
    }else{
        KYMHImageView * image = [[KYMHImageView alloc] initWithImage:image1 BaseSize:CGRectMake(0, SCREEN_HEIGHT/2-SCREEN_WIDTH/2, SCREEN_WIDTH, SCREEN_WIDTH) ImageViewColor:[UIColor clearColor]];
        [self.view addSubview:image];
        
    }
    
    
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo)];
    [self.view addGestureRecognizer:tapGesture];
    
}

-(void)Actiondo{
    if (_imageBlock) {
        _imageBlock(headPicArr);
        _imageBlock = nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)refreshImagesView{
    [[scroll subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (isDelect) {
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH*headPicArr.count, SCREEN_HEIGHT-144);
        [scroll setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:NO];
    }
    
    
    for (int i = 0; i < headPicArr.count; i++) {
        KYMHImageView * image = [[KYMHImageView alloc] initWithImage:headPicArr[i] BaseSize:CGRectMake(0+i*SCREEN_WIDTH, SCREEN_HEIGHT/2-SCREEN_WIDTH+64, SCREEN_WIDTH, [[HeightArr objectAtIndex:i] floatValue]) ImageViewColor:[UIColor clearColor]];
        [scroll addSubview:image];
    }
    
    
}

- (void)removeImageAction:(int)_sender{
    isDelect = YES;
    [headPicArr removeObjectAtIndex:_sender];
    [self refreshImagesView];
    [tagLB setText:[NSString stringWithFormat:@"%d/%d",index+1,(int)headPicArr.count]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  - mark UIScrollViewDelegate
//监听滚动的位置,改变pageCotrol的currentPage的值.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    index = scroll.contentOffset.x/SCREEN_WIDTH;
    if (!image1) {
        [tagLB setText:[NSString stringWithFormat:@"%d/%d",index+1,(int)headPicArr.count]];
    }
}





@end
