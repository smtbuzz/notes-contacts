//
//  ContactViewController.m
//  AddressBookDemo
//
//  Created by Arthur Knopper on 25/10/12.
//  Copyright (c) 2012 iOSCreator. All rights reserved.
//

#import "ContactViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DatabaseSqlite.h"
@interface ContactViewController ()

@property (nonatomic, strong) IBOutlet UILabel *FullName;
@property (nonatomic, strong) IBOutlet UILabel *companyDetail;

@property (nonatomic, strong) NSString *strFullName;
@property(nonatomic,strong)NSString *CompanyName;

@end

@implementation ContactViewController
@synthesize contactIdFromDB,messageSaveinDb;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithPerson:(Person *)person
{
    self = [super initWithNibName:@"ContactViewController" bundle:nil];
    if (self) {
        _person=person;
        _strFullName=@"";
        if(person.PreFixName.length>0)
        {
            _strFullName=[_strFullName stringByAppendingString:person.PreFixName];
        }
        if(person.fullName.length>0)
        {
            _strFullName=[_strFullName stringByAppendingString:person.fullName];

        }
        if(person.strCompanyName.length>0)
        {
            _CompanyName=person.strCompanyName;
        }
       
        _arrofPersonContacts=person.arrPhoneNumber;
        _arrofPersonEmails=person.arrEmails;
        _dicforPersonAddress=person.personAddress;
        personImage=person.personImage;
    }
    return self;
}

