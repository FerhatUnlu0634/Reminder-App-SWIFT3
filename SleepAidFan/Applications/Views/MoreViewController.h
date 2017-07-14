//
//  MoreViewController.h
//  SleepAidFan
//
//  Created by Prince on 5/31/16.
//  Copyright © 2016 Sebastian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKStoreManager.h"

@import GoogleMobileAds;

@interface MoreViewController : UIViewController<SKPaymentTransactionObserver>

@property (weak, nonatomic) IBOutlet UIButton *btnStar1;
@property (weak, nonatomic) IBOutlet UIButton *btnStar2;
@property (weak, nonatomic) IBOutlet UIButton *btnStar3;
@property (weak, nonatomic) IBOutlet UIButton *btnStar4;
@property (weak, nonatomic) IBOutlet UIButton *btnStar5;
@property (weak, nonatomic) IBOutlet UIButton *btnRate;
@property (weak, nonatomic) IBOutlet UIButton *btnUpgrade;
@property (weak, nonatomic) IBOutlet UIButton *btnFeedback;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;

@end
