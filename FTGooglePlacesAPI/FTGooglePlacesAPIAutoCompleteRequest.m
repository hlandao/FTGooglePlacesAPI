//
//  FTGooglePlacesAPIAutoCompleteRequest.m
//  ChatWith
//
//  Created by Hadar Landao on 10/22/14.
//  Copyright (c) 2014 Kloe Apps. All rights reserved.
//

#import "FTGooglePlacesAPIAutoCompleteRequest.h"

static const NSUInteger kMaxRadius = 50000;

@implementation FTGooglePlacesAPIAutoCompleteRequest

@synthesize input = _input;

#pragma mark Lifecycle

- (instancetype)initWithInput:(NSString *)input
{
    
    self = [super init];
    if (self) {
        if ([input length] == 0) {
            NSLog(@"WARNING: Trying to create FTGooglePlacesAPIAutoCompleteRequest with empty input. Returning nil");
            return nil;
        }
        
        _input = input;
        //  Default values
        _radius = kMaxRadius+1; // Indicate "no value" by overflowing max radius value
        _locationCoordinate = CLLocationCoordinate2DMake(10000, 10000); // Default is invalid value
        _language = [FTGooglePlacesAPIUtils deviceLanguage];

    }
    return self;
}


#pragma mark - Superclass overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> User Input: %@", [self class], self, _input];
}


#pragma mark - FTGooglePlacesAPIRequest protocol

- (NSString *)placesAPIRequestMethod
{
    return @"autocomplete";
}

- (NSDictionary *)placesAPIRequestParams
{
    return @{@"input": _input};
}




@end
