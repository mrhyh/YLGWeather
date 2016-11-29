//
//  RSFDARiskModel.m
//  Risk
//
//  Created by ylgwhyh on 16/7/26.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSFDARiskModel.h"
#import "UserModel.h"

@implementation RSFDARiskModel

+ (void) saveContentsModel:(NSMutableArray<RSFDARiskModel *> *)NewsContentModelArray {
    
    if([NewsContentModelArray isKindOfClass:[NSMutableArray class]]){
        //保存账户模型数组到本地
        NSMutableArray *dataArray =[[NSMutableArray alloc] init];
        for(RSFDARiskModel *pAc in NewsContentModelArray){
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:pAc];
            [dataArray addObject:data];
        }
        
        NSArray *arraySave = [NSArray arrayWithArray:dataArray];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:arraySave forKey:[NSString stringWithFormat:@"%@%d",Risk_SearchHistroyArray,(int)[UserModel ShareUserModel].objectId]];
    }
    
}

+ (NSMutableArray<RSFDARiskModel *> *) readContentsModel {
    NSUserDefaults *userDefaultsRead = [NSUserDefaults standardUserDefaults];
    NSArray *arrayRead = [userDefaultsRead arrayForKey:[NSString stringWithFormat:@"%@%d",Risk_SearchHistroyArray,(int)[UserModel ShareUserModel].objectId]];
    
    //转换DSData数据
    NSMutableArray *array = [NSMutableArray array];
    [array removeAllObjects];
    RSFDARiskModel *newsContentModel;
    for (NSData *data in arrayRead) {
        newsContentModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [array addObject:newsContentModel];
    }
    
    return array;
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.objectId = [aDecoder decodeIntegerForKey:@"objectId"];
        self.englishName = [aDecoder decodeObjectForKey:@"englishName"];
        self.fdaType = [aDecoder decodeObjectForKey:@"fdaType"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.otherName = [aDecoder decodeObjectForKey:@"otherName"];
        self.categoryShowName = [aDecoder decodeObjectForKey:@"categoryShowName"];
        self.tags = [aDecoder decodeObjectForKey:@"tags"];
        self.tagsId = [aDecoder decodeIntForKey:@"tagsId"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.stype =[aDecoder decodeObjectForKey:@"stype"];
        self.isVideo = [aDecoder decodeBoolForKey:@"isVideo"];
        self.size = [aDecoder decodeIntForKey:@"size"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.englishName forKey:@"englishName"];
    [aCoder encodeObject:self.fdaType forKey:@"fdaType"];
    [aCoder encodeObject:self.otherName forKey:@"otherName"];
    [aCoder encodeObject:self.categoryShowName forKey:@"categoryShowName"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.objectId forKey:@"objectId"];
    [aCoder encodeObject:self.tags forKey:@"tags"];
    [aCoder encodeInt:self.tagsId forKey:@"tagsId"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.stype forKey:@"stype"];
    [aCoder encodeBool:self.isVideo forKey:@"isVideo"];
    [aCoder encodeInt:self.size forKey:@"size"];
    
}

@end
