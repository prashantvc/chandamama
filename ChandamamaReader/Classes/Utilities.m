//
//  Utilities.m
//  StackTraceApp
//
//  Created by Prashant Cholachagudd on 18/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"
#import "ChandamamaConstants.h"

@implementation Utilities

+ (UIImage *) imageFromURL:(NSURL*) anUrl {
	NSData *urlData = [NSData dataWithContentsOfURL:anUrl];
	UIImage *image = [[[UIImage alloc] initWithData:urlData] autorelease];
	return image;
}

+ (UIImage *) getImageStringUrl:(NSString*)urlString {
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[url autorelease];
	return [self imageFromURL:url];
}

- (void) cacheImageWithFilename: (NSString *) ImageURLString imageFileName:(NSString *)filename;
{
    NSURL *ImageURL = [NSURL URLWithString: ImageURLString];
	// Generate a unique path to a resource representing the image you want
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
	
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        // The file doesn't exist, we should get a copy of it

        // Fetch image
        NSData *data = [[NSData alloc] initWithContentsOfURL:ImageURL];
		
		if (data == nil) {
			[self showNetworkErrorMessage];
			return;
		}
		
        UIImage *image = [[UIImage alloc] initWithData: data];
		[data release];
        
        
        // Is it PNG or JPG/JPEG?
        // Running the image representation function writes the data from the image to a file
		if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
		{
			if([ImageURLString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
			{
				[UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
			}
			else if(
					[ImageURLString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound || 
					[ImageURLString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
					)
			{
				[UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
			}
		}
		
		[image release];
    }
}

- (UIImage *) getCachedImageForFilename: (NSString *) ImageURLString imageFileName:(NSString *)filename
{
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    UIImage *image;
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        image = [UIImage imageWithContentsOfFile: uniquePath]; // this is the cached image
    }
    else
    {
        // get a new one
        [self cacheImageWithFilename:ImageURLString imageFileName:filename];
        image = [UIImage imageWithContentsOfFile: uniquePath];
    }
	
    return image;
}

- (void) showNetworkErrorMessage {
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Connection Error"
						  message:@"You have a connection failure. You have to get on a wi-fi or a cell network to get a internet connection."
						  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}


@end
