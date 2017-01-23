//
//  ServiceCommunicator.m
//  TestProject
//
//  Created by kumaran V on 23/01/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

#import "ServiceCommunicator.h"
#define FACTSURL @"https://dl.dropboxusercontent.com/u/746330/facts.json"

@implementation ServiceCommunicator

-(id)init {
    
    if ( self = [super init] ) {
        
        [self fetchFacts: FACTSURL completeBlock:^(FactsModel * data){
            NSLog(@"json fetch completed");
        }];
    }
    return self;
}

- (void)fetchFacts:(NSString*)urlString completeBlock:(void(^)(FactsModel *)) completeBlock
{
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedUrlAsString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:[NSURL URLWithString:encodedUrlAsString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                NSString* string= [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];//  encoding is needed to fix error in parsing json from this webservice
                
                NSData* encodedData=[string dataUsingEncoding:NSUTF8StringEncoding];
                
                if (!error) {
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:encodedData options:0 error:&jsonError];
                        
                        if (jsonError) {
                            // Error Parsing JSON
                            NSLog(@"eror parsing  %@ ", jsonError.description);
                        } else {
                            // Success Parsing JSON
                            NSLog(@"json - %@",jsonResponse);
                            self.factsModel = [[FactsModel alloc] init];
                            self.factsModel = [[FactsModel alloc] initWithJson:jsonResponse];
                            completeBlock(self.factsModel);
                        }
                    }
                } else {
                    // Fail
                    NSLog(@"error : %@", error.description);
                }
            }] resume];
}
@end
