//  CommonUtils.h
//  Created by Sebastian

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) UIPickerView *hoursPicker, *minutesPicker;


+ (instancetype)shared;

- (CustomIOSAlertView *)showSetTimerAlert:(UIViewController *)parentView;
- (void)setVolumeSlider:(UISlider *)volumeSlider;
- (void)changeVolumeSilder:(UISlider *)volumeSlider withTag:(int)tag;
- (void)changeBladeImage:(UIImageView *)fanBlade withCage:(UIImageView *)cage withTag:(int)tag withRun:(BOOL)isRunning;
- (void)changeSetTimerButtonBorderColor:(UIButton *)setTimerButton withTag:(int)tag;
- (void)changeButtonImage:(UIView *)parentView withTag:(int)tag selected:(Boolean)isSelected;
- (void)showTimer:(UILabel *)label duration:(long)duration;


@end
