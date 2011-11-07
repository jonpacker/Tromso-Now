//
//  TromsoNowViewController.h
//  TromsoNow
//
//  Created by Kjostinden on 26.11.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UiTDataProvider.h"
#import "WeatherDataLayer.h"
#import "StatBarView.h"

@interface TromsoNowViewController : UIViewController {
	//IBOutlet UIImageView* webcamImageView;
	//IBOutlet UIActivityIndicatorView* webcamActivityIndicator;
	WeatherDataLayer* weather;
	StatBarView* statBar;
	CGPoint startPoint;
	BOOL isLoading;
}

//@property (nonatomic, retain) UIImageView* webcamImageView;
@property (nonatomic, retain) IBOutlet UIImageView* wImageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* wActivityIndicator;
@property (nonatomic, retain) IBOutlet UIView* contentWrapper;
@property (nonatomic, retain) WeatherDataLayer* weather;
@property (nonatomic, retain) StatBarView* statBar;
@property BOOL isLoading;

-(void) toggleWeatherDataBar;
-(void) loadWebcamImage;
- (void) performReloadLoop ;

@end

