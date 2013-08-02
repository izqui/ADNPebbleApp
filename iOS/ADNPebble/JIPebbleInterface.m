//
//  JSPebbleInterface.m
//  JSPebbleReminders
//
//  Created by Javier Soto on 5/17/13.
//  Copyright (c) 2013 Javier Soto. All rights reserved.
//

#import "JIPebbleInterface.h"

#import "Message.h"
#import "ADNHTTPClient.h"
#import "AFJSONRequestOperation.h"


static const uint8_t pebbleAppUUID[] = { 0x3C, 0xB4, 0x32, 0xD0, 0xD2, 0xF8, 0x44, 0x63, 0xA6, 0xC4, 0x36, 0xE0, 0xC5, 0x32, 0xB0, 0xB0 };


@implementation JIPebbleInterface

+ (instancetype)defaultInterface
{
    static JIPebbleInterface *defaultInterface = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInterface = [[self alloc] init];
    });

    return defaultInterface;
}

- (void)displayNoWatchErrorAlert
{
    [Helpers errorAlert:@"No watch connected"];
}

- (void)startListening
{
    PBWatch *lastWatch = [PBPebbleCentral defaultCentral].lastConnectedWatch;

    if (lastWatch)
    {
        self.watch = lastWatch;
        
    }
    else
    {
        [self displayNoWatchErrorAlert];
    }

    [PBPebbleCentral defaultCentral].delegate = self;
}

- (void)setWatch:(PBWatch *)watch
{
    if (watch != _watch)
    {
        _watch = watch;

        __weak JIPebbleInterface *weakSelf = self;
        
        [self.watch appMessagesGetIsSupported:^(PBWatch *w, BOOL isAppMessagesSupported) {
            if (!isAppMessagesSupported)
            {
                NSLog(@"Pebble doesn't support communication.");
            }

            NSData *uuid = [NSData dataWithBytes:pebbleAppUUID length:sizeof(pebbleAppUUID)];
            [watch appMessagesSetUUID:uuid];
            
            NSLog(@"watch connected");
            [self.watch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *w2, NSDictionary *update) {
                
                
                if ([update[update.allKeys[0]] isKindOfClass:NSString.class] && [update[update.allKeys[0]] isEqualToString:@"messages"]){
                    
                    NSLog(@"Message request");
                    NSArray *messages = [Message getMessages];
                    NSMutableArray *a = [NSMutableArray array];
                    
                    for (NSDictionary *d in messages){
                        
                        NSString *topeb = d[@"title"];
                        if (topeb.length > 15){
                            
                           topeb = [[d[@"title"] substringToIndex:15] stringByAppendingString:@"..."];
                        }
                        
                        [a addObject:topeb];
                    }
                    
                    [self sendStringArray:a];
                }
                else if ([update[update.allKeys[0]] isKindOfClass:NSString.class] && [update[update.allKeys[0]] isEqualToString:@"profile"]){
                    
                    NSURLRequest *req = [[ADNHTTPClient sharedClient] requestWithMethod:@"GET" path:@"/stream/0/users/me" parameters:nil];
                    
                    
                    AFJSONRequestOperation *afj = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                        
                        NSLog(@"%@", JSON);
                        
                        NSMutableArray *a = [NSMutableArray array];
                        [a addObject:[NSString stringWithFormat:@"Username: @%@", JSON[@"data"][@"username"]]];
                        
                        [a addObject:[NSString stringWithFormat:@"Followers: %i", [JSON[@"data"][@"counts"][@"followers"] intValue]]];
                        [a addObject:[NSString stringWithFormat:@"Following: %i", [JSON[@"data"][@"counts"][@"following"] intValue]]];
                        
                        [self sendStringArray:a];
                        
                        
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                        
                    }];
                    [afj start];
                    
                }
                
                else {
                    
                    NSLog(@"integer %i", [update[update.allKeys[0]] intValue]);
                    //Send the message
                    
                    NSInteger index = [update[update.allKeys[0]] intValue];
                    NSString *message = [Message getMessages][index][@"title"];
                    
                    
                    NSLog(@"sending %@", message);
                    [self adnPost:message];
                                        
                    
                }
               
                return YES;
            }];
        }];
    }
}

-(void)adnPost:(NSString *)post{
    
    ADNHTTPClient *adn = [ADNHTTPClient sharedClient];
    NSURLRequest *req = [adn requestWithMethod:@"POST" path:@"/stream/0/posts" parameters:@{@"text": post}];
    AFJSONRequestOperation *afj = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    [afj start];
    

}
- (void)sendStringArray:(NSArray *)stringArray
{
    if (!self.watch)
    {
        [self displayNoWatchErrorAlert];
    }

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    [stringArray enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL *stop) {
        dictionary[[NSNumber numberWithInt8:(int8_t)idx]] = string;
    }];

    NSLog(@"Sending dict %@", dictionary);
    
    [self.watch appMessagesPushUpdate:dictionary onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        

        if (error)
        {
            
            [Helpers errorAlert:@"Error on comunicating with the Pebble."];
        }
    }];
}

#pragma mark -

- (void)pebbleCentral:(PBPebbleCentral *)central watchDidConnect:(PBWatch *)watch isNew:(BOOL)isNew
{
    NSLog(@"Watch did connect");

    self.watch = watch;
}

@end
