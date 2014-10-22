//
//  FTGooglePlacesAPIAutoCompleteRequest.h
//  ChatWith
//
//  Created by Hadar Landao on 10/22/14.
//  Copyright (c) 2014 Kloe Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTGooglePlacesAPICommon.h"
#import <CoreLocation/CoreLocation.h>

@interface FTGooglePlacesAPIAutoCompleteRequest : NSObject<FTGooglePlacesAPIRequest>

/**
 *  The user input for the autocomplete request
 */
@property (nonatomic, strong) NSString *input;

/**
 *  The latitude/longitude around which to retrieve Place information.
 *  This stands for "location" Google Places API parameter
 *  This must be specified as latitude,longitude. If you specify a location
 *  parameter, you must also specify a radius parameter.
 */
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;

/**
 *  Defines the distance (in meters) within which to return Place results.
 *  The maximum allowed radius is 50 000 meters. Default: none
 */
@property (nonatomic, assign) NSUInteger radius;

/**
 *  The language code, indicating in which language the results should be returned, if possible.
 *  See http://spreadsheets.google.com/pub?key=p9pdwsai2hDMsLkXsoM05KQ&gid=1 for a complete list
 *
 *  Default value is determined by active application language from NSUserDefaults
 *  if available
 *  (details: https://developer.apple.com/library/ios/documentation/MacOSX/Conceptual/BPInternational/Articles/ChoosingLocalizations.html)
 */
@property (nonatomic, copy) NSString *language;


/**
 *  Restricts the results to Places matching at least one of the specified types.
 *  Provide array of NSStrings
 *  See https://developers.google.com/places/documentation/supported_types
 *  for the list of all available types
 */
@property (nonatomic, copy) NSArray *types;


/**
 *  Create new autocomplete request with the given user's input
 */
-(instancetype) initWithInput:(NSString *)input;


@end
