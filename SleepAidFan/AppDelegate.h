//
//  AppDelegate.h
//  SleepAidFan
//
//  Created by iDeveloper on 2/4/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>


@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainVC;

+(AppDelegate *)sharedAppDeleate;
@property (assign, nonatomic) float EN_Version;
@end
