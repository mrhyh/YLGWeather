#import <UIKit/UIKit.h>

@interface HealthEducationContent : NSObject

@property (nonatomic, copy) NSString * fileName;
@property (nonatomic, assign) NSInteger objectId;
@property (nonatomic, assign) BOOL isVideo;

-(NSDictionary *)toDictionary;
@end
