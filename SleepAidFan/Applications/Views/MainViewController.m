//
//  MainViewController.m
//  SleepAidFan
//
//  Created by Prince on 5/31/16.
//  Copyright © 2016 Sebastian. All rights reserved.
//

#import "MainViewController.h"
#import <Crashlytics/Crashlytics.h>

@interface MainViewController ()<GADInterstitialDelegate> {
    int noiseIndex;
    long secondsLeft;
    NSTimer *timer;
	
    float preSlidingValue;
    AppDelegate *appDelegate;
}
@property(nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [[Apptentive sharedConnection] engage:@"App Lanuch" fromViewController:self];

    // Do any additional setup after loading the view.
    NSString *strNumberOfLoading = [[NSUserDefaults standardUserDefaults] objectForKey:@"NumberOfLoading"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NumberOfLoading"] == nil) {
        strNumberOfLoading = @"0";
        CGFloat fTimeFirstLoad = [[NSDate date] timeIntervalSince1970];
        NSString *strTimeFirstLoad = [NSString stringWithFormat:@"%f", fTimeFirstLoad];
        [[NSUserDefaults standardUserDefaults] setObject:strTimeFirstLoad forKey:@"TimeFirstLoad"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isRemoveAds = [userDefault boolForKey:@"RemoveAds"];

    if ([strNumberOfLoading integerValue] != 0 && [strNumberOfLoading integerValue] != 7 && isRemoveAds == NO) {
        [self createAndLoadInterstitial];
    }
    
    strNumberOfLoading = [NSString stringWithFormat:@"%ld", (long)[strNumberOfLoading integerValue] + 1];
    
    [[NSUserDefaults standardUserDefaults] setObject:strNumberOfLoading forKey:@"NumberOfLoading"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    appDelegate = [AppDelegate sharedAppDeleate];
    appDelegate.mainVC = self;
   
    [self initView];
    
    self.bannerView.adUnitID = @"ca-app-pub-1316345514650274/6305280143";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
    //Set TapGesture to Cage(Fan)
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureFan:)];
    singleTap.numberOfTapsRequired = 1;
    [_cage setUserInteractionEnabled:YES];
    [_cage addGestureRecognizer:singleTap];
    
    
    [self isEnglish];
    [self setLayoutWithEn];
    
    //Background Play / Pause
    [self setAudioSettings];
    
}

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isRemoveAds = [userDefault boolForKey:@"RemoveAds"];
    if (isRemoveAds == YES) {
        self.bannerView.hidden = YES;
        CGRect containerFrame = self.containerView.frame;
        containerFrame.origin.y = (self.view.frame.size.height - self.containerView.frame.size.height)/3*2;
        self.containerView.frame = containerFrame;
    }
    
    // Turn on remote control event delivery
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // Set ourselves as the first responder
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    // Turn off remote control event delivery & Resign as first responder
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    // Don't forget to call super
    [super viewWillDisappear:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) isEnglish{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ([language rangeOfString:@"en"].location == NSNotFound) {
        appDelegate.EN_Version = NO;
    } else {
        appDelegate.EN_Version = YES;
    }
}

- (void) setLayoutWithEn{
    if (appDelegate.EN_Version == YES){
        _img_VolumeBar.image = [UIImage imageNamed:@"vol_bar_EN.png"];
        [_btn_Volume_OFF setTitle:@"OFF" forState:UIControlStateNormal];
        [_setTimerButton setTitle:@"Set Timer" forState:UIControlStateNormal];
        [_img_Button_Timer setHidden:YES];
        [_btn_More setHidden:NO];
    }else{
        _img_VolumeBar.image = [UIImage imageNamed:@"vol_bar_Not_EN.png"];
        [_btn_Volume_OFF setTitle:@"" forState:UIControlStateNormal];
        [_setTimerButton setTitle:@"" forState:UIControlStateNormal];
        [_img_Button_Timer setHidden:NO];
        [_btn_More setHidden: YES];
    }
}

#pragma mark setAudioSettings
- (void) setAudioSettings{
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc]initWithImage:[UIImage imageNamed:@"appBackgroundLogo.png"]];
    NSMutableDictionary *songInfo = [NSMutableDictionary dictionary];
    [songInfo setValue:artwork forKey:MPMediaItemPropertyArtwork];
    
    if (appDelegate.EN_Version == YES){
        [songInfo setValue:@"Sleep Aid Fan" forKey:MPMediaItemPropertyTitle];
        [songInfo setValue:@"By App Magna" forKey:MPMediaItemPropertyArtist];
    }else{
        [songInfo setValue:@"" forKey:MPMediaItemPropertyTitle];
        [songInfo setValue:@"" forKey:MPMediaItemPropertyArtist];
    }
    
    
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    infoCenter.nowPlayingInfo = songInfo;
    
