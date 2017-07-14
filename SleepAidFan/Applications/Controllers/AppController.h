//  AppController.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppController : NSObject

// Temporary Variables

@property (nonatomic) NSInteger tempHour, tempMinute;
@property (nonatomic) CGFloat volumeMinValue, volumeMaxValue;
@property (nonatomic) CGFloat unselectedWidth, selectedWidth;



+ (AppController *)sharedInstance;

@end