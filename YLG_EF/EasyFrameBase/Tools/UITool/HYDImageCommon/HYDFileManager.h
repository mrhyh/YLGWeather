//
//  HYDFileManager.h
//  JaneZhang
//
//  Created by  on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DocumentImageDirectorie     @"Images"
#define TempMovieDirectorie         @"Movies"

@interface HYDFileManager : NSObject

//根据当前时间获取一个唯一的文件名称
+ (NSString *) getFileNameWithNowDate;
+ (int) getFileIDWithNowDate;

+ (NSString *) getDocumentsPath;
+ (NSString *) getTempMoviePath;

+ (NSString *) getDocumentsImagesPath;
+ (NSString *) getTempThumbImagePath;

+ (UIImage *) getTempImageByName : (NSString *)_name;

+ (void) saveTempImageData : (NSData *)_data ImageName : (NSString *)_name;

//add
+ (NSData *)getTempGifDataByName : (NSString *)_name;

+ (NSString *) getTempVedioPath;
+ (NSString *)getTempVedioPathByName : (NSString *)_name;
+ (void) saveTempVedioData : (NSData *)_data VedioName : (NSString *)_name;

@end
