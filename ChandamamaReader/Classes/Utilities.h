//
//  Utilities.h
//  StackTraceApp
//
//  Created by Prashant Cholachagudd on 18/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject {

}

- (void) cacheImageWithFilename: (NSString *) ImageURLString imageFileName:(NSString *)filename;
- (UIImage *) getCachedImageForFilename: (NSString *) ImageURLString imageFileName:(NSString *)filename;
- (void) showNetworkErrorMessage;

+ (UIImage *) getImageStringUrl:(NSString*)urlString;
+ (UIImage *) imageFromURL:(NSURL *)anUrl;
@end
