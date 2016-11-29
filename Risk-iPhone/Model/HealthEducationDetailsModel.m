//
//	HealthEducationDetailsModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HealthEducationDetailsModel.h"

NSString *const kHealthEducationDetailsModelContent = @"content";
NSString *const kHealthEducationDetailsModelFirst = @"first";
NSString *const kHealthEducationDetailsModelLast = @"last";
NSString *const kHealthEducationDetailsModelNumber = @"number";
NSString *const kHealthEducationDetailsModelNumberOfElements = @"numberOfElements";
NSString *const kHealthEducationDetailsModelSize = @"size";
NSString *const kHealthEducationDetailsModelTotalElements = @"totalElements";
NSString *const kHealthEducationDetailsModelTotalPages = @"totalPages";

@interface HealthEducationDetailsModel ()
@end
@implementation HealthEducationDetailsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content" : [HealthEducationContent class] };
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.content != nil){
		NSMutableArray * dictionaryElements = [NSMutableArray array];
		for(HealthEducationContent * contentElement in self.content){
			[dictionaryElements addObject:[contentElement toDictionary]];
		}
		dictionary[kHealthEducationDetailsModelContent] = dictionaryElements;
	}
	dictionary[kHealthEducationDetailsModelFirst] = @(self.first);
	dictionary[kHealthEducationDetailsModelLast] = @(self.last);
	dictionary[kHealthEducationDetailsModelNumber] = @(self.number);
	dictionary[kHealthEducationDetailsModelNumberOfElements] = @(self.numberOfElements);
	dictionary[kHealthEducationDetailsModelSize] = @(self.size);
	dictionary[kHealthEducationDetailsModelTotalElements] = @(self.totalElements);
	dictionary[kHealthEducationDetailsModelTotalPages] = @(self.totalPages);
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.content != nil){
		[aCoder encodeObject:self.content forKey:kHealthEducationDetailsModelContent];
	}
	[aCoder encodeObject:@(self.first) forKey:kHealthEducationDetailsModelFirst];	[aCoder encodeObject:@(self.last) forKey:kHealthEducationDetailsModelLast];	[aCoder encodeObject:@(self.number) forKey:kHealthEducationDetailsModelNumber];	[aCoder encodeObject:@(self.numberOfElements) forKey:kHealthEducationDetailsModelNumberOfElements];	[aCoder encodeObject:@(self.size) forKey:kHealthEducationDetailsModelSize];	[aCoder encodeObject:@(self.totalElements) forKey:kHealthEducationDetailsModelTotalElements];	[aCoder encodeObject:@(self.totalPages) forKey:kHealthEducationDetailsModelTotalPages];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.content = [aDecoder decodeObjectForKey:kHealthEducationDetailsModelContent];
	self.first = [[aDecoder decodeObjectForKey:kHealthEducationDetailsModelFirst] boolValue];
	self.last = [[aDecoder decodeObjectForKey:kHealthEducationDetailsModelLast] boolValue];
	self.number = [[aDecoder decodeObjectForKey:kHealthEducationDetailsModelNumber] integerValue];
	self.numberOfElements = [[aDecoder decodeObjectForKey:kHealthEducationDetailsModelNumberOfElements] integerValue];
	self.size = [[aDecoder decodeObjectForKey:kHealthEducationDetailsModelSize] integerValue];
	self.totalElements = [[aDecoder decodeObjectForKey:kHealthEducationDetailsModelTotalElements] integerValue];
	self.totalPages = [[aDecoder decodeObjectForKey:kHealthEducationDetailsModelTotalPages] integerValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	HealthEducationDetailsModel *copy = [HealthEducationDetailsModel new];

	copy.content = [self.content copy];
	copy.first = self.first;
	copy.last = self.last;
	copy.number = self.number;
	copy.numberOfElements = self.numberOfElements;
	copy.size = self.size;
	copy.totalElements = self.totalElements;
	copy.totalPages = self.totalPages;

	return copy;
}
@end
