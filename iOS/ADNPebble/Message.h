//
//  Message.h
//  
//
//  Created by Jorge Izquierdo on 6/8/13.
//
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

+(NSArray *)getMessages;
+(void)addMessage:(NSString *)message;

@property (nonatomic, strong) NSString *title;
-(id)initWithDict:(NSDictionary *)dict;
+(void)deleteMessageAtIndex:(NSInteger)index;
@end
