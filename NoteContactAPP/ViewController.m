//
//  ViewController.m
//  NoteContactAPP
//
//  Created by puneet on 16/08/13.
//  Copyright (c) 2013 Smartbuzz. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "ContactViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"All Contacts";
    
    isSearching=NO;
    filteredList=[[NSMutableArray alloc]init];
    //Get the tabBarItem
    UITabBarItem *tbi = [self tabBarItem];
    UIImage *i = [UIImage imageNamed:@"plus-icon.png"];
    [tbi setImage:i];
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
    {
        addressBook1 = ABAddressBookCreate();
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        addressBook1 = ABAddressBookCreateWithOptions(NULL, NULL);
    }

    self.tableData = [[NSMutableArray alloc] init];
    arrallcontacts=[[NSMutableArray alloc]init];
    [self fetchAllContacts];
    [self getPersonOutOfAddressBook];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getPersonOutOfAddressBook
{
    @autoreleasepool {
      
        if ([self accessgranted])
        {
              
        if (addressBook1 != nil)
        {
            NSLog(@"Succesful.");
            

           
            NSUInteger i = 0;
            for (i = 0; i < [arrallcontacts count]; i++)
            {
                 ABRecordID recid_1 = (ABRecordID)[arrallcontacts[i] intValue];
                Person *person = [[Person alloc] init];
                
                ABRecordRef contactPerson = ABAddressBookGetPersonWithRecordID(addressBook1, recid_1);
                
                [person.arrRefId addObject:(__bridge id)(contactPerson)];
                //Prefix
                NSString *preFix = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonPrefixProperty);
                person.PreFixName=preFix;
                
                
                //Suffix
                NSString *sufFix = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonSuffixProperty);
                person.strSuffix=sufFix;
                
                //NickName
                NSString *NickName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonNicknameProperty);
                if(NickName.length>0)
                {
                person.NickName=NickName;
                }
                else
                {
                    person.NickName=Nil;
                }
                
                //First Name
                NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                
                //Middle Name
                NSString *middleName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonMiddleNameProperty);
                person.MiddleName=middleName;
                
                
                //Last Name
                NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                
                
                //Company Name
                NSString *CompanyName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonOrganizationProperty);
                
             
             
               
                
                if(CompanyName.length>0)
                {
                    person.strCompanyName=CompanyName;
                }
                else
                {
                     person.strCompanyName=@"";
                }
                if(firstName.length>0)
                {
                    person.firstName = firstName;
                }
                else
                {
                     person.firstName=@"";
                }
                if(lastName.length>0)
                {
                     person.lastName = lastName;
                }
                else
                {
                    person.lastName=@"";
                }
                //FullName
                NSString *fullName = [NSString stringWithFormat:@"%@ %@",person.firstName, person.lastName];
                person.fullName=fullName;
               
                /***** Phone number MultiValues *****/
                ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                
                
                NSMutableArray *arrLable=[[NSMutableArray alloc]init];
                NSMutableArray *arrvalue=[[NSMutableArray alloc]init];
                
                for (int k = 0; k <  ABMultiValueGetCount(phoneNumberProperty); k++)
                {
                    NSString *label =[KAppDelegate cleanLable:(__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneNumberProperty, k) ];
                    NSString *value = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneNumberProperty, k) ;
                    
                    if(!label) label=@"(null)";
                    if(!value) value=@"(null)";
                    
                    [arrLable addObject:label];
                    [arrvalue addObject:value];
                    
                }
                for (int numberGet=0; numberGet<[arrLable count]; numberGet++)
                {
                    NSDictionary *dicGetMobileNumbers;
                    NSString *strLable=[arrLable objectAtIndex:numberGet];
                    NSString *phoneNumber=[arrvalue objectAtIndex:numberGet];
                   dicGetMobileNumbers=[[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:strLable,phoneNumber, nil] forKeys:[NSArray arrayWithObjects:@"NumberLabel",@"Number", nil]];
                    [person.arrPhoneNumber addObject:dicGetMobileNumbers];
                    
                }
                
                          
                //email
                ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
                
                NSUInteger j = 0;
                for (j = 0; j < ABMultiValueGetCount(emails); j++)
                {
                    NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                    NSDictionary *dicForEmailaddress;
                    if (j == 0)
                    {
                        person.homeEmail = email;
                        dicForEmailaddress=[[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:email,@"Home",nil] forKeys:[NSArray arrayWithObjects:@"Email",@"ForLabel",nil]];
                    }
                    else
                    {
                        person.workEmail = email;
                         dicForEmailaddress=[[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:email,@"Work",nil] forKeys:[NSArray arrayWithObjects:@"Email",@"ForLabel",nil]];
                    }
                    [person.arrEmails addObject:dicForEmailaddress];
                }
                
                /******    BirthDay   ******/
                CFTypeRef bDayProperty = ABRecordCopyValue(contactPerson, kABPersonBirthdayProperty);
                
                if (ABRecordCopyValue(contactPerson, kABPersonBirthdayProperty))
                {
                    NSDate *date=(__bridge NSDate*)bDayProperty;
                    person.strPersonDate=[NSString stringWithFormat:@"%@",date];
                    
                    date = nil;
                }
                
           
                
                //Image of Person
                if(ABPersonHasImageData(contactPerson))
                {
                    NSData *contactImageData = (__bridge NSData*) ABPersonCopyImageDataWithFormat(contactPerson,
                                                                                                  kABPersonImageFormatThumbnail);
                    UIImage *img = [[UIImage alloc] initWithData:contactImageData];
                    person.personImage=img;
                }
              
                
                
                //Last Name
                ABMultiValueRef homeAddress = ABRecordCopyValue(contactPerson, kABPersonAddressProperty);
                
                
                
                for (int k = 0; k < ABMultiValueGetCount(homeAddress); k++)
                {
                    NSDictionary *abDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(homeAddress, i);
                    person.personAddress=abDict;
                    NSString *street = [abDict objectForKey:(NSString *)kABPersonAddressStreetKey];
                    person.street=street;
                    NSString *city = [abDict objectForKey:(NSString *)kABPersonAddressCityKey];
                    person.city=city;
                    NSString *country = [abDict objectForKey:(NSString *)kABPersonAddressCountryKey];
                    person.country=country;
                    NSString *ZipCode = [abDict objectForKey:(NSString *)kABPersonAddressZIPKey];
                    person.ZipCode=ZipCode;
                    
                    NSString *countryCode= [abDict objectForKey:(NSString *)kABPersonAddressCountryCodeKey];
                    person.countryCode=countryCode;
                    NSString *state= [abDict objectForKey:(NSString *)kABPersonAddressStateKey];
                    person.state=state;
                }
                
                [self.tableData addObject:person];
                
                CFRelease(contactPerson);
                CFRelease(phoneNumberProperty);
                CFRelease(emails);
                //CFRelease(bDayProperty);
                CFRelease(homeAddress);
            }
            
        }
        
        }
        
    }
