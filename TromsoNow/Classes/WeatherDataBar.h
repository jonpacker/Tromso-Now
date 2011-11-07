//
//  WeatherDataBar.h
//  TromsoNow
//
//  Created by Kjostinden on 22.12.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataLayer.h"
#import "WeatherDataEntityView.h"
#import "UiTDataProvider.h"

@interface WeatherDataBar : UIView<UIGestureRecognizerDelegate> {
	UIScrollView* dataView;
	UiTDataProvider* dataProvider;
  NSInteger willTouchGraphButtonWithTag;
	BOOL minified;
}

@property (readonly) UIScrollView* dataView;
@property (readonly) UiTDataProvider* dataProvider;
@property BOOL minified;

- (void) refreshData;
- (void) createInitialData;
- (void) showDetailForView:(id)sender ;
- (void) receiveTapFrom:(UIGestureRecognizer*) ugr;
- (void) setView:(WeatherDataEntityView*)view isIsolated:(BOOL)kIsolate;
- (void) graphViewWithTag:(NSNumber*)tag;

@end
