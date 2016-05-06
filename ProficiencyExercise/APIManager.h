//
//  APIManager.h
//  ProficiencyExercise
//
//  Created by  Pankaj Nilangekar on 5/4/16.
//  Copyright © 2016  Pankaj Nilangekar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject
/*
 * Method to send REST API request and receive response in data Format, It will callback Success block with NSDictionary as response format
 * urlString : String containg Server URL to fetch the response
 * success : Callback block with the response in nsdictionary format
 * failure : Callback block with the failure response 
 */
- (void)getJsonResponse : (NSString *)urlString success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure;

@end
