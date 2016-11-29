//
//	Content.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HealthEducationContent.h"

NSString *const kContentFileName = @"fileName";
NSString *const kContentObjectId = @"objectId";

@interface HealthEducationContent ()
@end
@implementation HealthEducationContent




/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.fileName != nil){
		dictionary[kContentFileName] = self.fileName;
	}
	dictionary[kContentObjectId] = @(self.objectId);
	return dictionary;

}


@end
