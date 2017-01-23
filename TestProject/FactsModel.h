//
//  FactsModel.h
//  TestProject
//
//  Created by kumaran V on 23/01/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FactsModel : NSObject
@property (strong,nonatomic) NSString *factsTitle;
@property (strong,nonatomic) NSArray *rowsArray;
- (instancetype)initWithJson:(id )jsonObj;
@end
