//
//  WeatherDataLayer.m
//  TromsoNow
//
//  Created by Kjostinden on 05.12.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import "WeatherDataLayer.h"


@implementation WeatherDataLayer

@synthesize data;

- (id) initWithDataProvider:(id <WeatherDataProvider>)provider {
	self = [super init];
	if (self != nil) {
		data = [provider retrieveWeatherData]; 
	}
	return self;
}

- (void) dealloc {
	[data release];
	[super dealloc];
}

@end
