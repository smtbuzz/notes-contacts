//
//  AppDelegate.m
//  NoteContactAPP
//
//  Created by puneet on 16/08/13.
//  Copyright (c) 2013 Smartbuzz. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "NotesContactVC.h"
#import "ShareViewController.h"
#import "MoreViewController.h"
#include <sys/xattr.h>

@implementation AppDelegate
@synthesize strDocumentDirectoryPath;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
//    } else {
//        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
//    }
    [self addTabbarController];
   [self documentDirectoryPath];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark  Get Document Directory Path
-(void)documentDirectoryPath
{
    
    NSArray *arrDocumentDirPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    strDocumentDirectoryPath=[arrDocumentDirPaths objectAtIndex:0];
    NSLog(@"STR Path %@",strDocumentDirectoryPath);
    
}
-(void)addTabbarController
{
    UINavigationController *VCNavigationController;
    // Create initialized instance of UITabBarController
    tabBarCntr = [[UITabBarController alloc] init];
    tabBarCntr.delegate=self;
    // Create initialized instance of NSMutableArray to hold our UINavigationControllers
    NSMutableArray *tabs = [[NSMutableArray alloc] init];
    
    ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];

    VCNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [tabs addObject:VCNavigationController];
    // Release UIViewController and UINavigationController
   

    
    
    // Create second UIViewController
    NotesContactVC *notesContactVC = [[NotesContactVC alloc] initWithNibName:@"NotesContactVC" bundle:nil];
    VCNavigationController = [[UINavigationController alloc] initWithRootViewController:notesContactVC];
    [tabs addObject:VCNavigationController];

    // Create Third UIViewController
    ShareViewController *objShareVC = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    VCNavigationController = [[UINavigationController alloc] initWithRootViewController:objShareVC];
    [tabs addObject:VCNavigationController];
    
    // Create Fourth UIViewController
    MoreViewController *objMoreVC = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    VCNavigationController = [[UINavigationController alloc] initWithRootViewController:objMoreVC];
    [tabs addObject:VCNavigationController];
    
    viewController.tabBarItem.image = [UIImage imageNamed:@"12.png"];

    
    // Add the tabs to the UITabBarController
    [tabBarCntr setViewControllers:tabs];
    // Add the view of the UITabBarController to the window
    
    [[tabBarCntr.tabBar.items objectAtIndex:0] setTitle:@"All Contacts"];
    [[tabBarCntr.tabBar.items objectAtIndex:1] setTitle:@"Notes Contact"];
    [[tabBarCntr.tabBar.items objectAtIndex:2] setTitle:@"Share"];
    [[tabBarCntr.tabBar.items objectAtIndex:3] setTitle:@"More"];

    self.window.rootViewController=tabBarCntr;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 1)
    {
        [(NotesContactVC*)[(UINavigationController*)viewController topViewController] refreshData];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - No back Mark -
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    return result == 0;
    
}


-(NSString *)cleanLable:(NSString *)lableNmae
{
    lableNmae = [lableNmae stringByReplacingOccurrencesOfString:@"_" withString:@""];
    lableNmae = [lableNmae stringByReplacingOccurrencesOfString:@"$" withString:@""];
    lableNmae = [lableNmae stringByReplacingOccurrencesOfString:@"!" withString:@""];
    lableNmae = [lableNmae stringByReplacingOccurrencesOfString:@"<" withString:@""];
    lableNmae = [lableNmae stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"%@", lableNmae);
    
    return lableNmae;
}

-(NSString *)cleanMobileNumber:(NSString *)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    
    return mobileNumber;
}

@end
