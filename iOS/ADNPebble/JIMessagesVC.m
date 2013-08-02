//
//  JIMessagesVC.m
//  ADNPebble
//
//  Created by Jorge Izquierdo on 6/8/13.
//  Copyright (c) 2013 Jorge Izquierdo. All rights reserved.
//

#import "JIMessagesVC.h"
#import "Message.h"

@implementation JIMessagesVC

-(id) init{
    
    self = [super init];
    
    if (self){
        
        NSLog(@"init");
        messages = @[];
        return self;
    }
    
    return nil;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"ADN Pebble";
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = add;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [self getStuff];
}

-(void)add{
    
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Add message" message:[NSString stringWithFormat:@"%i maximum", MaxChars] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [dialog show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.firstOtherButtonIndex){
        
        NSString *text = [alertView textFieldAtIndex:0].text;
        
      
        [self addItem:text];
    }
}

-(void)addItem:(NSString *)message{
    

   
    [Message addMessage:message];    
    [self getStuff];
    
}
-(void)setMoc:(NSManagedObjectContext *)moc{
    
    if (!_moc) _moc = moc;
    
    //[self getStuff];
}
-(void) getStuff{
    
    messages = [Message getMessages];
  
    [self.tableView reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellID = @"Cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        
    }
    
    cell.textLabel.text = messages[indexPath.row][@"title"];
   
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [Message deleteMessageAtIndex:indexPath.row];
    [self.tableView reloadData];
}

@end
