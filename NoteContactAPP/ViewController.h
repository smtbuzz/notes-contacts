//
//  ViewController.h
//  NoteContactAPP
//
//  Created by puneet on 16/08/13.
//  Copyright (c) 2013 Smartbuzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface ViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrallcontacts;
    ABAddressBookRef addressBook1;
    NSMutableArray *filteredList;
    
    BOOL isSearching;
    NSMutableArray*    charIndex;
    NSMutableDictionary*    charCount;
}


@end

