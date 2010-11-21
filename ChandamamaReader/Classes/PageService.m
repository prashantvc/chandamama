//
//  ImageService.m
//  ChandamamaReader
//
//  Created by Prashant Cholachagudd on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PageService.h"
#import "PageServiceDelegate.h"
#import "ChandamamaConstants.h"

@implementation PageService

- (id) initWithImageProtocol:(id <PageServiceDelegate>)protocol {

	if ((self = [super init])) {
		pageServiceDelegate = protocol;
	}
	
	return self;
}

- (void) loadImageFromURL:(NSURL *)url forLanguage:(NSString *)langauge 
				  forYear:(NSString *)year forMonth:(NSString *)month pageNumber:(int)number {

	pageUrl = url;
	currentLaguage = langauge;
	issuedYear = year;
	issuedMonth = month;
	currentPage = number;
	
	
	if (connection != nil) {
		[connection release];
		connection = nil;
	}
	
	if (data != nil) {
		[data release];
		data = nil;
	}
	
	UIImage *image = [self getCachedImageForFilename:[NSString stringWithFormat:FILE_NAME_FORMAT, currentLaguage, 
													  issuedYear, issuedMonth, currentPage]];
	
	if (image == nil) {
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:pageUrl 
													  cachePolicy:1 timeoutInterval:60.0];
		connection = [[NSURLConnection alloc] initWithRequest:request
													 delegate:self];
		[request release];
	}else {
		[pageServiceDelegate pageReceived:image];
	}
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

		[self cacheImageWithFilename:image imageFileName:[NSString stringWithFormat:FILE_NAME_FORMAT, currentLaguage, 
														  issuedYear, issuedMonth, currentPage]]; 
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

#pragma mark-
#pragma mark Image Caching

- (void) cacheImageWithFilename: (UIImage *) image imageFileName:(NSString *)filename;
{
	// Generate a unique path to a resource representing the image you want
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
	
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
		
		UIImage * localImage = [image retain];
        // Is it PNG or JPG/JPEG?
        // Running the image representation function writes the data from the image to a file
		if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
		{
			if([filename rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
			{
				[UIImagePNGRepresentation(localImage) writeToFile: uniquePath atomically: YES];
			}
			else if(
					[filename rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound || 
					[filename rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
					)
			{
				[UIImageJPEGRepresentation(localImage, 100) writeToFile:uniquePath atomically:YES];
			}
		}
		
		[localImage release];
    }
}

- (UIImage *) getCachedImageForFilename:(NSString *)filename
{
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    UIImage *localImage = nil;
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        localImage = [UIImage imageWithContentsOfFile: uniquePath]; // this is the cached image
    }
	
    return localImage;
}

@end
