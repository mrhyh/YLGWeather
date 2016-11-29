//
//  EFTagModel.h
//  EF_MallDemo
//
//  Created by HqLee on 16/6/26.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFTagModel : NSObject
//标签的标题
@property (nonatomic, copy) NSString *title;
//标签的ID
@property (nonatomic, assign) NSInteger tagId;
@end
