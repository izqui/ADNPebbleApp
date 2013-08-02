//
//  Message.m
//  
//
//  Created by Jorge Izquierdo on 6/8/13.
//
//

#import "Message.h"

@implementation Message

-(id)initWithDict:(NSDictionary *)dict{
    
    self = [super init];
    
    if (self){
        
        self.title = dict[@"title"];
        
        return self;
    }
    
    return nil;
}
+(NSArray *)getMessages{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDef objectForKey:@"messages"];
    NSLog(@"array %@", array);
    if (array) return array;
    else return nil;
}
+(void)addMessage:(NSString *)message{
    
    if ([message length] > 40){
        
        [Helpers errorAlert:[NSString stringWithFormat:@"%i chars is the maximum", MaxChars]];
        return;
    }
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[userDef objectForKey:@"messages"]];
    
    if (!array) array = [NSMutableArray array];
    
    if (array.count >= MaxMessages){
        
        [Helpers errorAlert:[NSString stringWithFormat:@"You only can add %i. Delete some.", MaxChars]];
        return;
    }
    [array addObject:@{@"title":message}];
    
    [userDef setObject:array forKey:@"messages"];
    [userDef synchronize];
}

+(void)deleteMessageAtIndex:(NSInteger)index{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[userDef objectForKey:@"messages"]];
    
    if (!array || !array[index]) return;
    
    [array removeObject:array[index]];
    [userDef setObject:array forKey:@"messages"];
    [userDef synchronize];
    
}
@end
