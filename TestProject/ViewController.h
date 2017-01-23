//
//  ViewController.h
//  TestProject
//
//  Created by kumaran V on 23/01/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FactsModel.h"
#import "ServiceCommunicator.h"
@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
@property (strong, nonatomic) IBOutlet UITableView *factsTableView;
@property (strong, nonatomic) NSMutableArray  *tableDataSourceArray;
@property (strong, nonatomic) NSString  *titleString;
@property (strong, nonatomic) ServiceCommunicator  *apiService;
@property (strong, nonatomic) FactsModel  *facts;



@end

