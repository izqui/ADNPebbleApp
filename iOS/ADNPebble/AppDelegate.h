//
//  AppDelegate.h
//  ADNPebble
//
//  Created by Jorge Izquierdo on 6/8/13.
//  Copyright (c) 2013 Jorge Izquierdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADNLogin.h"
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, ADNLoginDelegate>



@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ADNLogin *adnLogin;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
@end
