

#import "APIManager.h"

@implementation APIManager

/*
 * Method to send REST API request and receive response in data Format, It will callback Success block with NSDictionary as response format
 * urlString : String containg Server URL to fetch the response
 * success : Callback block with the response in nsdictionary format
 * failure : Callback block with the failure response
 */
- (void)getJsonResponse : (NSString *)urlString success : (void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure
{
 
    //Initialise session and NSURL objects required for
    NSURLSession * session = [NSURLSession sharedSession];
    NSURL        * url     = [NSURL URLWithString: urlString];
    
    
    // Api will be called asynchronously
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                       {

                                           NSString *stringForData = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                                           NSData *dataInUTF8Format = [stringForData dataUsingEncoding:NSUTF8StringEncoding];
                                           
                                           NSError* jsonError = nil;
                                           NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:dataInUTF8Format options:0 error:&jsonError];
                                           
                                           if(jsonError == nil)
                                               success(json);
                                           else
                                               failure(jsonError);
                                           
                                           
                                       }];
    
    [dataTask resume] ; // Executed at start and initiates task
    
}
@end
