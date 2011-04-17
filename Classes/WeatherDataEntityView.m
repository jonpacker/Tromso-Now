//
//  WeatherDataEntity.m
//  TromsoNow
//
//  Created by Kjostinden on 30.12.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import "WeatherDataEntityView.h"


@implementation WeatherDataEntityView

@synthesize
	dataLabel,
	unitLabel,
	labelLabel,drawerEdgeImage;

-(id) initWithData:(WeatherDataEntity*)wdata graphData:(NSArray*)graphData atPoint:(CGPoint)point
{
	if ((self = [super initWithFrame:CGRectMake(point.x, point.y, 300.0f, 135.0f)]) != nil)
	{
		minified = NO;

		dataLabel = [UILabel new];
		unitLabel = [UILabel new];
		labelLabel = [UILabel new];
    
    self.clipsToBounds = NO;
		self.data = wdata;
    
    UIView* backgroundImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 223, 137)];
    backgroundImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar"]];
    [self addSubview:backgroundImage];
    [backgroundImage release];

    UIButton* plusminus = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [plusminus setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [plusminus setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateSelected];
    
    plusminus.frame = CGRectMake(0, 0, 30, 30);
    plusminus.center = CGPointMake(223 + 17, 73);
    plusminus.transform = CGAffineTransformScale(plusminus.transform, 0.9, 0.9);
    plusminus.alpha = 0.8;
    plusminus.enabled = YES;
    
    [plusminus addTarget:self action:@selector(display) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:plusminus];
    
		dataLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
		unitLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
		labelLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);

		dataLabel.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.58f];
		unitLabel.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.58f];
		labelLabel.shadowColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];

		labelLabel.textColor = [UIColor colorWithRed:0.1372f green:0.145f blue:0.1608f alpha:1.0f];
		unitLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.73f];
		dataLabel.textColor = [UIColor whiteColor];

		UIFont* labelFont = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    
		dataLabel.adjustsFontSizeToFitWidth = YES;
		dataLabel.font = [UIFont fontWithName:@"Helvetica" size:72.0f];
		labelLabel.font = labelFont;
		unitLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];

		dataLabel.textAlignment = UITextAlignmentLeft;
		labelLabel.textAlignment = UITextAlignmentLeft;
		unitLabel.textAlignment = UITextAlignmentLeft;

		dataLabel.backgroundColor = [UIColor clearColor];
		labelLabel.backgroundColor = [UIColor clearColor];
		unitLabel.backgroundColor = [UIColor clearColor];
    
    self.layer.masksToBounds = NO;
    self.showsDrawerEdge = YES;
    drawerEdgeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"graphcapl.png"]];
    drawerEdgeImage.center = CGPointMake(223 + (drawerEdgeImage.frame.size.width/2), (drawerEdgeImage.frame.size.height/2)+2);
    drawerEdgeImage.hidden = !self.showsDrawerEdge;
		[self addSubview:drawerEdgeImage];
    
		labelWidth = [labelLabel.text sizeWithFont:labelFont].width;
		
		[self addSubview:dataLabel];
		[self addSubview:unitLabel];
		[self addSubview:labelLabel];
    [self bringSubviewToFront:plusminus];
    
    [self setupGraphWithData:graphData];
	}
	return self;
}
- (void) setupGraphWithData:(NSArray *)kData 
{
  const int peek_sz = 31;
  const int graph_sz = 600;
  const int graph_offset = 223;
  
  _graph = [[WeatherDataGraphView alloc] initWithFrame:CGRectMake(-graph_sz + graph_offset + peek_sz, 2,  graph_sz, 135)];
  CGFloat low = CGFLOAT_MAX, high = CGFLOAT_MIN;
  _graph.dataKey = [WeatherDataEntityView graphKeyForLabel:labelLabel.text];
  
  for (NSDictionary* dataSet in kData)
  {
    NSNumber* val = [dataSet objectForKey:_graph.dataKey];
    CGFloat fval = [val floatValue];
    
    if (fval < low) low = fval;
    if (fval > high) high = fval;
  }
  
  CGFloat mean = (high + low) / 2;
  //so we buffer the values by 1/4th of mean.
  
  _graph.minValue = floorf(low - (mean / 8));
  _graph.maxValue = ceilf(high + (mean / 8));
  
  // if these values are still below 10 do some hoodoo to put them within a
  // bracket of 10
  if (_graph.maxValue - _graph.minValue < 10) 
  {
    CGFloat diff = _graph.maxValue - _graph.minValue;
    CGFloat pad = 5 - (diff/2);
    _graph.maxValue += pad;
    _graph.minValue -= pad;
  }
  
  _graph.dataSource = kData;
  
  [self addSubview:_graph];
  [self sendSubviewToBack:_graph];
}

+ (NSString*) graphKeyForLabel:(NSString*)kLabel 
{
  if ([kLabel isEqualToString:@"air temperature"])      { return @"temperature"; }
  else  if ([kLabel isEqualToString:@"wind speed"])     { return @"windSpeed"; }
  else  if ([kLabel isEqualToString:@"air humidity"])   { return @"humidity"; }
  else  if ([kLabel isEqualToString:@"wind gust"])      { return @"windGust"; } 
  else  if ([kLabel isEqualToString:@"wind direction"]) { return @"windDirection"; }
  else  if ([kLabel isEqualToString:@"air pressure"])   { return @"airPressure"; }
  else  if ([kLabel isEqualToString:@"sun radiation"])  { return @"radiation"; }
  else             return @"gammaRadiation"; 
}

- (void) setShowsDrawerEdge:(BOOL)kShowsDrawerEdge
{
  showsDrawerEdge  = kShowsDrawerEdge;
  drawerEdgeImage.hidden = !showsDrawerEdge;
}

- (BOOL) showsDrawerEdge
{
  return showsDrawerEdge;
}

-(void) setData:(WeatherDataEntity *)kData
{
	data = kData;
	dataLabel.text = data.value;
	unitLabel.text = [data.unit uppercaseString];
	labelLabel.text = [data.label lowercaseString];
}

-(WeatherDataEntity*) data
{
	return data;
}

-(void) layoutSubviews 
{
	dataLabel.frame = CGRectMake(20.0f, 13.0f, 180, 60.0f);
	unitLabel.frame = minified ? CGRectMake(60.0f, 33.0f, 245.0f, 20.0f) : CGRectMake(25.0f, 78.0f, 245.0f, 20.0f);
	labelLabel.frame = CGRectMake(25.0f, 105.0f, 245.0f, 30.0f);
}

-(void) setMinified:(BOOL)kMinified
{
	if (kMinified == minified)
	{
		return;
	}
	
	minified = kMinified;
	
	if (minified)
	{
		dataLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
		labelLabel.hidden = YES;
    drawerEdgeImage.hidden = YES;
		
		if (![data.unit isEqualToString:@"degrees celsius"])
		{
			dataLabel.hidden = YES;
			unitLabel.hidden = YES;
		}
	}
	else 
	{
		dataLabel.font = [UIFont fontWithName:@"Helvetica" size:72.0f];
		dataLabel.hidden = NO;
		unitLabel.hidden = NO;
		labelLabel.hidden = NO;
    drawerEdgeImage.hidden = NO;
	}
	
	unitLabel.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 30.0f, -105.0f);
	[self setNeedsLayout];
}

-(BOOL) minified
{
	return minified;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
  [drawerEdgeImage release];
  [dataLabel release];
  [unitLabel release];
  [labelLabel release];
    [super dealloc];
}


@end
