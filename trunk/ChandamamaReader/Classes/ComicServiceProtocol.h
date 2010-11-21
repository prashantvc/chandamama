//
//  ComicServiceProtocol.h
//  ChandamamaReader
//
//  Created by Prashant Cholachagudd on 03/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@class IssueProperties;

@protocol ComicServiceProtocol
- (void) receiveComicDetails:(IssueProperties *) details;
@end