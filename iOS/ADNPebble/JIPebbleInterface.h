//
//  JSPebbleInterface.h
//  JSPebbleReminders
//
//  Created by Javier Soto on 5/17/13.
//  Copyright (c) 2013 Javier Soto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PebbleKit/PebbleKit.h>

@interface JIPebbleInterface : NSObject <PBPebbleCentralDelegate>
@property (nonatomic, strong) PBWatch *watch;

+ (instancetype)defaultInterface;

- (void)startListening;

- (void)sendStringArray:(NSArray *)stringArray;

@end
