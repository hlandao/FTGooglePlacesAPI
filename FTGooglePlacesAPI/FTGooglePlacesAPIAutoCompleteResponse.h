//
//  FTGooglePlacesAPIAutoCompleteResponse.h
//  ChatWith
//
//  Created by Hadar Landao on 10/22/14.
//  Copyright (c) 2014 Kloe Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FTGooglePlacesAPI.h>

@interface FTGooglePlacesAPIAutoCompleteResponse : FTGooglePlacesAPIResponse

/**
 *  Array of results items. Items are instances of class provided in init... method
 */
@property (nonatomic, strong, readonly) NSArray *results;

/**
 *  Contain a set of attributions about this listing which must be displayed to the user
 *  to conform Google Terms and Conditions
 */
@property (nonatomic, strong, readonly) NSArray *htmlAttributions;

/**
 *  Designated initializer for a response.
 *
 *  @param dictionary Dictionary from which the response will be parsed.
 *  @param request Request which resulted to this response
 *  @param resultsItemClass Class of the result item to be used. You can either subclass of FTGooglePlacesAPIAutoCompleteItem or nil. When nil is used, default FTGooglePlacesAPIAutoCompleteItem will be used
 *
 *  @return Initialized instance of the response parsed from the dictionary or nil if anything failed
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                           request:(id<FTGooglePlacesAPIRequest>)request
                  resultsItemClass:(Class)resultsItemClass;

@end
