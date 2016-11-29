//
//  HYDFileManager.m
//  JaneZhang
//
//  Created by  on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HYDFileManager.h"

@implementation HYDFileManager

+ (NSString *) getFileNameWithNowDate{
	NSDateFormatter * df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyMMddHHmmss"];
	int radom = arc4random() % 100;
	NSString * filename = [NSString stringWithFormat:@"%@%d",[df stringFromDate:[NSDate date]],radom];
	return filename;
}

+ (int) getFileIDWithNowDate{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"dHms"];
	int radom = arc4random() % 100;
	NSString * filename = [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]];
	return [filename intValue] * 10 + radom;
}

+ (NSString *) getDocumentsPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

+ (NSString *) getTempMoviePath{
    NSString *filepath = [NSTemporaryDirectory() stringByAppendingPathComponent:TempMovieDirectorie];
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:filepath]) {
		[fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return filepath ;
}


+ (NSString *) getDocumentsImagesPath{
	NSString *filepath = [[HYDFileManager getDocumentsPath] stringByAppendingPathComponent:DocumentImageDirectorie];
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:filepath]) {
		[fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return filepath ;	
}


+ (NSString *) getTempThumbImagePath{
	NSString *filepath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"thumbimage"];
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:filepath]) {
		[fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return filepath;
}


+ (UIImage *) getTempImageByName : (NSString *)_name{
    NSString *filepath = [[HYDFileManager getTempThumbImagePath] stringByAppendingPathComponent:_name];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath]) {
		return nil;
	}
    return [UIImage imageWithContentsOfFile:filepath];
}

+ (void) saveTempImageData : (NSData *)_data ImageName : (NSString *)_name{
    NSString *filepath = [[HYDFileManager getTempThumbImagePath] stringByAppendingPathComponent:_name];
    [_data writeToFile:filepath atomically:YES];
}



+ (NSData *)getTempGifDataByName : (NSString *)_name{
    NSString *filepath = [[HYDFileManager getTempThumbImagePath] stringByAppendingPathComponent:_name];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath]) {
        return nil;
    }
    return [NSData dataWithContentsOfFile:filepath];
}



//vedio
+ (NSString *) getTempVedioPath{
    NSString *filepath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"vedio"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath]) {
        [fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filepath;
}


+ (NSString *)getTempVedioPathByName : (NSString *)_name{
    NSString *filepath = [[HYDFileManager getTempVedioPath] stringByAppendingPathComponent:_name];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath]) {
        return nil;
    }
    return filepath;
}

+ (void) saveTempVedioData : (NSData *)_data VedioName : (NSString *)_name{
    NSString *filepath = [[HYDFileManager getTempVedioPath] stringByAppendingPathComponent:_name];
    [_data writeToFile:filepath atomically:YES];
}


@end
