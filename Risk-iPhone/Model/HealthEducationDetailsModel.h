#import <UIKit/UIKit.h>
#import "HealthEducationContent.h"

@interface HealthEducationDetailsModel : NSObject

@property (nonatomic, strong) NSArray <HealthEducationContent *> * content;
@property (nonatomic, assign) BOOL first;
@property (nonatomic, assign) BOOL last;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger numberOfElements;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger totalElements;
@property (nonatomic, assign) NSInteger totalPages;

-(NSDictionary *)toDictionary;
@end