//    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Noise", MPMediaItemPropertyTitle,
//                                                             @"", MPMediaItemPropertyArtist, artwork, MPMediaItemPropertyArtwork,  1.0f, MPNowPlayingInfoPropertyPlaybackRate, nil];
    
    // Set the audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    NSError *activationError = nil;
    success = [audioSession setActive:YES error:&activationError];
    
    NSString *fileName = [NSString stringWithFormat:@"noise_%d.wav", noiseIndex];
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], fileName];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [_audioPlayer setNumberOfLoops:-1];
    _audioPlayer.volume = [self getVolumeValue];
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"prev");
                [self forwardNoise];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"next");
                [self nextNoise];
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                _audioPlayer.volume = [self getVolumeValue];
                [_audioPlayer play];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                [_audioPlayer pause];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark Play Audio after Call
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)audioPlayer;
{
    [self.audioPlayer pause];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)audioPlayer;
{
    [self.audioPlayer play];
}

#pragma mark Next and Forward Noise
- (void) nextNoise{
    int tag = noiseIndex;
    
    if (tag == 5){
        tag = 3;
    }else{
        tag++;
    }
    
    if (tag == 3) {
        [[Apptentive sharedConnection] engage:@"Pressed Fan Noise 1" fromViewController:self];
        [FBSDKAppEvents logEvent:@"06setFanNoise1"];
    } else if (tag == 4) {
        [[Apptentive sharedConnection] engage:@"Pressed Fan Noise 2" fromViewController:self];
        [FBSDKAppEvents logEvent:@"07setFanNoise2"];
    } else if (tag == 5) {
        [[Apptentive sharedConnection] engage:@"Pressed Fan Noise 3" fromViewController:self];
        [FBSDKAppEvents logEvent:@"08setFanNoise3"];
    }
    
    [commonUtils changeBladeImage:self.fanBlade withCage:self.cage withTag:tag withRun:self.isRunning];
    [commonUtils changeButtonImage:self.view withTag:tag selected:YES];
    [commonUtils changeButtonImage:self.view withTag:noiseIndex selected:NO];
    [commonUtils changeVolumeSilder:self.volumeSlider withTag:tag];
    [commonUtils changeSetTimerButtonBorderColor:self.setTimerButton withTag:tag];
    
    noiseIndex = tag;
    
    if (self.isRunning) {
        [self playNoiseAudio];
    }

}

