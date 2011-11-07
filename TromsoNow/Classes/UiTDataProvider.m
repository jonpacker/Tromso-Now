//
//  UiTDataProvider.m
//  TromsoNow
//
//  Created by Kjostinden on 05.12.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import "UiTDataProvider.h"

static NSString * const UIT_SAMPLE_URL = @"http://jonpacker.com/uitds/uitds.php";

@implementation UiTDataProvider

@synthesize weatherData, currentProperty;

- (NSArray*) retrieveWeatherData {
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:UIT_SAMPLE_URL]];
	
	if (weatherData) [weatherData release];
	
	weatherData = [[NSMutableArray alloc] init];
	
	xmlParser.delegate = self;
	xmlParser.shouldProcessNamespaces = NO;
	xmlParser.shouldReportNamespacePrefixes = NO;
	xmlParser.shouldResolveExternalEntities = NO;
	
	[xmlParser parse];
	[xmlParser release];
	
	return [NSArray arrayWithArray:weatherData];
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (self.currentProperty) {
		[currentProperty appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser 
					didStartElement:(NSString *)elementName 
					   namespaceURI:(NSString *)namespaceURI 
                      qualifiedName:(NSString *)qName 
	                     attributes:(NSDictionary *)attributeDict {
	//if (qName) elementName = qName;
	
	if (currentCategory == nil && ![elementName isEqualToString:@"sample"])
	{
		currentCategory = [NSMutableString stringWithString:elementName];
	}
	else 
	{
		currentUnit = [attributeDict objectForKey:@"unit"];
		currentProperty = [NSMutableString string];
	}
}

- (void)parser:(NSXMLParser *)parser 
					  didEndElement:(NSString *)elementName 
					   namespaceURI:(NSString *)namespaceURI 
					  qualifiedName:(NSString *)qName {
	if (qName) elementName = qName;
	
	if (currentCategory != nil && [currentCategory isEqualToString:elementName])
	{
		currentCategory = nil;
		return;
	}
	
	if (self.currentProperty != nil) 
	{
		///NSLog(@"Adding %@ %@ %@", currentProperty, elementName, currentUnit);
		NSString* label;
		if ([currentCategory isEqualToString:@"radiation"])
		{
			label = [NSString stringWithFormat:@"%@ %@", elementName, currentCategory];
		}
		else 
		{
			label = [NSString stringWithFormat:@"%@ %@", currentCategory, elementName];
		}
		
		id uObj = [WeatherDataEntity entityWithValue:currentProperty label:label unit:currentUnit];
		
		if ([elementName isEqualToString:@"temperature"] || [elementName isEqualToString:@"speed"])
		{
			[weatherData insertObject:uObj atIndex:0];
		}
		else if ([elementName isEqualToString:@"humidity"])
		{
			[weatherData insertObject:uObj atIndex:2];
		}
		else {
			[weatherData addObject:uObj];
		}
		
	}
	
	currentProperty = nil;
}
	
- (void) dealloc {
	[weatherData release];
	[super dealloc];
}

@end
