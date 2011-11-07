//
//  TromsoNowAppDelegate.h
//  TromsoNow
//
//  Created by Kjostinden on 26.11.10.
//  Copyright 2010 Creative Intersection. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TromsoNowViewController;

@interface TromsoNowAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TromsoNowViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TromsoNowViewController *viewController;

@end

