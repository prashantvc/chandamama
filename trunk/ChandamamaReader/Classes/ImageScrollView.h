
#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView <UIScrollViewDelegate> {
    UIView        *imageView;
    NSUInteger     index;
	
	NSURLConnection* connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData* data;
	NSURL *pageUrl;
}
@property (assign) NSUInteger index;

- (void)displayImage:(UIImage *)image;
- (void)configureForImageSize:(CGSize)imageSize;

- (void)loadImageFromURL:(NSURL*)url;
- (UIImage*) image;
@end
