//
//  ImageServiceProtocol.h
//  ChandamamaReader
//
//  Created by Prashant Cholachagudd on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PageServiceDelegate
- (void) pageReceived:(UIImage *) image;
- (void) pageReceiveFailed;
@end