//    [self makeSections];

}


#pragma mark Fetch All Contacts
-(void)fetchAllContacts
{
    
    
    if ([self accessgranted])
    {
        
        //    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
        ABAddressBookRef addressBook;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        }else
        {
            addressBook = ABAddressBookCreate();
        }
        
        [arrallcontacts removeAllObjects];
        
        CFArrayRef allPeople=  ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, nil, kABPersonSortByFirstName);
        
        CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
        
        for ( int i = 0; i < nPeople; i++ )
        {
            
            ABRecordRef record = CFArrayGetValueAtIndex( allPeople, i );
            
            ABRecordID recordid = ABRecordGetRecordID(record) ;
            
            [arrallcontacts addObject:[NSNumber numberWithInt:(int)recordid]];
            
            CFRelease(record);
        }
        
        CFRelease(allPeople);
        // CFRelease(addressBook);
        
        
        
    }
}

-(void)makeSections
{
    charIndex = [[NSMutableArray alloc] init];
    charCount = [[NSMutableDictionary alloc] init];
    NSLog(@"%d",[self.tableData count]);
    for(int i=0; i<[self.tableData count]; i++)
    {
        // get the person
        Person *aPerson=[[Person alloc]init];
        aPerson = [self.tableData objectAtIndex:i];
        
        // get the first letter of the first name
        NSString *firstLetter = [aPerson.fullName substringToIndex:1];
        
        NSLog(@"first letter: %@", firstLetter);
        
        // if the index doesn't contain the letter
        if(![charIndex containsObject:firstLetter])
        {
            // then add it to the index
            NSLog(@"adding: %@", firstLetter);
            [charIndex addObject:firstLetter];
            [charCount setObject:[NSNumber numberWithInt:1] forKey:firstLetter];
        }
        [charCount setObject:[NSNumber numberWithInt:[[charCount objectForKey:firstLetter] intValue] + 1] forKey:firstLetter];
    }
    
}

-(BOOL)accessgranted
{
    __block BOOL accessGranted = NO;
    ABAddressBookRef addressBook;
    if (ABAddressBookRequestAccessWithCompletion != NULL)
    {
        
        // we're on iOS 6
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     
                                                     accessGranted = granted;
                                                     
                                                     dispatch_semaphore_signal(sema);
                                                     
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        dispatch_release(sema);
    }
    else
    {
        // we're on iOS 5 or older
        
        accessGranted = YES;
        
        addressBook = ABAddressBookCreate();
        
    }
    if (!accessGranted)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Go to your privacy setting and grant access to access for your contacts\n Privacy > Contacts > NoteContactApp" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    //CFRelease(addressBook);
    return accessGranted;
}



#pragma mark TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return 1;
    }
    else
    {
        NSLog(@"%@",charIndex);
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(!isSearching)
    {
      return  [arrallcontacts count];
    }
    else
    {
        return [filteredList count];
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
    
    if(!isSearching)
    {
        recid_1 = (ABRecordID)[arrallcontacts[indexPath.row] intValue];
        record = ABAddressBookGetPersonWithRecordID(addressBook1, recid_1);
    }
    else
    {
        recid_1 = (ABRecordID)[filteredList[indexPath.row] intValue];
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
    if (isSearching)
    {
        recordid= (ABRecordID)[filteredList[indexPath.row] intValue];
    }
    else
    {
        recordid = (ABRecordID)[arrallcontacts[indexPath.row] intValue];
    }
    
     ContactViewController *contactViewController = [[ContactViewController alloc] initWithPersonID:recordid];
    contactViewController.personId=recordid;
    [self.navigationController pushViewController:contactViewController animated:YES];
}


- (void)filterListForSearchText:(NSString *)searchText
{
    [filteredList removeAllObjects]; //clears the array from all the string objects it might contain from the previous searches
    
    for (int i=0;i<[arrallcontacts count];i++ )
    {
        
         NSString *title;
        ABRecordID recid_1 = (ABRecordID)[arrallcontacts[i] intValue];
        ABRecordRef record = ABAddressBookGetPersonWithRecordID(addressBook1, recid_1);
        
        
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        
        if (firstName)
            title=firstName;
        
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
        
        if(lastName)
        title=[title stringByAppendingFormat:@" %@",lastName];
       
        NSRange nameRange = [title rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound) {
            [filteredList addObject:[arrallcontacts objectAtIndex:i]];
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