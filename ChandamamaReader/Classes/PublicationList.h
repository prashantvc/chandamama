//
//  PublicationList.h
//  ChandamamaReader
//
//  Created by Prashant Cholachagudd on 18/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
// This is test comment added to test check ins

#import <UIKit/UIKit.h>
#import "ModalViewDelegate.h"


@interface PublicationList : UITableViewController<ModalViewDelegate> {
	NSString *language;
	NSString *issuesListFilePath;
	NSMutableArray *issues;
	NSArray *months;
	NSString *comicLanguage;
	
	NSString *navigationTitle;
}

@property (nonatomic, retain) NSString *issuesListFilePath;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSMutableArray *issues;
@property (nonatomic, retain) NSArray *months;
@property (nonatomic, retain) NSString *comicLanguage;
@property (nonatomic, retain) NSString *navigationTitle;

- (void) loadInitialData;
- (void)showDeleteConfirmAlert;

@end