- (id)initWithPersonID:(ABRecordID)personContactID
{
    self = [super initWithNibName:@"ContactViewController" bundle:nil];
    if (self)
    {
        
        _arrofPersonContacts=[[NSMutableArray alloc]init];
        _arrofPersonEmails=[[NSMutableArray alloc]init];
        ABAddressBookRef addressBook1;

        if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
        {
            addressBook1 = ABAddressBookCreate();
        }
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        {
            addressBook1 = ABAddressBookCreateWithOptions(NULL, NULL);
        }
        ABRecordRef record = ABAddressBookGetPersonWithRecordID(addressBook1, personContactID);
        
        
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        
        if (firstName)
        {
            _strFullName=firstName;
        }
        
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
        
        if(lastName)
            _strFullName=[_strFullName stringByAppendingFormat:@" %@",lastName];
        
        //Company Name
        NSString *CompanyName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonOrganizationProperty);
        
        _CompanyName=CompanyName;
        
        
        /***** Phone number MultiValues *****/
        ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(record, kABPersonPhoneProperty);
        
        NSMutableArray *arrLable=[[NSMutableArray alloc]init];
        NSMutableArray *arrvalue=[[NSMutableArray alloc]init];
        NSLog(@"%ld", ABMultiValueGetCount(phoneNumberProperty));
        
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
            [_arrofPersonContacts addObject:dicGetMobileNumbers];
            
        }
        
        
        //email
        ABMultiValueRef emails = ABRecordCopyValue(record, kABPersonEmailProperty);
        
        NSUInteger j = 0;
        for (j = 0; j < ABMultiValueGetCount(emails); j++)
        {
            NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
            NSDictionary *dicForEmailaddress;
            if (j == 0)
            {
                dicForEmailaddress=[[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:email,@"Home",nil] forKeys:[NSArray arrayWithObjects:@"Email",@"ForLabel",nil]];
            }
            else
            {
                dicForEmailaddress=[[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:email,@"Work",nil] forKeys:[NSArray arrayWithObjects:@"Email",@"ForLabel",nil]];
            }
            [_arrofPersonEmails addObject:dicForEmailaddress];
        }
        

        
        
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Info";
    
    /* Bar button done */
    UIBarButtonItem *btnDoneAddingNote=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(btnAllAction:)];
    btnDoneAddingNote.tag=btnDoneAddingNoteTAG;
    self.navigationItem.rightBarButtonItem=btnDoneAddingNote;
    
    
  
    _FullName.text=_strFullName;
    _companyDetail.text=_CompanyName;
    
    [objTableView setBackgroundColor:[UIColor clearColor]];
    objTableView.scrollEnabled=NO;
    
    
    
       int j=140;
    for(int i=0;i<[_arrofPersonContacts count];i++)
    {
     
        
        UIButton *btnForActiononNumber=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnForActiononNumber.tag=btnForActiononNumberTAG+i;
        btnForActiononNumber.frame=CGRectMake(230,5 ,30 ,30 );
        [btnForActiononNumber addTarget:self action:@selector(showPopUpMessage:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lblForContactNumber=[[UILabel alloc]initWithFrame:CGRectMake(20, j, 280,40 )];
        lblForContactNumber.userInteractionEnabled=YES;
        NSString *strGetNumbers=[[_arrofPersonContacts objectAtIndex:i] valueForKey:@"NumberLabel"];
          lblForContactNumber.text =[NSString stringWithFormat:@" %@       %@",strGetNumbers,[[_arrofPersonContacts objectAtIndex:i] valueForKey:@"Number"]];
        lblForContactNumber.layer.cornerRadius=5;
        [lblForContactNumber addSubview:btnForActiononNumber];
        j=j+42;

        [objScrollView addSubview:lblForContactNumber];
    }
    if([_arrofPersonEmails count]>0)
    {
    j=j+30;
    }
    for(int i=0;i<[_arrofPersonEmails count];i++)
    {
        
        UILabel *lblForEmailAddress=[[UILabel alloc]initWithFrame:CGRectMake(20, j, 280,40 )];
        
        NSString *strGetNumbers=[[_arrofPersonEmails objectAtIndex:i] valueForKey:@"ForLabel"];
        lblForEmailAddress.text =[NSString stringWithFormat:@" %@       %@",strGetNumbers,[[_arrofPersonEmails objectAtIndex:i] valueForKey:@"Email"]];
        lblForEmailAddress.layer.cornerRadius=5;
        j=j+42;
        
        [objScrollView addSubview:lblForEmailAddress];
    }
    if([[_dicforPersonAddress valueForKey:@"Country"] length]>0)
    {
        j=j+30;
    

    UIView *viewForAddress=[[UIView alloc]initWithFrame:CGRectMake(20,j ,280 ,(30*4) )];
    viewForAddress.backgroundColor=[UIColor whiteColor];
    viewForAddress.layer.cornerRadius=5;
    [objScrollView addSubview:viewForAddress];
    j=j+viewForAddress.frame.size.height;
    
    UILabel *PersonHomeAddresslbl=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, viewForAddress.frame.size.height-10)];
    PersonHomeAddresslbl.text=@"Home";
    [viewForAddress addSubview:PersonHomeAddresslbl];
    
    
    UILabel *lblForPersonAddress=[[UILabel alloc]initWithFrame:CGRectMake(150, 5, 130, viewForAddress.frame.size.height-10)];
    lblForPersonAddress.font=[UIFont systemFontOfSize:16];
    lblForPersonAddress.numberOfLines=5;
    NSString *strPersonAddess;
    strPersonAddess=[NSString stringWithFormat:@"%@\n%@\n%@ %@\n%@",[_dicforPersonAddress valueForKey:@"Street"],[_dicforPersonAddress valueForKey:@"City"],[_dicforPersonAddress valueForKey:@"State"],[_dicforPersonAddress valueForKey:@"ZIP"],[_dicforPersonAddress valueForKey:@"Country"]];
  
    lblForPersonAddress.text=strPersonAddess;
        [viewForAddress addSubview:lblForPersonAddress];
    }
      j=j+30;
    
    UIView *viewForAddNotes=[[UIView alloc]initWithFrame:CGRectMake(20,j ,280 ,160)];
    viewForAddNotes.backgroundColor=[UIColor whiteColor];
    viewForAddNotes.layer.cornerRadius=5;
    [objScrollView addSubview:viewForAddNotes];
    
    UILabel *lblForHEaderAddNote=[[UILabel alloc]initWithFrame:CGRectMake(5,5 ,270 ,20 )];
    lblForHEaderAddNote.text=@"My Note";
    [viewForAddNotes addSubview:lblForHEaderAddNote];
    
    objTextview=[[UITextView alloc]initWithFrame:CGRectMake(5,35 ,270, 120)];
    objTextview.tag=txtNoteViewTAG;
    objTextview.delegate=self;
    objTextview.layer.borderColor=[[UIColor grayColor] CGColor];
    objTextview.layer.borderWidth=2.0;
    objTextview.tag=objTextviewTAG;
    [viewForAddNotes addSubview:objTextview];
    
    objScrollView.contentSize=CGSizeMake(320, j+190);

    
    /*
     
     make call to particular number
     
         
     */
    
    if([contactIdFromDB length]>0)
    {
        objTextview.text=messageSaveinDb;
    }

  }

