//
//  FTGooglePlacesAPIAutoCompleteResultItem.h
//  ChatWith
//
//  Created by Hadar Landao on 10/22/14.
//  Copyright (c) 2014 Kloe Apps. All rights reserved.
//

#import <FTGooglePlacesAPI.h>
#import <Foundation/Foundation.h>

@interface FTGooglePlacesAPIAutoCompleteResultItem : FTGooglePlacesAPISearchResultItem

@property (nonatomic, strong, readonly) NSString *predictionDescription; // The descreption value
@property (nonatomic, strong, readonly) NSArray *types;

/**
 *  You can access complete response dictionary using this property.
 *  In case implementation changes in a future and there will be new values
 *  for example, you can access them directly using this property even
 *  if the library is not ready for those yet
 */
@property (nonatomic, strong, readonly) NSDictionary *originalDictionaryRepresentation;


/**
 *  Designated initializer contructs intance from a Google Places API
 *  response dictionary
 *
 *  @param dictionary Response dictionary (parsed JSON/XML)
 *
 *  @return Instance of a result
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  Method for comparing equality of two result item objects.
 *  Objects are considered to be equal if their "placeId" equals.
 *
 *  @param item Item to compare with
 *
 *  @return YES if both objects are considered to be equal
 */
- (BOOL)isEqualToSearchResultItem:(FTGooglePlacesAPISearchResultItem *)item;



/*
 "description" : "Paris, France",
 "id" : "691b237b0322f28988f3ce03e321ff72a12167fd",
 "matched_substrings" : [
 {
 "length" : 5,
 "offset" : 0
 }
 ],
 "place_id" : "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",
 "reference" : "CjQlAAAA_KB6EEceSTfkteSSF6U0pvumHCoLUboRcDlAH05N1pZJLmOQbYmboEi0SwXBSoI2EhAhj249tFDCVh4R-PXZkPK8GhTBmp_6_lWljaf1joVs1SH2ttB_tw",
 "terms" : [
 {
 "offset" : 0,
 "value" : "Paris"
 },
 {
 "offset" : 7,
 "value" : "France"
 }
 ],
 "types" : [ "locality", "political", "geocode" ]

 */
@end
