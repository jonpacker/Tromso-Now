//
//  WeatherDataEntity.m
//  TromsoNow
//
//  Created by Kjostinden on 26.01.11.
//  Copyright 2011 Creative Intersection. All rights reserved.
//

#import "WeatherDataEntity.h"


@implementation WeatherDataEntity

@synthesize  unit, label;

+ (WeatherDataEntity*) entityWithValue:(NSString*)value label:(NSString*)label unit:(NSString*)unit 
{
	WeatherDataEntity* inst = [WeatherDataEntity new];
	inst.value = value;
	inst.label = label;
	inst.unit = unit;
	return inst;
}

- (NSString*) value
{
  return [valueAsNumber stringValue];
}

- (void) setValue:(NSString *)kValue
{
  value = kValue;
  valueAsNumber = [NSNumber numberWithFloat:[kValue floatValue]];
}

-(void) dealloc
{
	[value release];
	[unit release];
	[label release];
	[super dealloc];
}

@end