-(void)showPopUpMessage:(id)sender
{
    
    strNumber=[[_arrofPersonContacts objectAtIndex:[sender tag]-btnForActiononNumberTAG] valueForKey:@"Number"];

    UIAlertView *objAletForOption=[[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send Message",@"Make a Call", nil];
    [objAletForOption show];
}

#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        NSLog(@"%@",strNumber);
    switch (buttonIndex)
    {
        case 1:
        {
            NSLog(@"Sms");
            
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"Hello from Mugunth";
                controller.recipients = [NSArray arrayWithObjects:strNumber,  nil];
                controller.messageComposeDelegate = self;
                [self presentModalViewController:controller animated:YES];
            }
        }
            break;
            case 2:
        {
            NSLog(@"Call");
            UIDevice *device = [UIDevice currentDevice];
            if ([[device model] isEqualToString:@"iPhone"] )
            {
                NSString *phoneNumber=[KAppDelegate cleanMobileNumber:strNumber];
                NSLog(@"%@",phoneNumber);
                NSString *phoneURLString = [NSString stringWithFormat:@"tel://%@",phoneNumber];
                NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
                
                
                NSString *osVersion = [[UIDevice currentDevice] systemVersion];
                
                if ([osVersion floatValue] >= 3.1) {
                    UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
                    [webview loadRequest:[NSURLRequest requestWithURL:phoneURL]];
                    webview.hidden = YES;
                    // Assume we are in a view controller and have access to self.view
                    [self.view addSubview:webview];
                } else { 
                    // On 3.0 and below, dial as usual 
                    [[UIApplication sharedApplication] openURL: phoneURL];
                }

            } else {
                UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [Notpermitted show];
            }

        }
            
        default:
            break;
    }
}


#pragma mark -Message Delegate-
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result)
    {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MyApp" message:@"Unknown Error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
		}
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -TexiView Delegate-
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    else
    {
     NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 255) ? NO : YES;
    }
    return YES;
}


#pragma mark -btnAllAction-
-(void)btnAllAction:(id)sender
{
    switch ([sender tag])
    {
        case btnDoneAddingNoteTAG:
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0 ,320 ,416)];
            imageView.image=[UIImage imageNamed:@"original.jpeg"];
           
            objTextview.frame=CGRectMake(20, 100, objTextview.frame.size.width,objTextview.frame.size.height);
            NSLog(@"%@",objTextview.text);
            [imageView addSubview:objTextview];
            
            UIGraphicsBeginImageContext(imageView.frame.size);
            [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            
            ABAddressBookRef addressBook1;
            
            if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
            {
                addressBook1 = ABAddressBookCreate();
            }
            
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
            {
                addressBook1 = ABAddressBookCreateWithOptions(NULL, NULL);
            }
            
            
            ABRecordRef contactPerson = ABAddressBookGetPersonWithRecordID(addressBook1, _personId);
          
            
            // If it was assigned photo to person, Must delete assigned photo.
            CFErrorRef error;
            if (ABPersonHasImageData(contactPerson))
            {
                BOOL didRemoveImageData = ABPersonRemoveImageData(contactPerson, &error);
                if (!didRemoveImageData)
                    NSLog(@"Error: %@", [(__bridge NSError *)error localizedDescription]);
            }
            //
            //    // Set photo to selected person
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            BOOL didSetImageData = ABPersonSetImageData(contactPerson, (__bridge CFDataRef)data, &error);
            if (!didSetImageData) NSLog(@"Error: %@", [(__bridge NSError *)error localizedDescription]);
            
            
            
            if (ABAddressBookSave(addressBook1, NULL)) {
                // Show success message
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil) message:NSLocalizedString(@"Saved to your contact", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] ;
                [av show];
                
                // Add modified or added photo to Main imageview
            }
            
            if([contactIdFromDB length]==0)
            {
            [[DatabaseSqlite getSharedInstance] saveData:_strFullName withReferId:[NSString stringWithFormat:@"%d",_personId] withMessage:objTextview.text];
            }
            else
            {
                 [[DatabaseSqlite getSharedInstance] updateContactNote:contactIdFromDB withUpdateMessage:objTextview.text];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TableView Delegate



@end
