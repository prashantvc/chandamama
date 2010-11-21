//
//  IssueProperties.h
//  OnlineXml
//
//  Created by Prashant Cholachagudd on 04/10/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IssueProperties;

@interface IssueProperties : NSObject {
    @private
    NSNumber *totalPages;
    NSNumber *imageWidth;
    NSNumber *imageheight;
}

- (IssueProperties *) initWithNumberOfPages: (NSNumber *)numberOfPages height: (NSNumber *)pageHeight width:(NSNumber *)pageWidth;

- (NSNumber *) totalPages;
- (NSNumber *) imageWidth;
- (NSNumber *) imageHeight;

@end
