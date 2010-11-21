
#import <UIKit/UIKit.h>
#import "PageServiceDelegate.h"
#import "PageService.h"

@class PageService;

@interface ImageScrollView : UIScrollView <UIScrollViewDelegate, PageServiceDelegate> {
    UIView        *imageView;
    NSUInteger     index;
	PageService *pageService;
	
}
@property (assign) NSUInteger index;

- (void)displayImage:(UIImage *)image;
- (void)configureForImageSize:(CGSize)imageSize;

- (void)loadImageFromURL:(NSURL *)url forLanguage:(NSString*) langauge forYear:(NSString*) year forMonth:(NSString *) month pageNumber:(int) number;
- (UIImage*) image;
@end
