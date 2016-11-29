//
//  RSEaseMobUserListModel.h
//  Risk
//
//  Created by ylgwhyh on 16/8/5.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MFHuanXinUserModelArrayKey @"MFHuanXinUserModelArrayKey"

@class HuanXinUserModel,Head;
@interface RSEaseMobUserListModel : NSObject

+ (instancetype)sharedInstance;


@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) NSArray<HuanXinUserModel *> *content;

@property (nonatomic, assign) NSInteger numberOfElements;

@property (nonatomic, assign) NSInteger totalPages;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) BOOL last;

@property (nonatomic, assign) NSInteger totalElements;

@property (nonatomic, assign) BOOL first;

@end
@interface HuanXinUserModel : NSObject

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) NSInteger birthDate;

@property (nonatomic, strong) Head *head;

@property (nonatomic, copy) NSString *easemobId;

@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *easemobPwd;


+ (void)saveHuanXinUserModelArrays:(NSMutableArray  <HuanXinUserModel *> *) huanXinUserModelArray;
+ (NSMutableArray *)getHuanXinUserModelArrays;

@end


