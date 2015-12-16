#import <Foundation/Foundation.h>


@interface FeedCache : NSObject
{
    
}

+(NSString *)pathForFeedCache:(NSString *)url;    
+(void)storeDataForFeed:(NSString *)url data:(NSData *)data;
+(NSData *)loadDataForFeed:(NSString *)url;
@end

