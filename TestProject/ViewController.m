//
//  ViewController.m
//  TestProject
//
//  Created by kumaran V on 23/01/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+AFNetworking.h"

#define NUMBER_OF_ROWS 1

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshFacts)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    self.factsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.factsTableView.dataSource = self;
    self.factsTableView.delegate = self;
   
    self.factsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.factsTableView];
   
    [self addTableViewConstraints];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(receiveTestNotification:) name:@"factsReceivedNotification" object:nil];
    [self refreshFacts];
    
}

-(void)addTableViewConstraints
{
    
    /* Leading constaint  */
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.factsTableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    /* Trailing constraint  */
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.factsTableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    /* Top constraint */
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.factsTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    /* Bottom constraint */
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.factsTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
}

-(void)refreshFacts
{
    self.apiService = nil;
    self.apiService = [[ServiceCommunicator alloc] init];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) receiveTestNotification:(NSNotification*)notification
{
    
    if ([notification.name isEqualToString:@"factsReceivedNotification"])
    {
        NSDictionary* userInfo = notification.userInfo;
        self.facts = (FactsModel*)userInfo[@"facts"];
        NSLog (@"Successfully received test notification! %@", self.facts);
        self.navigationItem.title = self.facts.factsTitle;
        [self.factsTableView reloadData];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self.factsTableView reloadData];
}
#pragma mark tableview delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.facts.rowsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *tableViewIdentifier = @"tableViewUniqueIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
    UILabel *label = nil;

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tableViewIdentifier];
    }
    NSDictionary *factRow = [self.facts.rowsArray objectAtIndex:indexPath.row];
    if([factRow objectForKey:@"title"] != [NSNull null])
        cell.textLabel.text = [factRow objectForKey:@"title"];
    else
        cell.textLabel.text = @"";
    if([factRow objectForKey:@"description"] != [NSNull null])
        cell.detailTextLabel.text = [factRow objectForKey:@"description"];
    else
        cell.detailTextLabel.text = @"";
    
    cell.detailTextLabel.numberOfLines = 0;

    //to fetch and display images for each row
    if([factRow objectForKey:@"imageHref"] != [NSNull null])
    { NSString *urlString = [factRow objectForKey:@"imageHref"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@""];
        
        __weak UITableViewCell *weakCell = cell;
        
        
        [cell.imageView setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           if(image){
                                               weakCell.imageView.image = image;
                                               [weakCell setNeedsLayout];
                                           }
                                           else
                                           {
                                               weakCell.imageView.image = nil;
                                               [weakCell setNeedsLayout];
                                           }
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           NSLog(@"fail for %@",request.URL);
                                           weakCell.imageView.image = nil;
                                           [weakCell setNeedsLayout];
                                       }];
    }
    else
    {
        cell.imageView.image = nil;
        [cell setNeedsLayout];
    }
    //display cell's image using asynchronous call while displaying this row
    [cell layoutIfNeeded];
    return cell;
}
    
    

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = @"";
    NSDictionary *factRow = [self.facts.rowsArray objectAtIndex:indexPath.row];
    if([factRow objectForKey:@"description"] != [NSNull null])
        text = [factRow objectForKey:@"description"];
    else
      text = @"";

    CGSize constraint = CGSizeMake(self.view.frame.size.width, 2000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    return height + 10;
}
@end
