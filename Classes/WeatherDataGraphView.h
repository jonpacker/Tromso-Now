//
//  WeatherDataGraphView.h
//  TromsoNow
//
//  Created by Kjostinden on 5.4.2011.
//  Copyright 2011 Creative Intersection. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WeatherDataGraphView : UIView {
  BOOL _drawGraph;
}

@property (nonatomic, retain) NSArray* dataSource;
@property CGFloat maxValue;
@property CGFloat minValue;
@property (nonatomic, copy) NSString* dataKey;
@property BOOL drawGraph;

@end
