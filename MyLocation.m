//
//  MyLocation.m
//  Diners Guide
//
//  Created by Clay Ewing on 10/5/12.
//  Copyright (c) 2012 Clay Ewing. All rights reserved.
//

#import "MyLocation.h"
#import <AddressBook/AddressBook.h>

@interface MyLocation ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end

@implementation MyLocation
@synthesize sid, legality;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinates:(CLLocationCoordinate2D) coordinate sid:(NSString*)pid legality:(NSString*)legal {
    if ((self = [super init])) {
        self.name = name;
        self.address = address;
        self.theCoordinate = coordinate;
        self.sid = pid;
        self.legality = legal;
    }
    
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end