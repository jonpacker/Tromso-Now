//
//  WeatherDataGraphView.m
//  TromsoNow
//
//  Created by Kjostinden on 5.4.2011.
//  Copyright 2011 Creative Intersection. All rights reserved.
//

#import "WeatherDataGraphView.h"

static const CGFloat leftPad = 50.0f;
static const NSInteger intervalCount = 5;
static const CGFloat topPad = 15.0f;
static const CGFloat bottomPad = 15.0f;
static const CGFloat rightPad = 20.0f;

static const CGFloat lineBaseTrans = 0.05f;
static const CGFloat lineTransVar = 0.25f;


@implementation WeatherDataGraphView

@synthesize dataKey, minValue, maxValue, dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"graphback"]];
      //self.backgroundColor = [UIColor blueColor];
      
      UIImageView* shelfDrop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"graphcapl"]];
      shelfDrop.center = CGPointMake(frame.size.width + (shelfDrop.frame.size.width / 2), (shelfDrop.frame.size.height / 2));
      
      [self addSubview:shelfDrop];
      [shelfDrop release];
      _drawGraph = NO;
    }
    return self;
}

- (void) setDrawGraph:(BOOL)drawGraph
{
  _drawGraph = drawGraph;
  if (drawGraph) [self setNeedsDisplay];
}

- (BOOL) drawGraph
{
  return _drawGraph;
}

- (void)drawRect:(CGRect)rect
{
  if (!_drawGraph) return;
  
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  UIFont* labelFont = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
  UIFont* smallLabelFont = [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
  NSInteger pointsCount = [dataSource count];
  CGFloat pointFrequency = (rect.size.width - leftPad - rightPad) / (pointsCount-1);
  CGColorRef blackColor = [UIColor blackColor].CGColor;  CGSize labelShadowSize = CGSizeMake(0, 1);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGColorRef whiteColor = [UIColor whiteColor].CGColor;
  CGColorRef translucentWhite = CGColorCreateCopyWithAlpha(whiteColor, 0.8);
  CGColorRef barelyVisibleWhite = CGColorCreateCopyWithAlpha(whiteColor, 0.05);
  
  CGContextSetFillColorWithColor(context, translucentWhite);
  CGContextSetStrokeColorWithColor(context, barelyVisibleWhite);
  CGContextSetLineWidth(context, 0.5);
  
  CGMutablePathRef path = CGPathCreateMutable();
  NSInteger i = 0;
  CGPoint points[pointsCount];
  
  CGFloat lineInterval = ( maxValue - minValue ) / intervalCount;
  CGFloat unitLineInterval = (rect.size.height - topPad - bottomPad) / intervalCount;
  
  for (NSDictionary* dataset in dataSource)
  {
    NSNumber* value = [dataset objectForKey:dataKey];
    CGFloat floatVal = [value floatValue];
    CGFloat yVal = (floatVal - minValue) / (maxValue - minValue);
    CGFloat xVal = leftPad + (i * pointFrequency);
    yVal = (rect.size.height - topPad - bottomPad) - ((rect.size.height - topPad - bottomPad) * yVal);
    yVal += topPad;
    
    points[i] = CGPointMake(xVal, yVal);
    
    NSString *timeStamp = [dataset objectForKey:@"ts"];
    int minute = [[timeStamp substringFromIndex:3] intValue];
    
   // if (i % 15 == 5)
    if (minute % 30 == 0)
    {
      CGSize renderSize = [timeStamp sizeWithFont:smallLabelFont];
      
      CGContextSetShadowWithColor(context, CGSizeMake(0,1), 0, blackColor);
      [timeStamp drawInRect:CGRectMake(xVal - (renderSize.width / 2), self.frame.size.height - bottomPad, renderSize.width, renderSize.height) 
                   withFont:smallLabelFont];
      CGContextSetShadowWithColor(context, CGSizeMake(0,1), 0, NULL);
      
      CGMutablePathRef line = CGPathCreateMutable();
      CGPoint points[] = 
      {
        CGPointMake(xVal, yVal), 
        CGPointMake(xVal, self.frame.size.height - bottomPad)
      };
      CGPathAddLines(line, NULL, points, 2);
      CGContextAddPath(context, line);
      CGContextStrokePath(context);
      CGPathRelease(line);
    }
    i++;
  }
  
  CGPathAddLines(path, NULL, points, pointsCount);
  
  CGColorRef transparentWhite = CGColorCreateCopyWithAlpha(whiteColor, 0.2);
  
  CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 7.0f, transparentWhite);
  CGContextSetStrokeColorWithColor(context, translucentWhite);
  CGContextSetLineWidth(context, 2.0f);
  
  CGContextAddPath(context, path);
  CGContextStrokePath(context);
  
  CGPathRelease(path);
  CGColorRelease(translucentWhite);
  CGColorRelease(transparentWhite);
  CGColorRelease(barelyVisibleWhite);
  
  CGContextSetLineWidth(context, 0.5f);
  CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
  
  CGFloat lineTransparency;
  
  for (i = 0; i <= intervalCount; ++i) 
  {
    NSString* unitString = [[NSNumber numberWithFloat:minValue + ((intervalCount - i) * lineInterval)] stringValue];
    CGContextSetShadowWithColor(context, labelShadowSize, 0, blackColor);
    [unitString drawInRect:CGRectMake(10, (topPad + (unitLineInterval * i)) - (labelFont.pointSize/2) - 1, leftPad-13, labelFont.pointSize) 
                  withFont:labelFont 
             lineBreakMode:UILineBreakModeClip 
                 alignment:UITextAlignmentRight];
    CGContextSetShadowWithColor(context, labelShadowSize, 0, NULL);
    
    lineTransparency = lineBaseTrans + lineTransVar * (1 - fabs((intervalCount + 1) / 2 - i) / ((intervalCount + 1) / 2));
    
    path = CGPathCreateMutable();
    CGPoint intervalLine[2];
    intervalLine[0] = CGPointMake(leftPad, topPad + (i * unitLineInterval));
    intervalLine[1] = CGPointMake(rect.size.width - rightPad, topPad + (i * unitLineInterval));
    CGPathAddLines(path, NULL, intervalLine, 2);
    
    CGColorRef lineColor = CGColorCreateCopyWithAlpha(whiteColor, lineTransparency);
    CGContextSetStrokeColorWithColor(context, lineColor);
    
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    
    CGColorRelease(lineColor);
    CGPathRelease(path);
  }
  
  [pool release];
}

- (void)dealloc
{
  [self.dataSource release];
  [self.dataKey release];
  [super dealloc];
}

@end
