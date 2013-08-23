//
//  Person.m
//  AddressBookDemo
//
//  Created by Arthur Knopper on 24/10/12.
//  Copyright (c) 2012 iOSCreator. All rights reserved.
//

#import "Person.h"

@implementation Person
@synthesize arrPhoneNumber,arrEmails,personAddress,arrRefId;
- (id)init
{
    self = [super init];
    if (self) {
        arrPhoneNumber=[[NSMutableArray alloc]init];
        arrEmails=[[NSMutableArray alloc]init];
        personAddress=[[NSDictionary alloc]init];
        arrRefId=[[NSMutableArray alloc]init];
    }
    return self;
}




@end
