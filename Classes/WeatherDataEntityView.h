//
//  WeatherDataEntity.h
//  TromsoNow
//
//  Created by Kjostinden on 30.12.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WeatherDataEntity.h"
#import "WeatherDataGraphView.h"


@interface WeatherDataEntityView : UIView {
	WeatherDataEntity* data;
	WeatherDataGraphView* _graph;
  
	UILabel* dataLabel;
	UILabel* unitLabel;
	UILabel* labelLabel;
  
  BOOL showsDrawerEdge;
  
	CGFloat labelWidth;
	BOOL minified;
}

-(id) initWithData:(WeatherDataEntity*)wdata graphData:(NSArray*)data atPoint:(CGPoint)point; 
- (void) setupGraphWithData:(NSArray*)data;

+ (NSString*) graphKeyForLabel:(NSString*)kLabel;

@property (nonatomic, retain) WeatherDataEntity* data;

@property (nonatomic, retain) UILabel* dataLabel;
@property (nonatomic, retain) UILabel* unitLabel;
@property (nonatomic, retain) UILabel* labelLabel;
@property (nonatomic, retain) UIImageView* drawerEdgeImage;
@property (nonatomic, readonly, retain) WeatherDataGraphView* graph;

@property BOOL showsDrawerEdge;
@property BOOL minified;

@end
