//
//  ComicDataParser.m
//  OnlineXml
//
//  Created by Prashant Cholachagudd on 04/10/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
// http://www.chandamama.com/content/story_img_archive/kannada/story/1949/July/KAN_01071949.xml

#import "ComicDataParser.h"
#import "IssueProperties.h"
#import "GDataXMLNode.h"
#import "Utilities.h"

@implementation ComicDataParser

@synthesize receiver;

-(ComicDataParser *) initWithDependencies:(id <ComicServiceProtocol>) delegate 
								 language:(NSString *) language year:(NSString *)year month:(NSString *)month{
	if(self = [super init])
	{
		[self initMonths];
		receiver = delegate;
		comicLanguage = language;
		issuedYear = year;
		issuedMonth = month;
		threeLetterLanguage = [languageDictionary objectForKey:comicLanguage];
		
		threeLetterMonth = [months objectForKey:issuedMonth];
		monthInNumber = [monthNumbers objectForKey:threeLetterMonth];
		
		return self;
	}
	return nil;
}

- (void) parseComic{
	
	NSString *urlString = [NSString 
						   stringWithFormat:@"http://www.chandamama.com/content/story_img_archive/%@/story/%@/%@/%@_01%@%@.xml"
						   ,comicLanguage
						   ,issuedYear
						   ,issuedMonth
						   ,threeLetterLanguage
						   ,monthInNumber
						   ,issuedYear];
	
	NSURL *comicUrl = [NSURL URLWithString:urlString];
	NSError *error;
	NSData *xmlData = [[NSData alloc] initWithContentsOfURL:comicUrl options:0 error:&error];
	
	if (xmlData == nil) {
		//[utility showNetworkErrorMessage];
		IssueProperties *props = [[IssueProperties alloc] initWithNumberOfPages:[NSNumber numberWithInt:70] 
																		 height:[NSNumber numberWithInt:640]
																		  width:[NSNumber numberWithInt:960]];
		
		[receiver receiveComicDetails:props];
		[props release];
		return;
	}
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData 
														   options:0 error:&error];
	[xmlData release];
    
	NSArray *pages = [doc nodesForXPath:@"//FlippingBook/pages/page" error:nil];
	GDataXMLElement *widthNodes = (GDataXMLElement *) [[doc.rootElement elementsForName:@"width"] objectAtIndex:0];
	GDataXMLElement *heightNodes = (GDataXMLElement *)[[doc.rootElement elementsForName:@"height"] objectAtIndex:0];
    
    NSNumber *width = [self stringToNumber:widthNodes.stringValue];
    NSNumber *height = [self stringToNumber:heightNodes.stringValue];
	NSNumber *totalPages = [self stringToNumber:[NSString stringWithFormat:@"%d", pages.count]];
	[doc release];
	
	IssueProperties *props = [[IssueProperties alloc] initWithNumberOfPages:totalPages 
																	 height:height
																	  width:width];
	
	[receiver receiveComicDetails:props];
	[props release];
}

- (NSNumber *) stringToNumber:(NSString *) stringValue {
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *number = [formatter numberFromString:stringValue];
    [formatter release];
    
    return number;
}

- (NSString *) getPageUrlStringForIndex:(int) index {
	NSString * pageUrlString = 
	[NSString stringWithFormat:@"http://www.chandamama.com/content/story_img_archive/%@/story/%@/%@/%d.jpg",
	 comicLanguage,
	 issuedYear,
	 issuedMonth,
	 ++index];
	
	return pageUrlString;
}


- (void) initMonths {
	months = [NSDictionary dictionaryWithObjectsAndKeys:
			  @"JAN",@"January",
			  @"FEB",@"February",
			  @"MAR",@"March",
			  @"APR",@"April",
			  @"MAY",@"May",
			  @"JUN",@"June",
			  @"JUL",@"July",
			  @"AUG",@"August",
			  @"SEP",@"September",
			  @"OCT",@"October",
			  @"NOV",@"November",
			  @"DEC",@"December", 
			  nil];
	
	monthNumbers = [NSDictionary dictionaryWithObjectsAndKeys:
					@"01", @"JAN",
					@"02", @"FEB",
					@"03", @"MAR",
					@"04", @"APR",
					@"05", @"MAY",
					@"06", @"JUN",
					@"07", @"JUL",
					@"08", @"AUG",
					@"09", @"SEP",
					@"10", @"OCT",
					@"11", @"NOV",
					@"12", @"DEC",
					nil];
	languageDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
							@"ENG", @"english", 
							@"KAN", @"kannada",
							@"HIN", @"hindi", 
							nil];
}

-(void) dealloc {
	[super dealloc];
}

@end
