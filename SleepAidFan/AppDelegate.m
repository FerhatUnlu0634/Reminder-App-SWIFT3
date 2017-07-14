//
//  AppDelegate.m
//  SleepAidFan
//
//  Created by iDeveloper on 2/4/17.
//  Copyright © 2017 iDeveloper. All rights reserved.
//

#import "AppDelegate.h"
#import "Flurry.h"
#import "Apptentive.h"
#import "MKStoreManager.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD_PRO (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0)


@interface AppDelegate ()

@end

@implementation AppDelegate

static AppDelegate* sharedDelegate = nil;
+(AppDelegate *)sharedAppDeleate{
    if (sharedDelegate == nil)
        sharedDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    return sharedDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Fabric & Crashlytics
    [Fabric with:@[[Crashlytics class]]];
    
    [MKStoreManager sharedManager];
    
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:2]; //add 2 seconds longer.
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    
    [Flurry startSession:@"THQGK68Q5W5TQ7SDFZ26"];
    
    [Apptentive sharedConnection].APIKey = @"507dec454b5adef85fb678fb65cdb96f0a719b8de7b3fdd0d7fd61757cb872e1";
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateInitialViewController];
    }else if (IS_IPHONE_4_OR_LESS) {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone4" bundle:nil] instantiateInitialViewController];
    }else if (IS_IPHONE_5){
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone5" bundle:nil] instantiateInitialViewController];
    }else{
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    }
    
    [self.window makeKeyAndVisible];
    
    //facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if (!self.mainVC.audioPlayer.isPlaying)
        [self.mainVC playNoiseAudio];
    
    /*
     if (self.mainVC.isRunning) {
     [self.mainVC runSpinAnimationOnView:self.mainVC.fanBlade];
     }
     */
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    [FBSDKAppEvents logEvent:@"App Launched"];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
