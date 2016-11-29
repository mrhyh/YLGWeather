

//  Created by ylgwhyh on 16/6/13.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "EFCartModel.h"
#import "EFMallModel.h"

@implementation EFCartModel


+ (NSDictionary *)objectClassInArray{
    return @{@"content" : [ShopCartContentModel class]};
}
@end



@implementation ShopCartContentModel

@end


@implementation Productitem

@end

@implementation CartImage

@end

