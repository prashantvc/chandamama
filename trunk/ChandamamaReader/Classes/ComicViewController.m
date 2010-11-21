//
//  ComicViewController.m
//  ChandamamaReader
//
//  Created by Prashant Cholachagudd on 19/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ComicViewController.h"
#import "ImageScrollView.h" 
#import "ComicDataParser.h"
#import "IssueProperties.h"

@implementation ComicViewController

@synthesize toolbar;
@synthesize comicLanguage;
@synthesize issuedYear;
@synthesize issuedMonth;

- (void) viewDidLoad {
	CGRect pagingScrollViewFrame = [self frameForPagingScrollView];

	comicParser = [[ComicDataParser alloc] initWithDependencies:self language:comicLanguage year:issuedYear month:issuedMonth];
				   
	[comicParser parseComic];
	self.title = [NSString stringWithFormat:@"%@ %@", issuedMonth, issuedYear];
	
    pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    pagingScrollView.pagingEnabled = YES;
    pagingScrollView.backgroundColor = [UIColor blackColor];
	pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
	pagingScrollView.contentSize = CGSizeMake(pagingScrollViewFrame.size.width * [self imageCount], 
											  pagingScrollViewFrame.size.height);
	pagingScrollView.delegate = self;
	
	self.wantsFullScreenLayout = YES;
	pagingScrollView.scrollsToTop = YES;
	[self.view addSubview:pagingScrollView];
	
	recycledPages = [[NSMutableSet alloc] init];
	visiblePages = [[NSMutableSet alloc] init];
	currentPage = 0;
	
	tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)] autorelease];
	[self.view addGestureRecognizer:tapRecognizer];
	//[tapRecognizer release];
	extraHidden = NO;
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
	extraHidden = !extraHidden;
	[self showToolBarAndNavigation:extraHidden];
}
	
	
-(void) viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	[[UIApplication sharedApplication] 
	 setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated: YES];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	[self addToolBar];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self tilePages];
}

- (void) viewWillDisappear:(BOOL)animated {
	[toolbar removeFromSuperview];
	[super viewWillDisappear:YES];
	[[UIApplication sharedApplication] 
	 setStatusBarStyle:UIStatusBarStyleDefault animated: YES];
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

-(void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[comicParser release];
	comicParser = nil;
	[comicProperties release];
	comicParser =nil;

}

- (void) addToolBar {
	toolbar = [[UIToolbar alloc] init];
	[toolbar sizeToFit];
	[toolbar setBarStyle:UIBarStyleBlackTranslucent];
	
	//Caclulate the height of the toolbar
	CGFloat toolbarHeight = [toolbar frame].size.height;
	
	//Get the bounds of the parent view
	CGRect rootViewBounds = self.parentViewController.view.bounds;
	
	//Get the height of the parent view.
	CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
	
	//Get the width of the parent view,
	CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
	
	//Create a rectangle for the toolbar
	CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
	
	//Reposition and resize the receiver
	[toolbar setFrame:rectArea];
	
	UIBarButtonItem *previous = [[UIBarButtonItem alloc] 
								 initWithImage:[UIImage imageNamed:@"previousIcon"] style:UIBarButtonItemStylePlain 
								 target:self action:@selector(previousButtonPressed:)];
	
	UIBarButtonItem *space = [[UIBarButtonItem alloc] 
							  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	
	UIBarButtonItem *next = [[UIBarButtonItem alloc] 
							 initWithImage:[UIImage imageNamed:@"nextIcon"] style:UIBarButtonItemStylePlain 
							 target:self action:@selector(nextButtonPressed:)];
	[toolbar setItems:[NSArray arrayWithObjects:previous,space,next,nil]];
	[previous release];
	[space release];
	[next release];
	
	[self.navigationController.view addSubview:toolbar];
	//[toolbar release];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}

#pragma mark -
#pragma mark  Frame calculations
#define PADDING  10

- (CGRect)frameForPagingScrollView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    
    CGRect pageFrame = pagingScrollViewFrame;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (pagingScrollViewFrame.size.width * index);
    return pageFrame;
}

#pragma mark -
#pragma mark Tiling and page configuration

- (void) tilePages {
	
	CGRect visibleBounds = pagingScrollView.bounds;
	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self imageCount] - 1);
	
	//Re-cycle no longer visible pages
	for (ImageScrollView *page in visiblePages) {
		if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
	}
	[visiblePages minusSet:recycledPages];
	
	// add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            ImageScrollView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[ImageScrollView alloc] init] autorelease];
				[page setContentOffset:CGPointMake(0.0, 0.0)];
            }
            [self configurePage:page forIndex:index];
            [pagingScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }    
	
}

