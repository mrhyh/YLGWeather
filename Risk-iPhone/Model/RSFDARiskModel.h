//
//  RSFDARiskModel.h
//  Risk
//
//  Created by ylgwhyh on 16/7/26.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Risk_SearchHistroyArray @"Risk_SearchHistroyArray"

@interface RSFDARiskModel : NSObject


@property (nonatomic, assign) NSInteger objectId;

@property (nonatomic, copy) NSString *englishName;

@property (nonatomic, copy) NSString *fdaType;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *otherName;

@property (nonatomic, copy) NSString *categoryShowName;

@property (nonatomic, copy) NSString * tags;

@property (nonatomic, assign) int tagsId;

@property (nonatomic, copy) NSString * type;

@property (nonatomic,strong) NSString * stype;  // risk--药物  file--资讯

@property (nonatomic,assign) BOOL isVideo;

@property (nonatomic,assign) int size;


//按照默认的key缓存
+ (void) saveContentsModel:(NSMutableArray<RSFDARiskModel *> *)NewsContentModelArray;
+ (NSMutableArray<RSFDARiskModel *> *) readContentsModel;

@end
