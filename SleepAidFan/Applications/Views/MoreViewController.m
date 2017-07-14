//
//  MoreViewController.m
//  SleepAidFan
//
//  Created by Prince on 5/31/16.
//  Copyright © 2016 Sebastian. All rights reserved.
//

#import "MoreViewController.h"
#import "Apptentive.h"
#import "iRate.h"
#import "MBProgressHUD.h"

#define DEF_AppStoreID @"1125321779"   // iRate

@interface MoreViewController () {
    int mStartCount;
}
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    self.btnRate.layer.borderColor = [[UIColor colorWithRed:156.0/255.0 green:202.0/255.0 blue:209.0/255.0 alpha:1] CGColor];
    self.btnUpgrade.layer.borderColor = [[UIColor colorWithRed:81.0/255.0 green:145.0/255.0 blue:186.0/255.0 alpha:1] CGColor];
    self.btnFeedback.layer.borderColor = [[UIColor colorWithRed:83.0/255.0 green:103.0/255.0 blue:161.0/255.0 alpha:1] CGColor];
    self.btnShare.layer.borderColor = [[UIColor colorWithRed:156.0/255.0 green:202.0/255.0 blue:209.0/255.0 alpha:1] CGColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSUserDefaults* sharedDefault = [NSUserDefaults standardUserDefaults];
    BOOL isPurchased = [sharedDefault boolForKey:@"RemoveAds"];

    if (isPurchased) {
        [self.btnUpgrade setTitle:@"Purchased" forState:UIControlStateNormal];
        [self.btnUpgrade setTitle:@"Purchased" forState:UIControlStateDisabled];
        self.btnUpgrade.enabled = NO;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) updateStarStatus:(int)starCount {
    mStartCount = starCount;
    UIButton* starGroup[] = {self.btnStar1, self.btnStar2, self.btnStar3, self.btnStar4, self.btnStar5};
    for (int i = 0; i < 5; i++) {
        if (i < starCount) {
            [starGroup[i] setImage:[UIImage imageNamed:@"star_highlight.png"] forState:UIControlStateNormal];
        } else {
            [starGroup[i] setImage:[UIImage imageNamed:@"star_normal.png"] forState:UIControlStateNormal];
        }
    }
    
    if (starCount <= 3) {
        [self.btnRate setTitle:@"Contact?" forState:UIControlStateNormal];
    } else {
        [self.btnRate setTitle:@"Rate" forState:UIControlStateNormal];
    }
}

- (void) removeADS
{
    NSString* consumableId = iap_removeads;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hide:true afterDelay:30];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    [[MKStoreManager sharedManager] buyFeature:consumableId
                                    onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt,SKPaymentTransaction* transaction)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:true];
         
         if([purchasedFeature isEqualToString:consumableId])
         {
             [self.btnUpgrade setTitle:@"Purchased" forState:UIControlStateNormal];
             [self.btnUpgrade setTitle:@"Purchased" forState:UIControlStateDisabled];
             self.btnUpgrade.enabled = NO;
             
             [[Apptentive sharedConnection] engage:@"Purchased Remove Ads" fromViewController:self];
             [FBSDKAppEvents logEvent:@"Purchased Remove Ads"];

             NSUserDefaults* sharedDefault = [NSUserDefaults standardUserDefaults];
             [sharedDefault setBool:YES forKey:@"RemoveAds"];
             [sharedDefault synchronize];
         }
         
     }
                                   onCancelled:^
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:true];
         NSLog(@"User Cancelled Transaction");
     }];
}

- (void)restore
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^
     {
     }
                                                                  onError:
     ^(NSError* error)
     {
         NSLog(@"Restore Failed");
     }];
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"Restore Failed With Error:%@", error);
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    for (SKPaymentTransaction* transaction in queue.transactions) {
        NSString* productID = transaction.payment.productIdentifier;
        
        if([productID isEqualToString:iap_removeads])
        {
            [self.btnUpgrade setTitle:@"Purchased" forState:UIControlStateNormal];
            [self.btnUpgrade setTitle:@"Purchased" forState:UIControlStateDisabled];
            self.btnUpgrade.enabled = NO;

            NSUserDefaults* sharedDefault = [NSUserDefaults standardUserDefaults];
            [sharedDefault setBool:YES forKey:@"RemoveAds"];
            [sharedDefault synchronize];
        }
    }
}

- (IBAction)onStar1:(id)sender {
    [[Apptentive sharedConnection] engage:@"Clicked 1 Star" fromViewController:self];
    [FBSDKAppEvents logEvent:@"Clicked 1 Star"];

    [self updateStarStatus:1];
}

