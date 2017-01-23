//
//  FactsModel.m
//  TestProject
//
//  Created by kumaran V on 23/01/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

#import "FactsModel.h"

@implementation FactsModel
- (instancetype)initWithJson:(id )jsonObj
{
    self = [super init];
    if (self) {
        self.factsTitle = jsonObj[@"title"];
        self.rowsArray = jsonObj[@"rows"];
        NSLog(@"rowsarray %@", _rowsArray);
        [self validateRows];
        [self postNotification];
    }
    return self;
}

/**
 This method validates the json results and remove NULL items inside rows array
 */
-(void)validateRows
{
    NSMutableArray *nullValuePrunedArray = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dictionary in self.rowsArray){
        NSMutableDictionary *nullValuePrunedDictionary = [NSMutableDictionary dictionary];
        
        for (NSString * key in [dictionary allKeys])
        {
            if (![[dictionary objectForKey:key] isKindOfClass:[NSNull class]])
                [nullValuePrunedDictionary setObject:[dictionary objectForKey:key] forKey:key];
            else
                [nullValuePrunedDictionary setObject:@"No Data Available" forKey:key];
        }
        [nullValuePrunedArray addObject:nullValuePrunedDictionary];
    }
    self.rowsArray = nil;
    self.rowsArray = (NSArray *)nullValuePrunedArray;
}
-(void)postNotification
{
    NSDictionary* userInfo = @{@"facts": self};
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:@"factsReceivedNotification" object:self userInfo:userInfo];
}
@end
