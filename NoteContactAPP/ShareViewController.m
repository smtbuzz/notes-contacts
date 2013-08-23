//
//  ShareViewController.m
//  NoteContactAPP
//
//  Created by puneet on 16/08/13.
//  Copyright (c) 2013 Smartbuzz. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

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
    arrShareToNetwork=[[NSArray alloc]initWithObjects:@"Mail",@"SMS",@"Facebook",@"Twitter", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrShareToNetwork count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text=[arrShareToNetwork objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.row) {
        case 0:
        {
            [self sendMail];
        }
            
            break;
            case 1:
        {
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"Hello from Mugunth";
                
                controller.messageComposeDelegate = self;
                [self presentModalViewController:controller animated:YES];
            }
        }
            break;
        case 2:
        {
             
             if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
             {
        
             SLComposeViewController *mySLComposerSheet = [[SLComposeViewController alloc] init];
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [mySLComposerSheet setInitialText:@"Note In contact"];
            
            [mySLComposerSheet addImage:[UIImage imageNamed:@""]];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
             }
            
        }
            break;
            case 3:
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
            SLComposeViewController *mySLComposerSheet = [[SLComposeViewController alloc] init];
            
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [mySLComposerSheet setInitialText:@"Note In contact"];
            
            [mySLComposerSheet addImage:[UIImage imageNamed:@""]];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alertErrorMsg=[[UIAlertView alloc]initWithTitle:nil message:@"FaceBook account is not configured." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertErrorMsg show];
            }
        }
            
        default:
            break;
    }
}

-(void)sendMail
{
if([MFMailComposeViewController canSendMail])
{
    MFMailComposeViewController *objMailComposer = [[MFMailComposeViewController alloc] init];
    objMailComposer.mailComposeDelegate = self;
    
    NSString *emailBody=@"Note In Contact App";
  
    
    [objMailComposer setMessageBody:emailBody isHTML:NO];
    objMailComposer.navigationBar.barStyle = UIBarStyleBlack;
    [self presentModalViewController:objMailComposer animated:YES];
}
else
{
    UIAlertView *alertErrorMsg=[[UIAlertView alloc]initWithTitle:nil message:@"E-mail account is not configured." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alertErrorMsg show];
    }
}
#pragma mark - MFmailComposer Delegate -
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    NSString *textMailResult;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            textMailResult = @"Cancelled";
            break;
        case MFMailComposeResultSaved:
            textMailResult = @"Saved";
            break;
        case MFMailComposeResultSent:
            textMailResult = @"Sent";
            break;
        case MFMailComposeResultFailed:
            textMailResult = @"Failed";
            break;
        default:
            textMailResult = @"Not sent";
            break;
    }
    
    UIAlertView *alertMailStatus=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Status: %@",textMailResult] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alertMailStatus show];

    
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -Message Composer Delegate-
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
        {
            
        }
			break;
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}

@end
