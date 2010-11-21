//
//  IssueProperties.m
//  OnlineXml
//
//  Created by Prashant Cholachagudd on 04/10/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "IssueProperties.h"


@implementation IssueProperties

- (IssueProperties *) initWithNumberOfPages: (NSNumber *)numberOfPages height: (NSNumber *)pageHeight width:(NSNumber *)pageWidth {
    if(self = [super init]) {
        totalPages = numberOfPages;
		imageWidth = pageWidth;
        imageheight = pageHeight;
    }
    
    return self;
}

- (NSNumber *) imageWidth {
    return imageWidth;
}
- (NSNumber *) imageHeight{
    return imageheight;
}

- (NSNumber *) totalPages {
    return totalPages;
}

@end