- (void) forwardNoise{
    int tag = noiseIndex;
    
    if (tag == 3){
        tag = 5;
    }else{
        tag--;
    }
    
    if (tag == 3) {
        [[Apptentive sharedConnection] engage:@"Pressed Fan Noise 1" fromViewController:self];
        [FBSDKAppEvents logEvent:@"06setFanNoise1"];
    } else if (tag == 4) {
        [[Apptentive sharedConnection] engage:@"Pressed Fan Noise 2" fromViewController:self];
        [FBSDKAppEvents logEvent:@"07setFanNoise2"];
    } else if (tag == 5) {
        [[Apptentive sharedConnection] engage:@"Pressed Fan Noise 3" fromViewController:self];
        [FBSDKAppEvents logEvent:@"08setFanNoise3"];
    }
    
    [commonUtils changeBladeImage:self.fanBlade withCage:self.cage withTag:tag withRun:self.isRunning];
    [commonUtils changeButtonImage:self.view withTag:tag selected:YES];
    [commonUtils changeButtonImage:self.view withTag:noiseIndex selected:NO];
    [commonUtils changeVolumeSilder:self.volumeSlider withTag:tag];
    [commonUtils changeSetTimerButtonBorderColor:self.setTimerButton withTag:tag];
    
    noiseIndex = tag;
    
    if (self.isRunning) {
        [self playNoiseAudio];
    }
}

#pragma mark Admob Ad

- (void)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-1316345514650274/7176566545"];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    //    request.testDevices = @[ kGADSimulatorID, @"e6f9fbb4d00de5f0ab0e27d2343b35db" ];
    request.testDevices = @[kGADSimulatorID];
    [self.interstitial loadRequest:request];
}
- (void)initView {
    noiseIndex = 4;
    secondsLeft = 0;
    self.isRunning = false;
    preSlidingValue = 0.0;
    UIButton *button = (UIButton *)[self.view viewWithTag:3];
    appController.unselectedWidth = button.frame.size.width;
    appController.selectedWidth   = appController.unselectedWidth * 1.25;
    
//    Fan
    [commonUtils changeBladeImage:self.fanBlade withCage:self.cage withTag:noiseIndex withRun:self.isRunning];
    
//    Volume Slider
    [commonUtils setVolumeSlider:self.volumeSlider];
    [commonUtils changeVolumeSilder:self.volumeSlider withTag:noiseIndex];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [self.volumeSlider addGestureRecognizer:gr];
    
//    Set Timer Button
    [commonUtils changeSetTimerButtonBorderColor:self.setTimerButton withTag:noiseIndex];
    
//    Bottome Button
    [commonUtils changeButtonImage:self.view withTag:noiseIndex selected:YES];
}

#pragma mark Handle Volume
//    Button Clicking
- (IBAction)OnClickVolumeButton:(UIButton *)sender {
    int tag = (int)sender.tag;
    
    float volumeValue = (100.0 / 3.0) * (tag - 10);
    
    [self.volumeSlider setValue:volumeValue animated:YES];
    [self onChangeVolumeValue:self.volumeSlider];
    
    //Facebook Events
    switch (tag) {
        case 11:
            [FBSDKAppEvents logEvent:@"01setVolumeLow"];
            break;
        case 12:
            [FBSDKAppEvents logEvent:@"02setVolumeMedium"];
            break;
        case 13:
            [FBSDKAppEvents logEvent:@"03setVolumeHigh"];
            break;
        case 10:
            [FBSDKAppEvents logEvent:@"04setVolumeOff"];
            break;
        default:
            break;
    }
}

//    Slider Tapping
- (void) sliderTapped: (UITapGestureRecognizer*) g {
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted)
        return; // tap on thumb, let slider deal with it
    CGPoint pt = [g locationInView: s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    
    [s setValue:value animated:YES];
    [self onChangeVolumeValue:s];
}

