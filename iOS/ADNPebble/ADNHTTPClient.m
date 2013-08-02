//
//  ADNHTTPClient.m
//  cardkiller-vendors
//
//  Created by Jorge Izquierdo on 10/20/12.
//  Copyright (c) 2012 Jorge Izquierdo. All rights reserved.
//

#import "ADNHTTPClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const CWAPIBaseURLString = @"https://alpha-api.app.net";

@implementation ADNHTTPClient

+ (ADNHTTPClient *) sharedClient{
 
    static ADNHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ADNHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:CWAPIBaseURLString]];
    });
    
    return _sharedClient;
    
}
-(id) initWithBaseURL:(NSURL *)url{
    
    self = [super initWithBaseURL:url];
    if (!self) return nil;
    
    

    

    return self;
}
-(BOOL)isAuthenticated{
    
    return (self.accessToken);
}

-(NSString *)accessToken{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

-(NSURLRequest *) requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)params{

    
    NSMutableURLRequest *r = [super requestWithMethod:method path:path parameters:params];
    
    if ([self isAuthenticated]) [r addValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    
    return r;
}
@end
