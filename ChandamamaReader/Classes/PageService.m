//
//  ImageService.m
//  ChandamamaReader
//
//  Created by Prashant Cholachagudd on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PageService.h"
#import "PageServiceDelegate.h"

@implementation PageService

- (id) initWithImageProtocol:(id <PageServiceDelegate>)protocol {

	if ((self = [super init])) {
		pageServiceDelegate = protocol;
	}
	
	return self;
}

- (void) loadImage:(NSURL *) url{
	pageUrl = url;
	
	if (connection != nil) {
		[connection release];
		connection = nil;
	}
	
	if (data != nil) {
		[data release];
		data = nil;
	}
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:pageUrl 
												  cachePolicy:1 timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request
												 delegate:self];
	[request release];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)incrementalData {
	if (data == nil) {
		data = [[NSMutableData alloc] init];
	}
	
	[data appendData:incrementalData];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)theConnection {
	[connection release];
	connection = nil;
	
	if (data != nil) {
		UIImage *image  = [UIImage imageWithData:data];
		[pageServiceDelegate pageReceived:image];
	}
}

- (void) connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
	[data release];
	data = nil;
	[connection cancel];
	[connection release];
	connection = nil;	
	
	[pageServiceDelegate pageReceiveFailed];
}

- (void) dealloc {
	[connection cancel];
	[connection release];
	[data release];
	[super dealloc];
}

@end
