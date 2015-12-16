#import "FeedCache.h"


@implementation FeedCache
+(NSString *)pathForFeedCache:(NSString *)url {
    return [NSString stringWithFormat:@"%@/%d.dat",
            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],
            [url hash]];
}

+(void)storeDataForFeed:(NSString *)url data:(NSData *)data
{
    NSString *filePath = [self pathForFeedCache:url];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
}

+(NSData *)loadDataForFeed:(NSString *)url
{
    NSString *filePath = [self pathForFeedCache:url];
    return [[NSFileManager defaultManager] contentsAtPath:filePath];
}
@end

