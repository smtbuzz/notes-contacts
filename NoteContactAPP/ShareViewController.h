//
//  ShareViewController.h
//  NoteContactAPP
//
//  Created by puneet on 16/08/13.
//  Copyright (c) 2013 Smartbuzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    NSArray *arrShareToNetwork;
}
@end
