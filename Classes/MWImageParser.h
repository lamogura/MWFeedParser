//
//  MWImageParser.h
//  Pods
//
//  Created by Darshan Patil on 12/22/15.
//
//

#import <Foundation/Foundation.h>

@interface MWImageParser: NSObject<NSXMLParserDelegate>

@property (nonatomic, retain) NSXMLParser *xmlParser;
@property (nonatomic, retain) NSMutableArray *images;


+ (NSArray *) parseImagesFromXHTMLString:(NSString *)html;

@end