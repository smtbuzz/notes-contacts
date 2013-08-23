//
//  NotesContactVC.h
//  NoteContactAPP
//
//  Created by puneet on 16/08/13.
//  Copyright (c) 2013 Smartbuzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesContactVC : UIViewController
{
    NSMutableArray *arrNotes_in_Contact;
    ABAddressBookRef addressBook1;
    NSMutableArray *filteredList;
    
    BOOL isSearching;
    IBOutlet UITableView *tableViewOfSavedContact;
}
-(void)refreshData;
@end
