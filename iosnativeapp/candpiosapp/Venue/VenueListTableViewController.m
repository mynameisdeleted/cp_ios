//
//  VenuesTableViewController.m
//  candpiosapp
//
//  Created by Stephen Birarda on 4/2/12.
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import "VenueListTableViewController.h"
#import "VenueCell.h"
#import "VenueInfoViewController.h"
#import "MapTabController.h"
#import "MapDataSet.h"

@interface VenueListTableViewController ()

@end

@implementation VenueListTableViewController

@synthesize venues = _venues;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)venues
{
    // lazily instantiate the array of venues
    if (!_venues) {
        _venues = [NSMutableArray array];
    }
    return _venues;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // our delegate is the map tab controller
    self.delegate = [[CPAppDelegate settingsMenuController] mapTabController];
    
    // Add a notification catcher for refreshTableViewWithNewMapData to refresh the view
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(newDataBeingLoaded:) 
                                                 name:@"mapIsLoadingNewData" 
                                               object:nil]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refreshFromNewMapData:) 
                                                 name:@"refreshVenuesFromNewMapData"
                                               object:nil]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mapIsLoadingNewData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshVenuesFromNewMapData" object:nil];
     
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // place the settings button on the navigation item if required
    // or remove it if the user isn't logged in
    [CPUIHelper settingsButtonForNavigationItem:self.navigationItem];
    
    // reload the table
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    // tell the map to reload data
    // we'll get a notification when that's done to reload ours
    [self.delegate refreshButtonClicked:nil];   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)newDataBeingLoaded:(NSNotification *)notification
{
    // check if we're visible
    if (self.isViewLoaded && self.view.window) {
        // and show an SVProgressHUD if we are
        [SVProgressHUD showWithStatus:@"Loading..."];
    }
}

- (void)refreshFromNewMapData:(NSNotification *)notification {
    
    // get the venues from the notification
    self.venues = notification.object;

    if (self.isViewLoaded && self.view.window) {
        // we're visible
        // dismiss the SVProgressHUD and reload our data
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }
   
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *venueCellIdentifier = @"VenueListCustomCell";
    
    VenueCell *vcell = [tableView dequeueReusableCellWithIdentifier:venueCellIdentifier];
    
    if (vcell == nil) {
        vcell = [[VenueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:venueCellIdentifier];
    }
    
    CPVenue *venue = [[self venues] objectAtIndex:indexPath.row];
    
    vcell.venueName.text = venue.name;
    vcell.venueAddress.text = venue.address;
    
    vcell.venueDistance.text = [NSString stringWithFormat:@"%@ %@", [CPUtils localizedDistanceStringFromMiles:venue.distanceFromUser], @"away"];
    
    vcell.venueCheckins.text = @"";
    if (venue.checkinCount  > 0) {
        if (venue.checkinCount == 1) {
            vcell.venueCheckins.text = @"1 person here now";
        } else {
            vcell.venueCheckins.text = [NSString stringWithFormat:@"%d people here now", venue.checkinCount];
        }
    } else {
        if (venue.weeklyCheckinCount > 0) {
            
            vcell.venueCheckins.text = [NSString stringWithFormat:venue.weeklyCheckinCount == 1 ? @"%d person this week" : @"%d people this week", venue.weeklyCheckinCount];
        } else {
            if (venue.intervalCheckinCount > 0) {
                vcell.venueCheckins.text = [NSString stringWithFormat:venue.intervalCheckinCount == 1 ? @"%d person all time" : @"%d people all time", venue.intervalCheckinCount];
            } else {
                vcell.venueCheckins.text = @"";
            }                
        }
        
    }
    
    if (![venue.photoURL isKindOfClass:[NSNull class]]) {
        [vcell.venuePicture setImageWithURL:[NSURL URLWithString:venue.photoURL]
                           placeholderImage:[UIImage imageNamed:@"picture-coming-soon.jpg"]];
    } else {
        vcell.venuePicture.image = [UIImage imageNamed:@"picture-coming-soon.jpg"];
    }
    
    return vcell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

# pragma mark - Table View Delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // give place info to the CheckInDetailsViewController
    CPVenue *place = [[self venues] objectAtIndex:indexPath.row];
    
    VenueInfoViewController *venueVC = [[UIStoryboard storyboardWithName:@"VenueStoryboard_iPhone" bundle:nil] instantiateInitialViewController];
    venueVC.venue = place;
    
    // push the VenueInfoViewController onto the screen
    [self.navigationController pushViewController:venueVC animated:YES];
}

@end
