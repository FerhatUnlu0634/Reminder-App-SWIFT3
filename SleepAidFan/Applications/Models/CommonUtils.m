//  CommonUtils.m


#import "CommonUtils.h"
#import <CommonCrypto/CommonDigest.h>

@interface CommonUtils () {
//    NSInteger hr, min;
    NSMutableArray *hours, *minutes;
}

@end

@implementation CommonUtils

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (CustomIOSAlertView *)showSetTimerAlert:(MainViewController *)parentView{
    appController.tempHour = appController.tempMinute = 0;
    UIView *uiview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentView.view.frame.size.width * 0.8, parentView.view.frame.size.width * 0.4)];
    
    hours   = [[NSMutableArray alloc] init];
    for (int i = 0; i < 24; i++) {
        if (i < 10){
            [hours addObject:[NSString stringWithFormat:@"0%d", i]];
        }else{
            [hours addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
    }

    minutes = [[NSMutableArray alloc] init];
    for (int i = 0; i < 60; i ++) {
        if (i < 10){
            [minutes addObject:[NSString stringWithFormat:@"0%d", i]];
        }else{
            [minutes addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDeleate];
    if (appDelegate.EN_Version == YES){
        float x, y, width, height, margin;
        margin = uiview.frame.size.width / 6.0;
        x = margin;
        y = 0;
        width = (uiview.frame.size.width - 2.0 * margin) / 3.0;
        height = uiview.frame.size.height;
        
        self.hoursPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        self.hoursPicker.showsSelectionIndicator = YES;
        self.hoursPicker.hidden = NO;
        self.hoursPicker.delegate = self;
        
        x = uiview.frame.size.width / 2.0;
        self.minutesPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        self.minutesPicker.showsSelectionIndicator = YES;
        self.minutesPicker.hidden = NO;
        self.minutesPicker.delegate = self;
        
        x = (uiview.frame.size.width + margin) / 3.0;
        width = (uiview.frame.size.width - 2.0 * margin) / 6.0;
        
        UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [hourLabel setText:@"Hr"];
        
        x = margin + (uiview.frame.size.width - 2.0 * margin) * 5.0 / 6.0;
        UILabel *minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [minuteLabel setText:@"min"];
        
        [uiview addSubview:self.hoursPicker];
        [uiview addSubview:hourLabel];
        [uiview addSubview:self.minutesPicker];
        [uiview addSubview:minuteLabel];
    }else{
        float x, y, width, height, margin;
        margin = uiview.frame.size.width / 7.0;
        x = margin * 2;
        y = 0;
        width = margin;
        height = uiview.frame.size.height;
        
        self.hoursPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        self.hoursPicker.showsSelectionIndicator = YES;
        self.hoursPicker.hidden = NO;
        self.hoursPicker.delegate = self;
        
        x = margin * 4.0;
        self.minutesPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        self.minutesPicker.showsSelectionIndicator = YES;
        self.minutesPicker.hidden = NO;
        self.minutesPicker.delegate = self;
        
        x = (uiview.frame.size.width - margin) / 2.0;
        width = margin;
        
        UILabel *spaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, margin, height)];
        spaceLabel.textAlignment = UITextAlignmentCenter;
        
        UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        
        x = margin + (uiview.frame.size.width - 2.0 * margin) * 5.0 / 5.0;
        UILabel *minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        
        [hourLabel setText:@""];
        [minuteLabel setText:@""];
        [spaceLabel setText:@":"];
        
        [uiview addSubview:spaceLabel];
        [uiview addSubview:self.hoursPicker];
        [uiview addSubview:hourLabel];
        [uiview addSubview:self.minutesPicker];
        [uiview addSubview:minuteLabel];

    }
    
    
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    if (appDelegate.EN_Version == YES){
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Done", nil]];
    }else{
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"", @"", nil]];
    }
    
    [alertView setUseMotionEffects:FALSE];
    [alertView setContainerView:uiview];

    return alertView;
}

//    Volume Slider
- (void)setVolumeSlider:(UISlider *)volumeSlider{
    CGRect sliderFrame = volumeSlider.frame;
    sliderFrame.size = CGSizeMake(sliderFrame.size.width, sliderFrame.size.width/9.0f);
    volumeSlider.frame = sliderFrame;
    
    UIImage *thumbImage = [UIImage imageNamed:@"volumeThumb.png"];
    CGRect rect = CGRectMake(0, 0, sliderFrame.size.width/24.35f, sliderFrame.size.height);
    
    UIGraphicsBeginImageContext( rect.size );
    [thumbImage drawInRect:rect];
    UIImage *picture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture);
    thumbImage = [UIImage imageWithData:imageData];
    
    [volumeSlider setThumbImage: thumbImage forState:UIControlStateNormal];
    [volumeSlider setMinimumValue:-15.5];
    [volumeSlider setMaximumValue:115.5];
    
    [volumeSlider setContinuous:YES];
    [volumeSlider setValue:0.0];
}

