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
        [self postNotification];
    }
    return self;
}
-(void)postNotification
{
    NSDictionary* userInfo = @{@"facts": self};
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:@"factsReceivedNotification" object:self userInfo:userInfo];
}
@end
