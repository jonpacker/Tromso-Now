//
//  WeatherDataEntity.h
//  TromsoNow
//
//  Created by Kjostinden on 26.01.11.
//  Copyright 2011 Creative Intersection. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeatherDataEntity : NSObject {
	NSString* value;
  NSNumber* valueAsNumber;
	NSString* label;
	NSString* unit;
}

+ (WeatherDataEntity*) entityWithValue:(NSString*)value label:(NSString*)label unit:(NSString*)unit;

@property (nonatomic, copy) NSString* value;
@property (nonatomic, copy) NSString* unit;
@property (nonatomic, copy) NSString* label;

@end
