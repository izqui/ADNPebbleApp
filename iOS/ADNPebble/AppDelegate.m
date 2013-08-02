//
//  AppDelegate.m
//  ADNPebble
//
//  Created by Jorge Izquierdo on 6/8/13.
//  Copyright (c) 2013 Jorge Izquierdo. All rights reserved.
//

#import "AppDelegate.h"
#import "JIMessagesVC.h"
#import "JIPebbleInterface.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    self.adnLogin = [[ADNLogin alloc] init];
    self.adnLogin.delegate = self;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    if (![userDef objectForKey:@"token"]){
        
        [self.adnLogin loginWithScopes:@[@"write_post"]];
    }
    
    JIMessagesVC *messagesVC = [[JIMessagesVC alloc] init];
    
    [[JIPebbleInterface defaultInterface] startListening];
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:messagesVC];
    
    self.window.rootViewController = controller;
    
    [self.window makeKeyAndVisible];
    return YES;
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [self.adnLogin openURL:url sourceApplication:sourceApplication annotation:annotation];
    
}

-(void) adnLoginDidSucceedForUserWithID:(NSString *)userID token:(NSString *)accessToken{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    [userDef setObject:userID forKey:@"user"];
    [userDef setObject:accessToken forKey:@"token"];
    [userDef synchronize];
    
}

-(void)adnLoginDidFailWithError:(NSError *)error{
    
    NSLog(@"adn login got error: %@", error);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





@end
