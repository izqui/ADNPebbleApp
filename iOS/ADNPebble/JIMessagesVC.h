//
//  JIMessagesVC.h
//  ADNPebble
//
//  Created by Jorge Izquierdo on 6/8/13.
//  Copyright (c) 2013 Jorge Izquierdo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface JIMessagesVC : UITableViewController <UIAlertViewDelegate>
{
    
    
    NSManagedObjectContext *_moc;
    NSArray *messages;
}



-(void) getStuff;
@end
