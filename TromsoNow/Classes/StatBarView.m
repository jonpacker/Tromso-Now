//
//  StatBarView.m
//  TromsoNow
//
//  Created by Kjostinden on 07.12.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import "StatBarView.h"

@interface StatBarView()

-(void) minify;
-(void) unminify;

-(void) refreshClockTime;

@end

@implementation StatBarView

@synthesize barBaseImage, displayWeatherData, weatherData, clockLabel;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        barBaseImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar.png"]];
		displayWeatherData = [[UILabel alloc] initWithFrame:CGRectMake(750.0f, 1.0f, 250.0f, 35.0f)];
        clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(800.0f, -36.0f, 200.0f, 35.0f)];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"nb_NO"]];
        [dateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"CET"]];
        [dateFormatter setDateFormat:@"HH:mm 'CET'"];
        
		weatherData = [[WeatherDataBar alloc] init];
		showing = NO;
		self.userInteractionEnabled = YES;
    }
    return self;
}
						
- (void) setupView {
	[self addSubview:barBaseImage];
    
    displayWeatherData.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
    displayWeatherData.textAlignment = UITextAlignmentRight;
    displayWeatherData.shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.58f];
    displayWeatherData.shadowOffset = CGSizeMake(0.0f, 2.0f);
    displayWeatherData.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.73f];
    displayWeatherData.text = @"PRESS FOR MORE READINGS";
    displayWeatherData.backgroundColor = [UIColor clearColor];
    
    clockLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    clockLabel.textAlignment = UITextAlignmentRight;
    clockLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75f];
    clockLabel.textColor = [UIColor whiteColor];
    clockLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
    clockLabel.backgroundColor = [UIColor clearColor];
    [self refreshClockTime];

    
	//weatherData.alpha = 1.0f;
	[self addSubview:displayWeatherData];
	[self addSubview:weatherData];
    [self addSubview:clockLabel];
	//self.showing = YES;
	[weatherData becomeFirstResponder];
	[self bringSubviewToFront:displayWeatherData];
}

- (void) refreshClockTime
{
    clockLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    [self performSelector:@selector(refreshClockTime) withObject:nil afterDelay:10.0f];
}

- (void) minify 
{
	weatherData.minified = YES;
	weatherData.transform = CGAffineTransformTranslate(weatherData.transform, 50.0f, -30.0f);
}

- (void) unminify
{
	weatherData.minified = NO;
	weatherData.transform = CGAffineTransformTranslate(weatherData.transform, -50.0f, 30.0f);
}

- (BOOL) showing {
	return showing;
}

- (void) setShowing:(BOOL)isShowing {
	showing = isShowing;
	[UIView animateWithDuration:0.5f animations:^{
		CGFloat frameTransDistance = isShowing ? -102.0f : 102.0f;
		CGFloat labelTransDistance = isShowing ? 250.0f : -250.0f;
		displayWeatherData.transform = CGAffineTransformTranslate(displayWeatherData.transform, labelTransDistance, 0.0f);
		self.transform = CGAffineTransformTranslate(self.transform, 0.0f, frameTransDistance);
	}];
	
	void(^minifiedAnimations)(void)  = ^(void){
		CGFloat dataTransDistance = isShowing ? 50.0 : -50.0f;
		weatherData.alpha = isShowing ? 0.0f : 1.0f;
		weatherData.transform = CGAffineTransformTranslate(weatherData.transform, dataTransDistance, 0.0f);
	};
	
	void(^unminifiedAnimations)(void)  = ^(void){
		CGFloat dataTransDistance = isShowing ? -30.0f : 30.0f;
		weatherData.alpha = isShowing ? 1.0f : 0.0f;
		weatherData.transform = CGAffineTransformTranslate(weatherData.transform, 0.0f, dataTransDistance);
	};
	
	[UIView animateWithDuration:(isShowing ? 0.3f : 0.2f) animations:(isShowing ? minifiedAnimations : unminifiedAnimations) completion: ^(BOOL finished) {
		
		if (isShowing)
		{
			[self unminify];
		}
		else 
		{
			[self minify];
		}
		
		[UIView animateWithDuration:(isShowing ? 0.2f : 0.3f) animations:(isShowing ? unminifiedAnimations : minifiedAnimations)];
	}];
	
	
	
}



- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	startPoint = [touch locationInView:self];
	[super touchesBegan:touches withEvent:event];
}

- (UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if (self.showing) return weatherData.dataView;
	else return self;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
	if (abs(touchPoint.x - startPoint.x) > 3) return;
	
	self.showing = !self.showing;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[barBaseImage release];
	[displayWeatherData release];
	[weatherData release];
    [super dealloc];
}


@end
