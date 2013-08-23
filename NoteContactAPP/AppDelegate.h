//
//  AppDelegate.h
//  NoteContactAPP
//
//  Created by puneet on 16/08/13.
//  Copyright (c) 2013 Smartbuzz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate>
{
    UITabBarController *tabBarCntr;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong , nonatomic) NSString *strDocumentDirectoryPath;
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
-(NSString *)cleanLable:(NSString *)lableNmae;
-(NSString *)cleanMobileNumber:(NSString *)mobileNumber;
@end
