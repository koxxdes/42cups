//
//  SecondViewController.m
//  KavProject
//
//  Created by Victor on 4/18/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "FriendsViewController.h"
#import "AppDelegate.h"
#import "FacebookModel.h"
#import "FriendTableViewCell.h"

@interface FriendsViewController ()

@property (weak, nonatomic) FacebookModel *networkModel;
@property (strong, nonatomic) NSArray *friends;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSOperationQueue *queue;


@end

@implementation FriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.networkModel = ((AppDelegate *)[UIApplication sharedApplication].delegate).networkModel;
    FriendsViewController *wSelf = self;
    self.queue = [[NSOperationQueue alloc] init];

    [self.networkModel getFriendsWithCompletionHandler:^(NSArray *friends) {
        if (friends) {
            wSelf.friends = friends;
            dispatch_async(dispatch_get_main_queue(), ^{
                [wSelf.tableView reloadData];
            });
        }
    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    
    FacebookFriend *friend = self.friends[indexPath.row];
    cell.name.text = friend.name;
    
    FacebookModel *model = self.networkModel;
    if (!friend.picture) {
        cell.picture.alpha = 0.0f;
        cell.picture.image = nil;
        [self.queue addOperationWithBlock:^{
            UIImage *thumbnailImage;
            
            NSData *imageData = [model getPictureForFriendId:friend.identifier];
            thumbnailImage = [UIImage imageWithData:imageData];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                friend.picture = thumbnailImage;
                cell.picture.image = thumbnailImage;
                [UIView animateWithDuration:0.3 animations:^{
                    cell.picture.alpha = 1.0f;
                }];
            }];
        }];
    }else{
        cell.picture.image = friend.picture;
    }
    
    
    return cell;
}

@end