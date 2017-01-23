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

- (void)fetchFacts:(NSString*)url completeBlock:(void(^)(FactsModel *)) completeBlock
{
    NSError *error;
    NSString *urlString = [NSString stringWithContentsOfURL:[NSURL URLWithString: url] encoding:NSISOLatin1StringEncoding error:&error];
    
    NSData *requestData = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:requestData options:kNilOptions error:&error];
    
    if (error) {
        //Error handling
    } else {
        self.factsModel = [[FactsModel alloc] init];
       self.factsModel = [[FactsModel alloc] initWithJson:jsonObj];
        completeBlock(self.factsModel);
    }
}
    
@end
