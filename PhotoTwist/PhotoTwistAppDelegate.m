//
//  PhotoTwistAppDelegate.m
//  PhotoTwist
//
//  Created by Shriniket Sarkar on 2/10/12.
//  Copyright (c) 2012 CTS. All rights reserved.
//

#import "PhotoTwistAppDelegate.h"
#import "SettingsViewController.h"
#import "SVProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "SettingsViewController.h"
#import "MoreViewController.h"


@implementation PhotoTwistAppDelegate
@synthesize A;
@synthesize B=_B;
@synthesize window = _window;
@synthesize retainStateOfCollage=_retainStateOfCollage;
@synthesize displayFBLoginUnavailableAlert = _displayFBLoginUnavailableAlert;
@synthesize hasUserSelectedMultipleImages = _hasUserSelectedMultipleImages;
@synthesize facebook;
@synthesize selectedImagesForCollage = _selectedImagesForCollage;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    facebook = [[Facebook alloc]initWithAppId:@"275060699231729" andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) 
    {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        _displayFBLoginUnavailableAlert = NO;
    }
    if (![facebook isSessionValid]) 
    {
        _displayFBLoginUnavailableAlert = YES;

        //[facebook authorize:nil];
    }
    
    
    application.statusBarStyle =UIStatusBarStyleBlackTranslucent;
    //_settingsVC = [[SettingsViewController alloc]init];
    // Override point for customization after application launch.
    _retainStateOfCollage = NO; 
    return YES;
}
// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //NSLog(@"URL 4.2 = %@",url);
    return [facebook handleOpenURL:url]; 
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
        //NSLog(@"URL 4.2+ = %@",url);
    return [facebook handleOpenURL:url]; 
}
- (void)fbDidLogin 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self getFacebookUserName];
}
-(void)fbDidNotLogin:(BOOL)cancelled
{
    
}
-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    
}
-(void)fbSessionInvalidated
{
    
}
- (void) fbDidLogout 
{
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults removeObjectForKey:@"FBUserName"];
        [defaults synchronize];
    }
}
-(void)getFacebookUserName
{
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", 
                           [facebook.accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDidFinishSelector:@selector(getFacebookUserNameFinished:)];
    
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)getFacebookUserNameFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"Got Facebook Profile: %@", responseString);
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];   
    

    NSString *firstName = [responseJSON objectForKey:@"first_name"];
    NSString *lastName = [responseJSON objectForKey:@"last_name"];
    if (firstName && lastName) 
    {
        NSString *fbUserName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:fbUserName forKey:@"FBUserName"];
    }

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
