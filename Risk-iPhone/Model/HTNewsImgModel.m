//
//  HTNewsImgModel.m
//  Haitangshequ
//
//  Created by zhaoxiaoyun on 14-3-4.
//  Copyright (c) 2014年 zxy. All rights reserved.
//

#import "HTNewsImgModel.h"

@implementation HTNewsImgModel
@synthesize description,imageUrl,imgId;

- (id)initWithDictionary:(NSDictionary *)_dic{
    if (self = [super init]) {
        self.imgId = [_dic objectForKey:@"id"];
        self.description = [_dic objectForKey:@"description"];
        self.imageUrl = [_dic objectForKey:@"imageUrl"];
        
        if (!self.imgId || self.imgId.length <= 0) {
            self.imgId = @"";
        }
        if (!self.description || self.description.length <= 0) {
            self.description = @"";
        }
        if (!self.imageUrl || self.imageUrl.length <= 0) {
            self.imageUrl = @"";
        }
    }
    return self;
}

@end
