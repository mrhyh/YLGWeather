//
//  HYDFileManager.m
//  JaneZhang
//
//  Created by  on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EFFileManager.h"

@implementation EFFileManager

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

+ (NSString *) getDocumentConfigsPath{
    NSString *filepath = [[EFFileManager getDocumentsPath] stringByAppendingPathComponent:FileManagerConfigDirectory];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath]) {
        [fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filepath ;
}


+ (NSString *) getDocumentMoviesPath{
    NSString *filepath = [[EFFileManager getDocumentsPath] stringByAppendingPathComponent:FileManagerMoviesDirectory];
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:filepath]) {
		[fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return filepath ;
}


+ (NSString *) getDocumentImagesPath{
	NSString *filepath = [[EFFileManager getDocumentsPath] stringByAppendingPathComponent:FileManagerImagesDirectory];
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:filepath]) {
		[fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return filepath ;	
}


+ (NSString *) getDocumentThumbImagesPath{
    NSString *filepath = [[EFFileManager getDocumentsPath] stringByAppendingPathComponent:FileManagerThumbImagesDirectory];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath]) {
        [fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filepath ;
}


+ (NSString *) getTempMoviesPath{
    NSString *filepath = [NSTemporaryDirectory() stringByAppendingPathComponent:FileManagerMoviesDirectory];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath]) {
        [fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filepath;
}

+ (NSString *) getTempImagesPath{
    NSString *filepath = [NSTemporaryDirectory() stringByAppendingPathComponent:FileManagerImagesDirectory];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath]) {
        [fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filepath;
}


+ (NSString *) getTempThumbImagePath{
	NSString *filepath = [NSTemporaryDirectory() stringByAppendingPathComponent:FileManagerThumbImagesDirectory];
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:filepath]) {
		[fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return filepath;
}

+ (NSData *)getFileDataByPath : (NSString *)_path{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:_path]) {
        return nil;
    }
    return [NSData dataWithContentsOfFile:_path];
}


+ (UIImage *) getTempThumbImageByName : (NSString *)_name{
    NSString *filepath = [[EFFileManager getTempThumbImagePath] stringByAppendingPathComponent:_name];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath]) {
		return nil;
	}
    return [UIImage imageWithContentsOfFile:filepath];
}


+ (void) saveTempThumbImageData : (NSData *)_data ImageName : (NSString *)_name{
    NSString *filepath = [[EFFileManager getTempThumbImagePath] stringByAppendingPathComponent:_name];
    [_data writeToFile:filepath atomically:YES];
}


+ (NSData *)getTempDataByName : (NSString *)_name{
    NSString *filepath = [[EFFileManager getTempThumbImagePath] stringByAppendingPathComponent:_name];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath]) {
        return nil;
    }
    return [NSData dataWithContentsOfFile:filepath];
}


+ (NSString *)getTempVedioPathByName : (NSString *)_name{
    NSString *filepath = [[EFFileManager getTempMoviesPath] stringByAppendingPathComponent:_name];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath]) {
        return nil;
    }
    return filepath;
}

+ (void) saveTempVedioData : (NSData *)_data VedioName : (NSString *)_name{
    NSString *filepath = [[EFFileManager getTempMoviesPath] stringByAppendingPathComponent:_name];
    [_data writeToFile:filepath atomically:YES];
}


@end
