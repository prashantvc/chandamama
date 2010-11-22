//
//  ComicDataParser.h
//  OnlineXml
//
//  Created by Prashant Cholachagudd on 04/10/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComicServiceProtocol.h"
#import "Utilities.h"

@class ComicDataParser;
@class IssueProperties;
@protocol ComicServiceProtocol;

@interface ComicDataParser : NSObject {
	id <ComicServiceProtocol> receiver;
	NSString* comicLanguage;
	NSString* issuedYear;
	NSString* issuedMonth;
	
	NSString *threeLetterMonth;
	NSString *monthInNumber;
	NSString *threeLetterLanguage;
	
	NSDictionary *months;
	NSDictionary *monthNumbers;
	NSDictionary *languageDictionary;
}

- (void) parseComic;
- (NSNumber *) stringToNumber:(NSString *) stringValue;
- (ComicDataParser *) initWithDependencies:(id <ComicServiceProtocol>) delegate 
								  language:(NSString *) language year:(NSString *)year month:(NSString *)month;
- (void) initMonths;
- (NSString *) getPageUrlStringForIndex:(int) index;

@property (nonatomic, retain) id<ComicServiceProtocol> receiver;

@end
