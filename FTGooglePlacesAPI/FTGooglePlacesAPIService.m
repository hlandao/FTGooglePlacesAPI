//
//  FTGooglePlacesAPIService.m
//
//  Created by Lukas Kukacka on 10/29/13.
//
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Fuerte Int. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "FTGooglePlacesAPIService.h"

#import "AFNetworking.h"
#import "FTGooglePlacesAPISearchResponse.h"
#import "FTGooglePlacesAPIDetailResponse.h"


NSString *const FTGooglePlacesAPIBaseURL = @"https://maps.googleapis.com/maps/api/place/";

/**
 *  Private methods interface
 */
@interface FTGooglePlacesAPIService (Private)

+ (NSString *)ftgp_queryStringWithDictionary:(NSDictionary *)dictionary;
+ (NSError *)ftgp_errorForResponseStatus:(FTGooglePlacesAPIResponseStatus)status;

@end

#pragma mark -

static BOOL FTGooglePlacesAPIDebugLoggingEnabled;

@interface FTGooglePlacesAPIService ()

@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, weak) Class searchResultsItemClass;

/**
 *  Shared singleton instance
 */
+ (instancetype)sharedService;

@end



@implementation FTGooglePlacesAPIService

#pragma mark Lifecycle

+ (FTGooglePlacesAPIService *)sharedService
{
    static FTGooglePlacesAPIService *SharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SharedInstance = [[FTGooglePlacesAPIService alloc] init];
    });
    
    return SharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _apiKey = nil;
        _searchResultsItemClass = nil;
        FTGooglePlacesAPIDebugLoggingEnabled = NO;
    }
    return self;
}

#pragma mark Accessors

- (void)setApiKey:(NSString *)apiKey
{
    NSAssert([apiKey length] > 0, @"You must provide non-empty API key");
    _apiKey = apiKey;
}

#pragma mark Class methods

+ (void)provideAPIKey:(NSString *)APIKey
{
    [[[self class] sharedService] setApiKey:APIKey];
}

+ (void)registerSearchResultItemClass:(Class)itemClass
{
    [[[self class] sharedService] setSearchResultsItemClass:itemClass];
}

+ (void)executeSearchRequest:(id<FTGooglePlacesAPIRequest>)request
       withCompletionHandler:(FTGooglePlacesAPISearchRequestCompletionHandler)completion
{
    [[self class] executeRequest:request withCompletionHandler:^(NSDictionary *responseObject, NSError *error) {
        
        //  Networing, parsing or other general error
        if (error) {
            completion(nil, error);
            return;
        }
        
        //  Parse response
        Class resultsItemClass = [[[self class] sharedService] searchResultsItemClass];
        
        FTGooglePlacesAPISearchResponse *response = [[FTGooglePlacesAPISearchResponse alloc] initWithDictionary:responseObject request:request resultsItemClass:resultsItemClass];
        
#ifdef DEBUG
        if (FTGooglePlacesAPIDebugLoggingEnabled) {
            NSLog(@"%@ received response. Status: %@, number of results: %d", [self class], [FTGooglePlacesAPISearchResponse localizedNameOfStatus:response.status], [response.results count]);
        }
#endif
        
        // Check if everything went OK
        if (response && response.status == FTGooglePlacesAPIResponseStatusOK) {
            completion(response, nil);
        }
        // If network request was successfull, but Google Places API
        // responded with error status code
        else {
            completion(response, [[self class] ftgp_errorForResponseStatus:response.status]);
        }
    }];
}

+ (void)executeDetailRequest:(id<FTGooglePlacesAPIRequest>)request
       withCompletionHandler:(FTGooglePlacesAPIDetailRequestCompletionhandler)completion
{
    [[self class] executeRequest:request withCompletionHandler:^(NSDictionary *responseObject, NSError *error) {
        
        //  Networing, parsing or other general error
        if (error) {
            completion(nil, error);
            return;
        }
        
        //  Try to parse response to object
        FTGooglePlacesAPIDetailResponse *response = [[FTGooglePlacesAPIDetailResponse alloc] initWithDictionary:responseObject request:request];
        
        // Check if everything went OK
        if (response && response.status == FTGooglePlacesAPIResponseStatusOK) {
            completion(response, nil);
        }
        // If network request was successfull, but Google Places API
        // responded with error status code
        else {
            completion(response, [[self class] ftgp_errorForResponseStatus:response.status]);
        }
    }];
}

+ (void)setDebugLoggingEnabled:(BOOL)enabled
{
    FTGooglePlacesAPIDebugLoggingEnabled = enabled;
}

#pragma mark - Private methods

+ (void)executeRequest:(id<FTGooglePlacesAPIRequest>)request
 withCompletionHandler:(void(^)(NSDictionary *responseObject, NSError *error))completion
{
    NSAssert(completion, @"You must provide completion block for the Google Places API request execution. Performing request without handling does not make any sense.");
    
    NSString *apiKey = [[[self class] sharedService] apiKey];
    NSAssert([apiKey length] > 0, @"You must first provide API key using [FTGooglePlacesAPIService provideAPIKey:] before executing Google Places API requests");
    
    NSMutableDictionary *params = [[request placesAPIRequestParams] mutableCopy];
    
    //  Add params which this service takes care of
    params[@"key"] = apiKey;
    params[@"sensor"] = @"true";    //  Constant for now
    
    //  Encode parameters dictionary into URL query string
    NSString *paramsQueryString  = [[self class] ftgp_queryStringWithDictionary:params];
    
    //  Construct full request URL with percent escaping
    NSString *requestUrlString = [NSString stringWithFormat:@"%@%@/json?%@", FTGooglePlacesAPIBaseURL, [request requestTypeUrlString], paramsQueryString];
    requestUrlString = [requestUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
#ifdef DEBUG
    if (FTGooglePlacesAPIDebugLoggingEnabled) {
        NSLog(@"%@ performing request: %@", [self class], requestUrlString);
    }
#endif
    
    //  Perform request using AFNetworking
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:requestUrlString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         completion(responseObject, nil);
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completion(nil, error);
     }];
}

@end

#pragma mark - Private methods category

@implementation FTGooglePlacesAPIService (Private)

+ (NSString *)ftgp_queryStringWithDictionary:(NSDictionary *)dictionary
{
    NSMutableString *ms = [NSMutableString string];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        
        if ([ms length] > 0) {
            [ms appendString:@"&"];
        }
        //  Parameters with [NSNull null] value are without, just keys should be
        //  present in the URL
        if ((NSNull *)obj == [NSNull null]) {
            [ms appendString:key];
        } else {
            [ms appendFormat:@"%@=%@", key, obj];
        }
    }];
    
    return [ms copy];
}

+ (NSError *)ftgp_errorForResponseStatus:(FTGooglePlacesAPIResponseStatus)status
{
    NSDictionary *userInfo = @{
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Google Places API request failed", nil),
        NSLocalizedDescriptionKey: [FTGooglePlacesAPIResponse localizedDescriptionForStatus:status]
    };
    
    return [NSError errorWithDomain:FTGooglePlacesAPIErrorDomain code:status userInfo:userInfo];
}

@end
