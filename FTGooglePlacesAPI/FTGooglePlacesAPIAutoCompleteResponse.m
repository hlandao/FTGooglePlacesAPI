//
//  FTGooglePlacesAPIAutoCompleteResponse.m
//  ChatWith
//
//  Created by Hadar Landao on 10/22/14.
//  Copyright (c) 2014 Kloe Apps. All rights reserved.
//

#import "FTGooglePlacesAPIAutoCompleteResponse.h"
#import "FTGooglePlacesAPIAutoCompleteResultItem.h"

/**
 *  Private methods interface
 */
@interface FTGooglePlacesAPIAutoCompleteResponse (Private)

- (void)ftgpr_importDictionary:(NSDictionary *)dictionary;
- (NSArray *)ftgpr_parseResultsItemFromArray:(NSArray *)array;
@end


@implementation FTGooglePlacesAPIAutoCompleteResponse {
    __weak Class _resultsItemClass;
}

#pragma mark Lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                           request:(id<FTGooglePlacesAPIRequest>)request
{
    return [self initWithDictionary:dictionary request:request resultsItemClass:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
                           request:(id<FTGooglePlacesAPIRequest>)request
                  resultsItemClass:(Class)resultsItemClass
{
    //  Either there is no custom class or it has to be subclass of FTGooglePlacesAPIResponse so
    //  the code can rely there will be required properties
    //  If this expectation fails, it is clearly programmers fault, so let him know!
    if (resultsItemClass &&
        ![resultsItemClass isSubclassOfClass:[FTGooglePlacesAPIAutoCompleteResultItem class]])
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Custom response item class in FTGooglePlacesAPIAutoCompleteResponse must be a subclass of FTGooglePlacesAPIResponse"
                                     userInfo:nil];
    }
    
    self = [super initWithDictionary:dictionary request:request];
    if (self)
    {
        _resultsItemClass = resultsItemClass;
        [self ftgpr_importDictionary:dictionary];
    }
    return self;
}


@end

#pragma mark - Private methods category

@implementation FTGooglePlacesAPIAutoCompleteResponse (Private)

- (void)ftgpr_importDictionary:(NSDictionary *)dictionary
{
    _htmlAttributions = [dictionary ftgp_nilledObjectForKey:@"html_attributions"];
    
    NSArray *results = [dictionary ftgp_nilledObjectForKey:@"results"];
    _results = [self ftgpr_parseResultsItemFromArray:results];
}

- (NSArray *)ftgpr_parseResultsItemFromArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]] || [array count] == 0) {
        return nil;
    }
    
    //  If there is a custom class response item defined, use that one
    //  else use the default response item class
    Class resultsItemClass = (_resultsItemClass ?: [FTGooglePlacesAPIAutoCompleteResultItem class]);
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:[array count]];
    
    for (NSDictionary *resultDictionary in array)
    {
        id resultItem = [[resultsItemClass alloc] initWithDictionary:resultDictionary];
        [results addObject:resultItem];
    }
    
    return [results copy];
}

@end
