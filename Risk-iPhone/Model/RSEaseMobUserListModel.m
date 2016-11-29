//
//  RSEaseMobUserListModel.m
//  Risk
//
//  Created by ylgwhyh on 16/8/5.
//  Copyright © 2016年 com.risk.kingyon. All rights reserved.
//

#import "RSEaseMobUserListModel.h"

@interface RSEaseMobUserListModel () <NSCoding>

@end

@implementation RSEaseMobUserListModel


+ (NSDictionary *)objectClassInArray{
    return @{@"content" : [HuanXinUserModel class]};
}
@end
@implementation HuanXinUserModel

- (void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.easemobId forKey:@"easemobId"];
    [aCoder encodeObject:self.sign forKey:@"sign"];
    [aCoder encodeObject:self.easemobPwd forKey:@"easemobPwd"];
    
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.head forKey:@"head"];
    
    [aCoder encodeInteger:self.birthDate forKey:@"birthDate"];
    [aCoder encodeInteger:self.objectId forKey:@"objectId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if(self){
        self.mobile = [aDecoder decodeObjectForKey:@"areaId"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.easemobId = [aDecoder decodeObjectForKey:@"easemobId"];
        self.sign = [aDecoder decodeObjectForKey:@"sign"];
        self.easemobPwd = [aDecoder decodeObjectForKey:@"easemobPwd"];
        
        self.birthDate = [aDecoder decodeIntegerForKey:@"birthDate"];
        self.objectId = [aDecoder decodeIntegerForKey:@"objectId"];
        
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.head = [aDecoder decodeObjectForKey:@"head"];

    }
    return self;
}


+ (void)saveHuanXinUserModelArrays:(NSMutableArray  <HuanXinUserModel *> *) huanXinUserModelArray {
    if ([huanXinUserModelArray isKindOfClass:[NSMutableArray class]] || ([huanXinUserModelArray isKindOfClass:[NSArray class]])){
        NSMutableArray *dataArray =[[NSMutableArray alloc] init];
        for(HuanXinUserModel *cAc in huanXinUserModelArray){
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cAc];
            [dataArray addObject:data];
        }
        
        NSArray *arraySave = [NSArray arrayWithArray:dataArray];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:arraySave forKey:MFHuanXinUserModelArrayKey];
    }
}

+ (NSMutableArray *)getHuanXinUserModelArrays {
    
    //从本地读取账户模型
    NSUserDefaults *userDefaultsRead = [NSUserDefaults standardUserDefaults];
    NSArray *arrayRead = [userDefaultsRead arrayForKey:MFHuanXinUserModelArrayKey];
    //转换DSData数据
    HuanXinUserModel *pAccount;
    NSMutableArray *pAccountArray = [NSMutableArray array];
    for (NSData *data in arrayRead) {
        pAccount = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [pAccountArray addObject:pAccount];
    }
    
    return pAccountArray;
}

@end



