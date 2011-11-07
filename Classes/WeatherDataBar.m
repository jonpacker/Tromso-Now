//
//  WeatherDataBar.m
//  TromsoNow
//
//  Created by Kjostinden on 22.12.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import "WeatherDataBar.h"

#import "JSONKit.h"

const CGFloat dataEntityInterval = 254.0f;

@interface InterceptingScrollView : UIScrollView {
	CGPoint begin;
}
@end 

@implementation InterceptingScrollView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	begin = [touch locationInView:self];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
	if (abs(touchPoint.x - begin.x) < 5) [[[self superview] superview] setShowing:NO];
}

@end

@interface WeatherDataBar() 

- (void) _thr_refreshData;
- (void) _thr_refresh;

@end

@implementation WeatherDataBar
@synthesize dataView, dataProvider;

- (id)initWithFrame:(CGRect)frame {
    
  self = [super initWithFrame:frame];
  if (self) 
  {
    minified = NO;
    dataProvider = [[UiTDataProvider new] retain];

    dataView = [InterceptingScrollView new];
    dataView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar2.png"]];
    dataView.scrollEnabled = YES;
    
    UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveTapFrom:)];
    tgr.numberOfTouchesRequired = 1;
    tgr.delegate = self;
    [self addGestureRecognizer:tgr];
    
    self.frame = CGRectMake(0.0f, 2.0f, 1024.0f, 179.0f);
    dataView.frame = CGRectMake(0.0f, 0.0f, 1024.0f, 181.0f);

    [self addSubview:dataView];
    [dataView release];

    [self createInitialData];
  }
  return self;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer*)recognizer
        shouldReceiveTouch:(UITouch *)touch
{
  BOOL hitsInsideGraphToggleButton = NO;
  NSArray* subviews = dataView.subviews;
  for (WeatherDataEntityView* dataEntity in subviews)
  {
    if (![dataEntity isKindOfClass:[WeatherDataEntityView class]]) continue;
    
    CGPoint locationInDataEntity = [touch locationInView:dataEntity];
    if ([dataEntity shouldRespondToDetailDisclosureTouchAtPoint:locationInDataEntity])
    {
      willTouchGraphButtonWithTag = dataEntity.tag;
      hitsInsideGraphToggleButton = YES;
      break;
    }
  }
  
  return hitsInsideGraphToggleButton;
}
 

- (void) receiveTapFrom:(UIGestureRecognizer*) ugr
{
  WeatherDataEntityView* dataEntity = (WeatherDataEntityView*)[dataView viewWithTag:willTouchGraphButtonWithTag];

  if (dataEntity.graph.drawGraph == YES) {
    [dataEntity hideGraph];
    [UIView animateWithDuration:0.5 animations:^{
      NSArray* subviews = dataView.subviews;
      for (WeatherDataEntityView* _dataEntity in subviews) {
        if (![_dataEntity isKindOfClass:[WeatherDataEntityView class]] || _dataEntity.tag <= dataEntity.tag) continue;
        
        _dataEntity.center = CGPointMake(_dataEntity.center.x - 566, _dataEntity.center.y);
      }
      dataView.contentSize = CGSizeMake(dataView.contentSize.width - 566, dataView.contentSize.height);
    }];
  } else {
    [dataEntity displayGraph];
    [UIView animateWithDuration:0.5 animations:^{
      NSArray* subviews = dataView.subviews;
      for (WeatherDataEntityView* _dataEntity in subviews) {
        if (![_dataEntity isKindOfClass:[WeatherDataEntityView class]] || _dataEntity.tag <= dataEntity.tag) continue;
        
        _dataEntity.center = CGPointMake(_dataEntity.center.x + 566, _dataEntity.center.y);
      }
      dataView.contentSize = CGSizeMake(dataView.contentSize.width + 566, dataView.contentSize.height);
    }];
  }
}

