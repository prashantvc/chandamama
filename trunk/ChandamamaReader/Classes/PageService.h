//
//  ImageService.h
//  ChandamamaReader
//
//  Created by Prashant Cholachagudd on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageServiceDelegate.h"

@protocol PageServiceDelegate;

@interface PageService : NSObject {
	NSURLConnection *connection;
	NSMutableData *data;
	NSURL *pageUrl;
	
	NSString* currentLaguage;
	NSString* issuedYear;
	NSString* issuedMonth;
	int currentPage;
	
	id<PageServiceDelegate> pageServiceDelegate;
}

- (id) initWithImageProtocol:(id<PageServiceDelegate>) protocol; 
- (void) cacheImageWithFilename: (UIImage *) image imageFileName:(NSString *)filename;
- (UIImage *) getCachedImageForFilename:(NSString *)filename;
- (void) loadImageFromURL:(NSURL *)url forLanguage:(NSString *)langauge forYear:(NSString *)year forMonth:(NSString *)month pageNumber:(int)number;

@end
