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
	
	UILabel* dataLabel;
	UILabel* unitLabel;
	UILabel* labelLabel;
	UIButton* detailDisclosure;
  UIActivityIndicatorView* activityIndicator;
  
  BOOL showsDrawerEdge;
  
	CGFloat labelWidth;
	BOOL minified;
}

-(id) initWithData:(WeatherDataEntity*)wdata atPoint:(CGPoint)point; 
- (void) becomeGraphWithData:(NSArray*)data;

+ (NSString*) graphKeyForLabel:(NSString*)kLabel;

@property (nonatomic, retain) WeatherDataEntity* data;

@property (nonatomic, retain) UILabel* dataLabel;
@property (nonatomic, retain) UILabel* unitLabel;
@property (nonatomic, retain) UILabel* labelLabel;
@property (nonatomic, retain) UIButton* detailDisclosure;
@property (nonatomic, retain) UIImageView* drawerEdgeImage;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;
@property BOOL loading;

@property BOOL showsDrawerEdge;
@property BOOL minified;

@end