- (void)changeVolumeSilder:(UISlider *)volumeSlider withTag:(int)tag {
    NSString *imageName = [NSString stringWithFormat:@"volumeBar%d.png", tag];
    UIImage *trackImage = [UIImage imageNamed:imageName];
    
    CGRect rect = CGRectMake(0,0,volumeSlider.frame.size.width, volumeSlider.frame.size.height/1.3f);
    UIGraphicsBeginImageContext( rect.size );
    [trackImage drawInRect:rect];
    UIImage *picture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(picture);
    
    UIImage *stetchTrack = [[UIImage imageWithData:imageData]
                            stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
    
    [volumeSlider setMinimumTrackImage:stetchTrack forState:UIControlStateNormal];
    [volumeSlider setMaximumTrackImage:stetchTrack forState:UIControlStateNormal];
    
}
//    Fan Blade
- (void) changeBladeImage:(UIImageView *)fanBlade withCage:(UIImageView *)cage withTag:(int)tag withRun:(BOOL)isRunning {
    NSString *imageName = [NSString stringWithFormat:@"fanblade%d.png", tag];
    if (isRunning == YES) {
        imageName = [NSString stringWithFormat:@"fanblade%d_noshadow.png", tag];
    }
    UIImage *fanBladeImage = [UIImage imageNamed:imageName];
    
    imageName = [NSString stringWithFormat:@"cage%d", tag];
    UIImage *cageImage = [UIImage imageNamed:imageName];
    
    [fanBlade setImage:fanBladeImage];
    [cage     setImage:cageImage];
    
}

//    Set Timer Button
- (void)changeSetTimerButtonBorderColor:(UIButton *)setTimerButton withTag:(int)tag {
    [[setTimerButton layer] setBorderWidth:3.0f];
    [[setTimerButton layer] setCornerRadius:5.0];
    
    UIColor *color;
    switch (tag) {
        case 3:
            color = RGBA(184, 238, 246, 1);
            break;
        case 4:
            color = RGBA(105, 188, 241, 1);
            break;
        case 5:
            color = RGBA(107, 133, 208, 1);
            break;
    }
    
    [[setTimerButton layer] setBorderColor:color.CGColor];
}

//    Set Bottom Button Image
- (void) changeButtonImage:(UIView *)parentView withTag:(int)tag selected:(Boolean)isSelected {
    UIButton *button   = (UIButton *)[parentView viewWithTag:tag];
    
    CGRect buttonFrame = button.frame;
    
    CGFloat dx = (appController.selectedWidth - appController.unselectedWidth)/2.0f;
    
    switch (isSelected) {
        case YES:
            buttonFrame.size = CGSizeMake(appController.selectedWidth, appController.selectedWidth);
            buttonFrame.origin.x -= dx;
            buttonFrame.origin.y -= dx;
            break;
        case NO:
            buttonFrame.size = CGSizeMake(appController.unselectedWidth, appController.unselectedWidth);
            buttonFrame.origin.x += dx;
            buttonFrame.origin.y += dx;
            break;
    }
    
    button.frame = buttonFrame;
    NSString *strSelected;
    
    if (isSelected)
        strSelected = @"";
    else
        strSelected = @"un";
    
    NSString *imageName = [NSString stringWithFormat:@"bottom%d_%@selected.png", tag, strSelected];
    UIImage *buttonImage = [UIImage imageNamed:imageName];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    
}

//    Show Timer
- (void)showTimer:(UILabel *)label duration:(long)duration {
    int hr, min, sec;
    sec = duration % 60;
    duration = (duration - sec) / 60;
    min = duration % 60;
    hr = (int)(duration - min) / 60;
    
    NSString *strHour, *strMinute, *strSecond, *strTimer;
    if (hr < 10) {
        strHour = [NSString stringWithFormat:@"0%d", hr];
    } else {
        strHour = [NSString stringWithFormat:@"%d", hr];
    }
    
    if (min < 10) {
        strMinute = [NSString stringWithFormat:@"0%d", min];
    } else {
        strMinute = [NSString stringWithFormat:@"%d", min];
    }
    
    if (sec < 10) {
        strSecond = [NSString stringWithFormat:@"0%d", sec];
    } else {
        strSecond = [NSString stringWithFormat:@"%d", sec];
    }
    
    strTimer = [NSString stringWithFormat:@"%@:%@:%@", strHour, strMinute, strSecond];
    [label setText:strTimer];
}


#pragma mark - UIPickerView Datasource & Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    if ([pickerView isEqual:self.hoursPicker]) {
        return hours.count;
    } else {
        return minutes.count;
    }
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:self.hoursPicker]) {
        return [hours objectAtIndex:row];
    } else {
        return [minutes objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.hoursPicker]) {
        appController.tempHour = row;
    } else {
        appController.tempMinute = row;
    }
}
@end
