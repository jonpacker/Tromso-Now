//
//  WeatherDataLayer.h
//  TromsoNow
//
//  Created by Kjostinden on 05.12.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherDataProvider

	- (NSDictionary*) retrieveWeatherData;

@end

@interface WeatherDataLayer : NSObject 
	
	{
		NSDictionary *data;
	}

	@property (readonly, nonatomic, retain) NSDictionary* data;

	- (id) initWithDataProvider:(id<WeatherDataProvider>)provider;

@end

