//
//  InAppRageIAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "InAppRageIAPHelper.h"
@implementation InAppRageIAPHelper

static InAppRageIAPHelper * _sharedHelper;

+ (InAppRageIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[InAppRageIAPHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init {
   
 	
    NSSet *productIdentifiers = [NSSet setWithArray:[NSArray arrayWithObjects:@"", nil]];
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {
        
    }
    return self;
    
}
+ (void)createDirectoryNamed:(NSString*)dir AtPath:(NSString*)documentsDirectory {
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:dir];

    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error])
            ;// success
        else
        {
            NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
        }
    }
}

+(NSString*) getDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    return  documentsDirectory;
}
+(NSString*) getDownloadDirectory {
    NSString *dd =     [[self class] getDocumentDirectory];
    return dd; //[NSString stringWithFormat:@"%@/%lu/",dd,(unsigned long)DefineDownloadDirectory];
}
@end
