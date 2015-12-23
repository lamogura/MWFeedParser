//
//  MWImageParser.m
//  Pods
//
//  Created by Darshan Patil on 12/22/15.
//
//

#import "MWImageParser.h"

#include "tidy.h"
#include "buffio.h"

@implementation MWImageParser

@synthesize xmlParser, images;


+ (NSArray *)parseImagesFromXHTMLString:(NSString *)html {
    // HTML may be malformed and needs to be run through Tidy
    
    TidyBuffer output = {0};
    TidyBuffer errbuf = {0};
    
    TidyDoc tdoc = ig_tidyCreate();
    
    // Stup Tidy to convert into XML
    if (!ig_tidyOptSetBool(tdoc, TidyXmlOut, yes)) {
        return nil;
    }
    // Setup Tidy to use UTF-8
    if (!ig_tidyOptSetValue(tdoc, TidyCharEncoding, "utf8")) {
        return nil;
    }
    // Capture diagnostics
    if (ig_tidySetErrorBuffer(tdoc, &errbuf) < 0) {
        return nil;
    }
    // Parse the input
    if (ig_tidyParseString(tdoc, [html UTF8String]) < 0) {
        return nil;
    }
    // Tidy it up!
    if (ig_tidyCleanAndRepair(tdoc) < 0) {
        return nil;
    }
    // Pretty Print
    if (ig_tidySaveBuffer(tdoc, &output) < 0) {
        return nil;
    }
    
    html = output.bp ? [NSString stringWithUTF8String:(char *)output.bp] : nil;
    
    MWImageParser *parser = [[MWImageParser alloc] init];
    parser.images = [NSMutableArray array];
    dispatch_queue_t reentrantAvoidanceQueue = dispatch_queue_create("reentrantAvoidanceQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(reentrantAvoidanceQueue, ^{
        parser.xmlParser = [[NSXMLParser alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]];
        parser.xmlParser.delegate = parser;
        [parser.xmlParser parse];
    });
    dispatch_sync(reentrantAvoidanceQueue, ^{ });
    
    return parser.images;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqual:@"img"]) {
        NSString *src = [attributeDict objectForKey:@"src"];
        if (src) {
            [self.images addObject:src];
        }
    }
}

@end