- (IBAction)onStar2:(id)sender {
    [[Apptentive sharedConnection] engage:@"Clicked 2 Stars" fromViewController:self];
    [FBSDKAppEvents logEvent:@"Clicked 2 Stars"];

    [self updateStarStatus:2];
}

- (IBAction)onStar3:(id)sender {
    [[Apptentive sharedConnection] engage:@"Clicked 3 Stars" fromViewController:self];
    [FBSDKAppEvents logEvent:@"Clicked 3 Stars"];
    
    [self updateStarStatus:3];
}

- (IBAction)onStar4:(id)sender {
    [[Apptentive sharedConnection] engage:@"Clicked 4 Stars" fromViewController:self];
    [FBSDKAppEvents logEvent:@"Clicked 4 Stars"];

    [self updateStarStatus:4];
}

- (IBAction)onStar5:(id)sender {
    [[Apptentive sharedConnection] engage:@"Clicked 5 Stars" fromViewController:self];
    [FBSDKAppEvents logEvent:@"Clicked 5 Stars"];

    [self updateStarStatus:5];
}

- (IBAction)onRate:(id)sender {
    if ([self.btnRate.titleLabel.text compare:@"Rate"] == NSOrderedSame) {
        
        [[Apptentive sharedConnection] engage:@"Clicked Rate button" fromViewController:self];
        [FBSDKAppEvents logEvent:@"Clicked Rate button"];

//        [iRate sharedInstance].appStoreID = DEF_AppStoreID;
//        [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
//        [iRate sharedInstance].delegate = nil;
//        [[iRate sharedInstance] openRatingsPageInAppStore];
        
        NSString *str;
        float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (ver >= 7.0 && ver < 7.1) {
            str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",DEF_AppStoreID];
        } else if (ver >= 8.0) {
            str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",DEF_AppStoreID];
        } else {
            str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",DEF_AppStoreID];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        [FBSDKAppEvents logEvent:@"Clicked Rate button"];
    } else {
        [[Apptentive sharedConnection] engage:@"Clicked Contact? button" fromViewController:self];
        [FBSDKAppEvents logEvent:@"Clicked Contact? button"];
        [[Apptentive sharedConnection] presentMessageCenterFromViewController:self];
        [FBSDKAppEvents logEvent:@"Clicked Contact? button"];
    }
}

- (IBAction)onUpgrade:(id)sender {
    [[Apptentive sharedConnection] engage:@"Clicked Upgrade button" fromViewController:self];
    [FBSDKAppEvents logEvent:@"Clicked Upgrade button"];

    [self removeADS];
}

- (IBAction)onRestore:(id)sender {
    [[Apptentive sharedConnection] engage:@"Clicked Restore button" fromViewController:self];
    [FBSDKAppEvents logEvent:@"Clicked Restore button"];
    
    [self restore];
}

- (IBAction)onFeedback:(id)sender {
    [[Apptentive sharedConnection] engage:@"Clicked Feedback button" fromViewController:self];
    [FBSDKAppEvents logEvent:@"Clicked Feedback button"];

    [[Apptentive sharedConnection] presentMessageCenterFromViewController:self];
    [FBSDKAppEvents logEvent:@"Clicked Feedback button"];
}

- (IBAction)onShare:(id)sender {
    NSString *textToShare = @"Hey, check out the Sleep Aid Fan app. It plays fan noise to help you fall asleep!";
    NSURL *myWebsite = [NSURL URLWithString:@"https://itunes.apple.com/app/apple-store/id1125321779?pt=118179161&ct=Share%20Button&mt=8"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
//    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
//                                   UIActivityTypePostToTwitter,
//                                   UIActivityTypePostToFacebook,
//                                   UIActivityTypePostToWeibo,
//                                   UIActivityTypeMessage,
//                                   UIActivityTypeMail,
//                                   UIActivityTypePrint,
//                                   UIActivityTypeCopyToPasteboard,
//                                   UIActivityTypeAssignToContact,
//                                   UIActivityTypeSaveToCameraRoll,
//                                   UIActivityTypeAddToReadingList,
//                                   UIActivityTypePostToFlickr,
//                                   UIActivityTypePostToVimeo,
//                                   UIActivityTypePostToTencentWeibo];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFacebook,
                                   UIActivityTypePostToTwitter,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo,
                                   UIActivityTypePostToWeibo,
                                   UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = @[];
    
    controller.popoverPresentationController.sourceView = self.view;
    // Present the controller
    [self presentViewController:controller animated:YES completion:nil];

}


@end
