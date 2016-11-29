//
//  HYDFileManager.h
//  JaneZhang
//
//  Created by  on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FileManagerConfigDirectory     @"Configs"
#define FileManagerImagesDirectory     @"Images"
#define FileManagerMoviesDirectory     @"Movies"
#define FileManagerThumbImagesDirectory @"ThumbImages"

@interface EFFileManager : NSObject

//根据当前时间获取一个唯一的文件名称
+ (NSString *) getFileNameWithNowDate;

+ (int) getFileIDWithNowDate;

+ (NSString *) getDocumentsPath;

+ (NSString *) getDocumentConfigsPath;  //配置文件存放路径
+ (NSString *) getDocumentMoviesPath;   //视频存放路径
+ (NSString *) getDocumentImagesPath;   //图片存放路径
+ (NSString *) getDocumentThumbImagesPath;   //图片存放路径

+ (NSString *) getTempMoviesPath;   //临时视频存放路径
+ (NSString *) getTempImagesPath;   //临时图片存放路径
+ (NSString *) getTempThumbImagePath;   //临时缩略图存放路径


+ (NSData *)getFileDataByPath : (NSString *)_path;


+ (UIImage *)getTempThumbImageByName : (NSString *)_name;

+ (void) saveTempThumbImageData : (NSData *)_data ImageName : (NSString *)_name;

+ (NSData *)getTempDataByName : (NSString *)_name;


+ (NSString *)getTempVedioPathByName : (NSString *)_name;
+ (void) saveTempVedioData : (NSData *)_data VedioName : (NSString *)_name;

@end
