//
//  FTGooglePlacesAPIAutoCompleteResultItem.m
//  ChatWith
//
//  Created by Hadar Landao on 10/22/14.
//  Copyright (c) 2014 Kloe Apps. All rights reserved.
//

#import "FTGooglePlacesAPIAutoCompleteResultItem.h"

/**
 *  Private methods interface
 */
@interface FTGooglePlacesAPIAutoCompleteResultItem (Private)

- (void)ftgpi_importDictionary:(NSDictionary *)dictionary;

@end


@implementation FTGooglePlacesAPIAutoCompleteResultItem
#pragma mark Lifecycle

@synthesize placeId = _placeId, itemId = _itemId, predictionDescription = _predictionDescription, types = _types, originalDictionaryRepresentation = _originalDictionaryRepresentation;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _originalDictionaryRepresentation = dictionary;
        [self ftgpi_importDictionary:dictionary];
        
        //  Object cannot be valid with no id
        if ([_placeId length] == 0) {
            return nil;
        }
        
    }
    return self;
}

#pragma mark Superclass overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> \"%@\"", [self class], self, _predictionDescription];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p> %@", [self class], self, _originalDictionaryRepresentation];
}

- (NSUInteger)hash
{
    //  Google's ID is unique identifier of the item
    return [_placeId hash];
}

- (BOOL)isEqual:(id)object
{
    if ([object class] == [self class]) {
        return [self isEqualToSearchResultItem:(FTGooglePlacesAPISearchResultItem *)object];
    } else {
        return [super isEqual:object];
    }
}

#pragma mark Public interface

- (BOOL)isEqualToSearchResultItem:(FTGooglePlacesAPISearchResultItem *)item
{
    return [_placeId isEqualToString:item.placeId];
}

@end

#pragma mark - Private category

@implementation FTGooglePlacesAPIAutoCompleteResultItem (Private)

//  Private methods are prefixed to avoid methods names collisions on subclassing

- (void)ftgpi_importDictionary:(NSDictionary *)dictionary
{
    _originalDictionaryRepresentation = dictionary;
    
    _placeId = [dictionary ftgp_nilledObjectForKey:@"place_id"];
    _predictionDescription = [dictionary ftgp_nilledObjectForKey:@"description"];
    
    
    _types = [dictionary ftgp_nilledObjectForKey:@"types"];
    
    //  Deprecated, left for backwards compatibility
    _itemId = [dictionary ftgp_nilledObjectForKey:@"id"];
}

@end