- (void)configurePage:(ImageScrollView *)page forIndex:(NSUInteger)index {
    page.index = index;
    page.frame = [self frameForPageAtIndex:index];
	currentPage = index;
	NSLog(@"Current page %d %@", index, pagingScrollView);
	NSURL *url  =[NSURL URLWithString: [comicParser getPageUrlStringForIndex:currentPage]];
	[page loadImageFromURL:url];
}

- (ImageScrollView *) dequeueRecycledPage {
    ImageScrollView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL) isDisplayingPageForIndex:(NSUInteger)index {
    BOOL foundPage = NO;
    for (ImageScrollView *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void) showToolBarAndNavigation:(BOOL) hidden {
	if (extraHidden) {
		[[UIApplication sharedApplication] setStatusBarHidden:extraHidden withAnimation:UIStatusBarAnimationFade];
		
		[UIView animateWithDuration:0.33 animations:^{
			[toolbar setAlpha:0.0];
			[self.navigationController.navigationBar setAlpha:0.0];
		} completion:^(BOOL finished){
			if (finished) {
				[toolbar removeFromSuperview];	
				self.navigationController.navigationBar.hidden = extraHidden;
			}
		}];
		
	}else {
		[[UIApplication sharedApplication] setStatusBarHidden:extraHidden withAnimation:UIStatusBarAnimationFade];
		
		self.navigationController.navigationBar.hidden = extraHidden;
		[self.navigationController.view addSubview:toolbar];
		
		[UIView animateWithDuration:0.33 animations:^{
			[toolbar setAlpha:1];
			[self.navigationController.navigationBar setAlpha:1];
		}];
	}
}

#pragma mark -
#pragma mark Image wrangling


- (NSUInteger) imageCount {
	static NSUInteger __count = NSNotFound;  // only count the images once
    if (__count == NSNotFound) {
        __count = [[comicProperties totalPages] intValue];
    }
    return __count;
}

#pragma mark -
#pragma mark Button selector

-(void) previousButtonPressed:(id) sender {
	if (currentPage > 0) {
		[self gotoPage: --currentPage];
	}
}

-(void) nextButtonPressed:(id) sender {
	if (currentPage < [self imageCount]) {
		[self gotoPage: ++currentPage];
	}
}

- (void) receiveComicDetails:(IssueProperties *) details{
	[comicProperties release];
	comicProperties = [details retain];
}

- (void) gotoPage:(int)pageNumber {
	NSLog(@"pageNumber page %d", pageNumber);
	CGRect frame = pagingScrollView.frame;
	frame.origin.x = frame.size.width * pageNumber;
	frame.origin.y = 0;
	[pagingScrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark -

- (void)viewDidUnload {
	[super viewDidUnload];
	[pagingScrollView release];
	pagingScrollView = nil;
	[recycledPages release];
	recycledPages = nil;
	[visiblePages release];
	visiblePages = nil;
	[toolbar release];
	toolbar = nil;
	[comicParser release];
	comicParser = nil;
	[comicProperties release];
	comicParser =nil;
	[tapRecognizer release];
	tapRecognizer = nil;
}

- (void)dealloc {
	[pagingScrollView release];
	[comicLanguage release];
	[issuedYear release];
	[issuedMonth release];
    [super dealloc];
}

@end

