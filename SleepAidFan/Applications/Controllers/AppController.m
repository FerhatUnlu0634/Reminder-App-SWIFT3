//  AppController.m


#import "AppController.h"

static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    self = [super init];
    if (self) {
        self.tempHour = self.tempMinute = 0;
        
        self.volumeMinValue = -15.5;
        self.volumeMaxValue = 115.5;
        
        self.unselectedWidth = self.selectedWidth = 0;
    }
    return self;
}

@end