//    Slider Scrolling
- (IBAction)onChangeVolumeValue:(UISlider *)sender {
    float value = sender.value, valueToSet = 0.0;
    
    if (value < 100 / 6.0)
        valueToSet = 0;
    if (value >= 100 / 6.0 && value < 50)
        valueToSet = 100 / 3.0;
    if (value >= 50 && value < 500 / 6.0)
        valueToSet = 200 / 3.0;
    if (value >= 500 / 6.0)
        valueToSet = 100;
        
    sender.value = valueToSet;
    
    if (valueToSet == preSlidingValue)
        return;
    
    if (valueToSet == 0) {
        if (appDelegate.EN_Version == YES){
            [[Apptentive sharedConnection] engage:@"Pressed off - English" fromViewController:self];
        }else{
            [[Apptentive sharedConnection] engage:@"Pressed off - Non-English" fromViewController:self];
        }
        [FBSDKAppEvents logEvent:@"04setVolumeOff"];
    } else if (valueToSet <= 100.0/3.0) {
        [[Apptentive sharedConnection] engage:@"Pressed Low Volume" fromViewController:self];
        [FBSDKAppEvents logEvent:@"01setVolumeLow"];
    } else if (valueToSet <= 100.0/3.0*2.0) {
        [[Apptentive sharedConnection] engage:@"Pressed Med Volume" fromViewController:self];
        [FBSDKAppEvents logEvent:@"02setVolumeMedium"];
    } else {
        [[Apptentive sharedConnection] engage:@"Pressed High Volume" fromViewController:self];
        [FBSDKAppEvents logEvent:@"03setVolumeHigh"];
    }
    
    if (sender.value == 0) {
        [self stopSpinAnimationOnView:self.fanBlade];
    } else {
        if (self.isRunning) {
            _audioPlayer.volume = [self getVolumeValue];
        } else {
            [self playNoiseAudio];
        }
        
        [self runSpinAnimationOnView:self.fanBlade];
    }
    
    [commonUtils changeBladeImage:self.fanBlade withCage:self.cage withTag:noiseIndex withRun:self.isRunning];
    preSlidingValue = valueToSet;
}

#pragma Selecting noise
- (IBAction)onClcikNoiseButton:(UIButton *)sender {
    int tag = (int)sender.tag;
    
    if (tag == noiseIndex)
        return;
    
    if (tag == 3) {
        [[Apptentive sharedConnection] engage:@"Pressed Fan Noise 1" fromViewController:self];
        [FBSDKAppEvents logEvent:@"06setFanNoise1"];
    } else if (tag == 4) {
        [[Apptentive sharedConnection] engage:@"Pressed Fan Noise 2" fromViewController:self];
        [FBSDKAppEvents logEvent:@"07setFanNoise2"];
    } else if (tag == 5) {
        [[Apptentive sharedConnection] engage:@"Pressed Fan Noise 3" fromViewController:self];
        [FBSDKAppEvents logEvent:@"08setFanNoise3"];
    }
    
    [commonUtils changeBladeImage:self.fanBlade withCage:self.cage withTag:tag withRun:self.isRunning];
    [commonUtils changeButtonImage:self.view withTag:tag selected:YES];
    [commonUtils changeButtonImage:self.view withTag:noiseIndex selected:NO];
    [commonUtils changeVolumeSilder:self.volumeSlider withTag:tag];
    [commonUtils changeSetTimerButtonBorderColor:self.setTimerButton withTag:tag];
    
    noiseIndex = tag;
    
    if (self.isRunning) {
        [self playNoiseAudio];
    }
}

#pragma Setting Timer
- (IBAction)onSetTimer:(id)sender {
    [FBSDKAppEvents logEvent:@"05setTimer"];
    
    [[Apptentive sharedConnection] engage:@"Pressed Set Timer" fromViewController:self];

    CustomIOSAlertView *alertView = [commonUtils showSetTimerAlert:self];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        if (buttonIndex == 1) {
            [FBSDKAppEvents logEvent:@"10setTimerDone"];
            
            [[Apptentive sharedConnection] engage:@"Pressed Done for Set Timer" fromViewController:self];
            secondsLeft = appController.tempHour * 3600 + appController.tempMinute * 60;
            [commonUtils showTimer:self.timerLabel duration:secondsLeft];
            
            if (self.isRunning) {
                [timer invalidate];
                if (secondsLeft > 0) {
                    timer = [self createTimer];
                }
            }
        } else {
            [FBSDKAppEvents logEvent:@"09setTimerCancel"];
            
            [[Apptentive sharedConnection] engage:@"Pressed Cancel for Set Timer" fromViewController:self];
        }
        
        [alertView close];
    }];
    [alertView show];
}

