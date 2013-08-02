//
//  Helpers.m
//  ADNPebble
//
//  Created by Jorge Izquierdo on 6/8/13.
//  Copyright (c) 2013 Jorge Izquierdo. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

+(void)errorAlert:(NSString *)error{
    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];

}
@end
