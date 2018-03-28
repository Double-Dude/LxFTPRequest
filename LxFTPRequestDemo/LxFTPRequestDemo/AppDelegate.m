//
//  AppDelegate.m
//  LxFTPRequestDemo
//

#import "AppDelegate.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerNotification];
    return true;
}
-(void)applicationDidEnterBackground:(UIApplication *)application {
//    static BOOL executed = false;
//
//    if (executed) {
//        return;
//    }
//    //[self expireActivity];
    __block UIBackgroundTaskIdentifier bgTask;
    
    bgTask = [self createBgTask:(@"My Task")];
}

-(void) registerNotification {
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

- (UIBackgroundTaskIdentifier) createBgTask:(NSString *)taskName {
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithName:taskName expirationHandler:^{
        NSLog(@"==========expirationHandler ========");
                
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    return bgTask;
}
@end
