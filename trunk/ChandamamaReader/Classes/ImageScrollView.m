#import "ImageScrollView.h"
#import "ChandamamaConstants.h"

@implementation ImageScrollView
@synthesize index;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.scrollsToTop=YES;
        self.delegate = self;
    }
	
	pageService = [[PageService alloc] initWithImageProtocol:self];
	
    return self;
}

- (void)dealloc
{
    [imageView release];
	[connection cancel]; //in case the URL is still downloading
	[connection release];
	[data release];
	[pageService release];
    [super dealloc];
}

#pragma mark -
#pragma mark Override layoutSubviews to center content

- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen

    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    imageView.frame = frameToCenter;
    
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

#pragma mark -
#pragma mark Configure scrollView to display new image (tiled or not)

- (void)displayImage:(UIImage *)image
{
    // clear the previous imageView
    [imageView removeFromSuperview];
    [imageView release];
    imageView = nil;
    
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;

    // make a new UIImageView for the new image
    imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
    
    [self configureForImageSize:[image size]];
}

- (void)configureForImageSize:(CGSize)imageSize 
{
    CGSize boundsSize = [self bounds].size;
                
    // set up our content size and min/max zoomscale
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 2;

    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
    if (minScale > maxScale) {
        minScale = maxScale;
    }
        
    self.contentSize = imageSize;
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;  // start out with the content fully visible
}


- (void)loadImageFromURL:(NSURL*)url {
	if ([[self subviews] count]>0) {
		//then this must be another image, the old one is still in subviews
		[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
	}
	
	pageUrl = url;
	
	NSLog(@"%@", [pageUrl relativePath]);
	
	CGRect activityFrame;
	activityFrame.size.width = 50;
	activityFrame.size.height = 50;
	activityFrame.origin.x=(self.bounds.size.width / 2) - 25;
	activityFrame.origin.y=(self.bounds.size.height / 2) - 25;
	
	UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:activityFrame];
	[activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	[self addSubview:activity];
	[activity startAnimating];
	[activity release];
	
	
	[pageService loadImage:pageUrl];
}

//just in case you want to get the image directly, here it is in subviews
- (UIImage*) image {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}

#pragma mark -
#pragma mark PageServiceDelegate

- (void) pageReceived:(UIImage *)image {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	if ([[self subviews] count]>0) {
		[[[self subviews] objectAtIndex:0] removeFromSuperview];
	}
	
	// clear the previous imageView
    [imageView removeFromSuperview];
    [imageView release];
    imageView = nil;
	
	// reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
	
	// make a new UIImageView for the new image
	if (image != nil) {
		UIImage *page = [image retain];
		imageView = [[UIImageView alloc] initWithImage:page];
		[self addSubview:imageView];
		[self configureForImageSize:[page size]];
		[page release];
	}
}

- (void) pageReceiveFailed {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Connection Error"
						  message:@"You have a connection failure. You have to get on a wi-fi or a cell network to get a comic pages."
						  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	if ([[self subviews] count]>0) {
		[[[self subviews] objectAtIndex:0] removeFromSuperview]; 
	}	
	
	//make an image view for the imagee
	UIImage *image = [[UIImage imageNamed:@"photoDefault"] retain];
	imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
    [self configureForImageSize:[image size]];
	[image release];
}

@end
