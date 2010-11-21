//
//  ComicViewController.h
//  ChandamamaReader
//
//  Created by Prashant Cholachagudd on 19/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicDataParser.h"

@class ImageScrollView;
@class IssueProperties;
@protocol ComicViewController;

@interface ComicViewController : UIViewController<UIScrollViewDelegate, ComicServiceProtocol> {
	UIScrollView *pagingScrollView;
	NSMutableSet *recycledPages;
	NSMutableSet *visiblePages;
	UIToolbar *toolbar;
	ComicDataParser *comicParser;
	IssueProperties *comicProperties;
	
	NSString *comicLanguage;
	NSString *issuedYear;
	NSString *issuedMonth;
	
	int currentPage;
	UITapGestureRecognizer *tapRecognizer;
	BOOL extraHidden;
}

@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) NSString *comicLanguage;
@property (nonatomic, retain) NSString *issuedYear;
@property (nonatomic, retain) NSString *issuedMonth;


- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (void) tilePages;

- (NSUInteger) imageCount;

- (ImageScrollView *) dequeueRecycledPage;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (void) configurePage:(ImageScrollView *)page forIndex:(NSUInteger)index;
- (void) addToolBar;

- (void) gotoPage:(int) pageNumber;
- (void) showToolBarAndNavigation:(BOOL) hidden;

@end
