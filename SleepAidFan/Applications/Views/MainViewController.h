//
//  MainViewController.h
//  SleepAidFan
//
//  Created by Prince on 5/31/16.
//  Copyright © 2016 Sebastian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
//@import GoogleMobileAds;

#import "Apptentive.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MainViewController : UIViewController <AVAudioPlayerDelegate>

@property (nonatomic) Boolean isRunning;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (weak, nonatomic) IBOutlet UIImageView *fanBlade;
@property (weak, nonatomic) IBOutlet UIImageView *cage;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *setTimerButton;

@property (weak, nonatomic) IBOutlet UIImageView *img_VolumeBar;
@property (weak, nonatomic) IBOutlet UIButton *btn_Volume_OFF;
@property (weak, nonatomic) IBOutlet UIImageView *img_Button_Timer;
@property (weak, nonatomic) IBOutlet UIButton *btn_More;


- (IBAction)OnClickVolumeButton:(UIButton *)sender;
- (IBAction)onClcikNoiseButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)onChangeVolumeValue:(UISlider *)sender;
- (IBAction)onSetTimer:(id)sender;

- (void) runSpinAnimationOnView:(UIView*)view;
- (void) playNoiseAudio;


@end
