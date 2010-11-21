
#import <UIKit/UIKit.h>
#import "PageServiceDelegate.h"
#import "PageService.h"

@class PageService;

@interface ImageScrollView : UIScrollView <UIScrollViewDelegate, PageServiceDelegate> {
    UIView        *imageView;
    NSUInteger     index;
	
	NSURLConnection* connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData* data;
	NSURL *pageUrl;
	PageService *pageService;
	
}
@property (assign) NSUInteger index;

- (void)displayImage:(UIImage *)image;
- (void)configureForImageSize:(CGSize)imageSize;

- (void)loadImageFromURL:(NSURL*)url;
- (UIImage*) image;
@end
