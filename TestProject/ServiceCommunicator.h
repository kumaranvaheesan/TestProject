//
//  ServiceCommunicator.h
//  TestProject
//
//  Created by kumaran V on 23/01/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactsModel.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface ServiceCommunicator : NSObject
@property (strong,nonatomic) FactsModel *factsModel;

@end
