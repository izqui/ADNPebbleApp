//
//  ADNHTTPClient.h
//  cardkiller-vendors
//
//  Created by Jorge Izquierdo on 10/20/12.
//  Copyright (c) 2012 Jorge Izquierdo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface ADNHTTPClient : AFHTTPClient

+ (ADNHTTPClient *) sharedClient;
-(BOOL)isAuthenticated;
-(BOOL)noError:(id)returnedData;

@end
