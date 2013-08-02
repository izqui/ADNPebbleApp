//
//  Helpers.h
//  ADNPebble
//
//  Created by Jorge Izquierdo on 6/8/13.
//  Copyright (c) 2013 Jorge Izquierdo. All rights reserved.
//


#import <UIKit/UIKit.h>

#define Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define Height CGRectGetHeight([UIScreen mainScreen].bounds)
#define MaxChars 40
#define MaxMessages 10



@interface Helpers : NSObject
+(void)errorAlert:(NSString *)error;
@end
