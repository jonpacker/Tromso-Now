//
//  UiTDataProvider.h
//  TromsoNow
//
//  Created by Kjostinden on 05.12.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherDataLayer.h"
#import "WeatherDataEntity.h"

@interface UiTDataProvider : NSObject <NSXMLParserDelegate> 
{
	NSMutableArray *weatherData;
	NSMutableString *currentProperty;
	NSMutableString *currentCategory;
	NSString* currentUnit;
}
- (NSArray*) retrieveWeatherData;
@property (nonatomic, retain) NSMutableArray* weatherData;
@property (nonatomic, retain) NSMutableString* currentProperty;

@end