#pragma Utility
//    Start animation
- (void) runSpinAnimationOnView:(UIView*)view {
    
    self.isRunning = true;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = [self getRotationSpeed];
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INFINITY;
	rotationAnimation.removedOnCompletion = NO;
	
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [timer invalidate];
    if (secondsLeft > 0) {
        timer = [self createTimer];
    }
}


//    Stop animation
- (void) stopSpinAnimationOnView:(UIView*)view {
    self.isRunning = false;
    secondsLeft = 0;
    preSlidingValue = 0.0;
    [commonUtils showTimer:self.timerLabel duration:0];
    [timer invalidate];
    [view.layer removeAllAnimations];
    [self.volumeSlider setValue:0];
    [_audioPlayer stop];
}

//    Play Noise Audio
- (void) playNoiseAudio {
    NSString *fileName = [NSString stringWithFormat:@"noise_%d.wav", noiseIndex];
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], fileName];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [_audioPlayer setNumberOfLoops:-1];
    _audioPlayer.volume = [self getVolumeValue];
    _audioPlayer.delegate = self;
    [_audioPlayer play];
}

//    Create Timer
- (NSTimer*)createTimer {
    // create timer on run loop
    return [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked) userInfo:nil repeats:YES];
}

- (void)timerTicked {
    secondsLeft--;
    [commonUtils showTimer:self.timerLabel duration:secondsLeft];
    
    if (secondsLeft <= 0) {
        [self stopSpinAnimationOnView:self.fanBlade];
    }
}

- (float)getRotationSpeed{
    return 3 / powf(self.volumeSlider.value, 0.5);
}

- (float)getVolumeValue {
    return self.volumeSlider.value / 100;
}
#pragma mark GADInterstitialDelegate implementation
- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Sorry"
                                          message:@"Ad failed!"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [alertController dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [self.interstitial presentFromRootViewController:self];
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
//  
//    [self createAndLoadInterstitial];
    
}
- (IBAction)onMore:(id)sender {
    [[Apptentive sharedConnection] engage:@"Clicked More button" fromViewController:self];
    [FBSDKAppEvents logEvent:@"Clicked More button"];
}

#pragma mark Tap Gesture Fan
- (void) tapGestureFan: (UIGestureRecognizer *) gestureRecognizer{
    
    float valueToSet = 0.0;
    
    if (gestureRecognizer.view == _cage){
        
        if (self.isRunning){
            valueToSet = 0;
            NSLog(@"Press Fan Stop");
            
            if (appDelegate.EN_Version == YES){
                [[Apptentive sharedConnection] engage:@"Pressed Fan Off - English" fromViewController:self];
                [FBSDKAppEvents logEvent:@"Pressed Fan Off - English"];
            }else{
                [[Apptentive sharedConnection] engage:@"Pressed Fan Off - Non-English" fromViewController:self];
                [FBSDKAppEvents logEvent:@"Pressed Fan Off - Non-English"];
            }
        }else{
            valueToSet = 100 / 3.0;
            NSLog(@"Press Fan Start");
            
            [[Apptentive sharedConnection] engage:@"Pressed Fan On" fromViewController:self];
            [FBSDKAppEvents logEvent:@"Pressed Fan On"];
        }
        
        _volumeSlider.value = valueToSet;
        
        if (valueToSet == preSlidingValue)
            return;
        
        if (_volumeSlider.value == 0) {
            [self stopSpinAnimationOnView:self.fanBlade];
        } else {
            if (self.isRunning) {
                _audioPlayer.volume = [self getVolumeValue];
            } else {
                [self playNoiseAudio];
            }
            
            [self runSpinAnimationOnView:self.fanBlade];
        }
        
        [commonUtils changeBladeImage:self.fanBlade withCage:self.cage withTag:noiseIndex withRun:self.isRunning];
        preSlidingValue = valueToSet;
    }
    
    
}
@end
