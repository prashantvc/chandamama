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
	
	id<PageServiceDelegate> pageServiceDelegate;
}

- (id) initWithImageProtocol:(id<PageServiceDelegate>) protocol; 
- (void) loadImage:(NSURL *) url;

@end
