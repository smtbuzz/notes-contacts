//
//  NotesContactVC.m
//  NoteContactAPP
//
//  Created by puneet on 16/08/13.
//  Copyright (c) 2013 Smartbuzz. All rights reserved.
//

#import "NotesContactVC.h"
#import "DatabaseSqlite.h"
#import "ContactViewController.h"
@interface NotesContactVC ()

@end

@implementation NotesContactVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrNotes_in_Contact=[[NSMutableArray alloc]init];
    self.title=@"Note Contacts";
    NSLog(@"%@" ,arrNotes_in_Contact);
    filteredList=[[NSMutableArray alloc]init];
    if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
    {
        addressBook1 = ABAddressBookCreate();
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        addressBook1 = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    [self refreshData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self refreshData];
    
}
-(void)refreshData
{
  
    arrNotes_in_Contact  =[[DatabaseSqlite getSharedInstance] readDataFromDataBase];
    NSLog(@"%@",arrNotes_in_Contact);
    [tableViewOfSavedContact reloadData];

    
}
#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearching)
    {
        return [filteredList count];
    }
    else
    {
    return [arrNotes_in_Contact count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    ABRecordID recid_1;
    ABRecordRef record;
    if(isSearching)
    {
        recid_1 = (ABRecordID)[[[filteredList objectAtIndex:indexPath.row]valueForKey:@"ReferID"] integerValue];
        record = ABAddressBookGetPersonWithRecordID(addressBook1, recid_1);
    }
     else
     {
        recid_1 = (ABRecordID)[[[arrNotes_in_Contact objectAtIndex:indexPath.row]valueForKey:@"ReferID"] integerValue];
     record = ABAddressBookGetPersonWithRecordID(addressBook1, recid_1);
    }
    
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
    
    if (firstName) cell.textLabel.text=firstName;
    
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
    
    if(lastName) cell.textLabel.text=[cell.textLabel.text stringByAppendingFormat:@" %@",lastName];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ABRecordID recordid;
    ContactViewController *contactViewController;
    if (isSearching)
    {
        recordid= (ABRecordID)[[[filteredList objectAtIndex:indexPath.row] valueForKey:@"ReferID"] intValue];
        contactViewController = [[ContactViewController alloc] initWithPersonID:recordid];
        contactViewController.contactIdFromDB=[filteredList [indexPath.row] valueForKey:@"SerialId"];
        contactViewController.messageSaveinDb=[filteredList [indexPath.row] valueForKey:@"Message"];
    }
    else
    {
        recordid = (ABRecordID)[[[arrNotes_in_Contact objectAtIndex:indexPath.row] valueForKey:@"ReferID"] intValue];
        contactViewController = [[ContactViewController alloc] initWithPersonID:recordid];
        contactViewController.contactIdFromDB=[arrNotes_in_Contact [indexPath.row] valueForKey:@"SerialId"];
        contactViewController.messageSaveinDb=[arrNotes_in_Contact [indexPath.row] valueForKey:@"Message"];
    }
    
   

    contactViewController.personId=recordid;
    [self.navigationController pushViewController:contactViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)filterListForSearchText:(NSString *)searchText
{
    [filteredList removeAllObjects]; //clears the array from all the string objects it might contain from the previous searches
    
    for (int i=0;i<[arrNotes_in_Contact count];i++ )
    {
        
        NSString *title;
      
        title=[[arrNotes_in_Contact objectAtIndex:i ] valueForKey:@"FullName"]; 
        
        NSRange nameRange = [title rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound) {
            [filteredList addObject:[arrNotes_in_Contact objectAtIndex:i] ];
        }
    }
}


// Implement the search display delegate methods.
#pragma mark - UISearchDisplayControllerDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    //When the user taps the search bar, this means that the controller will begin searching.
    isSearching = YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    //When the user taps the Cancel Button, or anywhere aside from the view.
    isSearching = NO;
    [self refreshData];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterListForSearchText:searchString]; // The method we made in step 7
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterListForSearchText:[self.searchDisplayController.searchBar text]]; // The method we made in step 7
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


@end
