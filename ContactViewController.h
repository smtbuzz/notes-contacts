//
//  ContactViewController.h
//  AddressBookDemo
//
//  Created by Arthur Knopper on 25/10/12.
//  Copyright (c) 2012 iOSCreator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import <MessageUI/MessageUI.h>
typedef enum
{
    objTextviewTAG=10000,
    txtNoteViewTAG=20000,
    btnDoneAddingNoteTAG,
    btnForActiononNumberTAG=30000,
}ContactViewControllerTAGs;
@interface ContactViewController : UIViewController<UITextViewDelegate,MFMessageComposeViewControllerDelegate>
{
    IBOutlet UITableView* objTableView;
    IBOutlet UIScrollView* objScrollView;
    IBOutlet UIImageView *personImageView;
    UITextView *objTextview;
    UIImage *personImage;
    NSString *strNumber;
}
@property (nonatomic, strong) Person *person;
@property(nonatomic,strong)NSMutableArray *arrofPersonContacts;
@property(nonatomic,strong)NSMutableArray *arrofPersonEmails;
@property(nonatomic,strong)NSDictionary *dicforPersonAddress;

 @property(nonatomic,assign)ABRecordID personId;
@property(nonatomic,assign)NSString *contactIdFromDB;
@property(nonatomic,assign)NSString *messageSaveinDb;


- (id)initWithPerson:(Person *)person;
- (id)initWithPersonID:(ABRecordID)personContactID;

@end
