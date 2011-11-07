//
//  StatBarView.h
//  TromsoNow
//
//  Created by Kjostinden on 07.12.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataBar.h"


@interface StatBarView : UIView {
	UIImageView * barBaseImage;
	UILabel * displayWeatherData;
    UILabel * clockLabel;
	WeatherDataBar * weatherData;
    NSDateFormatter * dateFormatter;
	BOOL showing;
	CGPoint startPoint;
}

-(void) setupView;

@property (nonatomic, retain) UIImageView * barBaseImage;
@property (nonatomic, retain) UILabel * displayWeatherData;
@property (nonatomic, retain) WeatherDataBar * weatherData;
@property (nonatomic, retain) UILabel * clockLabel;
@property BOOL showing;

@end