// next - read json from host. delay transform until data is ready
// draw graph.
/*
- (void) graphViewWithTag:(NSNumber*)tag
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  WeatherDataEntityView* dataEntity = (WeatherDataEntityView*)[dataView viewWithTag:[tag integerValue]];
  NSArray* array = [[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.jonpacker.com/uitds/data.json"]] objectFromJSONData];
  [dataEntity becomeGraphWithData:array];
  dataEntity.loading = NO;
  [pool release];
}*/
- (void) setView:(WeatherDataEntityView*)view isIsolated:(BOOL)kIsolate
{
  if (kIsolate) 
  {
    [dataView setContentOffset:CGPointMake(view.frame.origin.x, 0) animated:YES];
    dataView.scrollEnabled = NO;
  }
  else 
  {
    [dataView setContentOffset:CGPointMake(0, 0) animated:YES];
    dataView.scrollEnabled = YES;
  }
  
  for (UIView* dview in dataView.subviews)
  {
    if (view == dview) continue;
    [UIView animateWithDuration:0.5f animations:^{
      dview.alpha = kIsolate ? 0.0f : 1.0f;
    }];
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/


- (void) _thr_refreshData 
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
  NSArray* gdata = [[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.jonpacker.com/uitds/data.json"]] objectFromJSONData];
	NSArray* nsa = [dataProvider retrieveWeatherData];
	
	[nsa enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
		WeatherDataEntity *entity = (WeatherDataEntity*)obj;
		if (entity.unit == nil)
			return;
		
		WeatherDataEntityView *view = (WeatherDataEntityView*)[dataView viewWithTag:idx + 1];
		
		view.data = entity;
    view.graph.dataSource = gdata;
	}];
	
	[pool release];
}
- (void) refreshData 
{
	[self performSelectorInBackground:@selector(_thr_refreshData) withObject:nil];
}

- (BOOL) minified
{
	return minified;
}

- (void) setMinified:(BOOL)kMinified
{
	if (minified == kMinified)
	{
		return;
	}
	
	minified = kMinified;
  
  if (minified) {
    dataView.contentOffset = CGPointMake(0, 0);
  }
	
	NSArray* views = [dataView subviews];
	[views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {	
		WeatherDataEntityView* wdeView = (WeatherDataEntityView*)obj; 
		if (![wdeView respondsToSelector:@selector(setMinified:)])
			return;
		wdeView.minified = minified;
		wdeView.frame = CGRectMake(wdeView.frame.origin.x, minified ? -26.0f : -2.0f, wdeView.frame.size.width, wdeView.frame.size.height);
	}];
}

- (void) showDetailForView:(id)sender 
{
	NSLog(@"Got 'show detail' event");
}

- (void) createInitialData
{
	[self performSelectorInBackground:@selector(_thr_createInitialData) withObject:nil];
}

- (void) _thr_createInitialData
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
  NSArray* gdata = [[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.jonpacker.com/uitds/data.json"]] objectFromJSONData];
	NSArray* nsa = [dataProvider retrieveWeatherData];
	[dataView setContentSize:CGSizeMake(dataEntityInterval * ([nsa count] - 3), 181.0f)];
	
	CGFloat *xPos = malloc(sizeof(CGFloat));
	*xPos = 0.0f;
	
	[nsa enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
		WeatherDataEntity *entity = (WeatherDataEntity*)obj;
		if (entity.unit == nil)
			return;
    
		WeatherDataEntityView* v = [[WeatherDataEntityView alloc] initWithData:entity graphData:gdata atPoint:CGPointMake(*xPos, -2.0f)];
		v.tag = idx + 1;
		
    if (0 == [[dataView subviews] count]) 
    {
      [dataView addSubview:v];
    }
    else 
    {
      [dataView insertSubview:v atIndex:0];
    }
		[v release];
    
		*xPos += dataEntityInterval;
	}];
	
  //hackily disable shadow on final tab
  //((WeatherDataEntityView*)[[dataView subviews] lastObject]).showsDrawerEdge = NO;
  
	self.minified = YES;
	
	[self setNeedsLayout];
	
	[pool release];
}

- (void)dealloc {
	[dataProvider release];
	[dataView release];
    [super dealloc];
}


@end
