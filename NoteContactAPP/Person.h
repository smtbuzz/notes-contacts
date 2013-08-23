//
//  Person.h
//  AddressBookDemo
//
//  Created by Arthur Knopper on 24/10/12.
//  Copyright (c) 2012 iOSCreator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString *PreFixName;
@property(nonatomic,strong) NSString *NickName;
@property(nonatomic,strong) NSString *MiddleName;   //3

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *strCompanyName;
@property (nonatomic, strong) NSString *fullName;

@property (nonatomic, strong) NSString *homeEmail;
@property (nonatomic, strong) NSString *workEmail;  //6
@property(nonatomic,strong)NSMutableArray *arrEmails;



//@property (nonatomic, strong) NSString *Mobile;
//@property (nonatomic, strong) NSString *iPhone;
//@property (nonatomic, strong) NSString *Home;
//@property (nonatomic, strong) NSString *Work;
//@property (nonatomic, strong) NSString *Main;
//@property (nonatomic, strong) NSString *HomeFAX;
//@property (nonatomic, strong) NSString *other;  //7
@property(nonatomic,strong)NSMutableArray *arrPhoneNumber;
@property(nonatomic,strong)NSDictionary *personAddress;
@property(nonatomic,strong)UIImage *personImage;



@property(nonatomic,strong) NSString *strSuffix;

@property (nonatomic, strong) NSString *strPersonDate;


@property(nonatomic,strong) NSString *street;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *country;
@property(nonatomic,strong) NSString *ZipCode;
@property(nonatomic,strong) NSString *countryCode;
@property(nonatomic,strong) NSString *state;    //6
@property(strong,nonatomic) NSMutableArray *arrRefId;


@end
