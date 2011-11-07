//
//  TromsoNowViewController.m
//  TromsoNow
//
//  Created by Kjostinden on 26.11.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import "TromsoNowViewController.h"

@implementation TromsoNowViewController

@synthesize wActivityIndicator, wImageView, weather, statBar, contentWrapper;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isLoading = NO;
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//CGFloat targetWidth = 1024, targetHeight = 768;
	//CGFloat currentWidth = self.wImageView.frame.size.width;
	//CGFloat currentHeight = self.wImageView.frame.size.height;
	
	//CGFloat widthTransformFactor = targetWidth / currentWidth;
	//CGFloat heightTransformFactor = targetHeight / currentHeight;
	
	//CGAffineTransform sizeTransform = CGAffineTransformIdentity;
	//sizeTransform = CGAffineTransformScale(sizeTransform, widthTransformFactor, heightTransformFactor);
	
	self.isLoading = YES;
	[self performReloadLoop];
	
	CGRect statBarFrame = CGRectMake(0.0f, 733.0f, 1024.0f, 137.0f);
	statBar = [[StatBarView alloc] initWithFrame:statBarFrame];
	[self.contentWrapper addSubview:statBar];
    self.contentWrapper.layer.cornerRadius = 10.0f;
    self.contentWrapper.layer.masksToBounds = YES;
	[statBar setupView];
} 

- (void) loadWebcamImage {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	NSData *webcamImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://weather.cs.uit.no/wcam0_snapshots/wcam0_latest_medium.jpg"]];
	//NSData *webcamImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://weather.cs.uit.no/wcam0_snapshots/wcam0_latest_full.jpg"]];
	
	UIImage *webcamImage = [UIImage imageWithData:webcamImageData];
	
	self.wImageView.image = webcamImage;
	
	self.isLoading = NO;
	[self.contentWrapper setNeedsDisplay];
	
	[pool release];
}

- (BOOL) isLoading 
{
	return isLoading;
}

- (void) setIsLoading:(BOOL)loading
{
	if (loading != isLoading)
	{
		if (loading) 
		{
			[self.wActivityIndicator startAnimating];
		}
		else 
		{
			[self.wActivityIndicator stopAnimating];
		}
	}
	
	isLoading = loading;
}
	 
- (void) performReloadLoop 
{
	self.isLoading = YES;
	[self performSelectorInBackground:@selector(loadWebcamImage) withObject:nil];
	[statBar.weatherData refreshData];
	[self performSelector:@selector(performReloadLoop) withObject:nil afterDelay:10.0];
}


- (void) toggleWeatherDataBar {
	statBar.showing = !statBar.showing;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[WeatherDataLayer release];
	[statBar release];
	
    [super dealloc];
}

@end
