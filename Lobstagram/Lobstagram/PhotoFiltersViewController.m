//
//  PhotoFiltersViewControllerViewController.m
//  Lobstagram
//
//  Created by Patrick Zearfoss on 4/10/12.
//  Copyright (c) 2012 Mindgrub Technologies. All rights reserved.
//

#import "PhotoFiltersViewController.h"

@interface PhotoFiltersViewController ()
@property (nonatomic, strong) NSArray *filterNames;
@end

@implementation PhotoFiltersViewController
@synthesize filtersTable;
@synthesize delegate;
@synthesize filterNames;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.filterNames = [NSArray arrayWithObjects:@"Invert", @"Sepia", @"Redify", @"Gloomy", @"SuperColor", nil];
}

- (void)viewDidUnload
{
    [self setFiltersTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelButtonTap:(id)sender 
{
    [self.delegate photoFiltersViewDidCancel:self];
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filterNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = [self.filterNames objectAtIndex:indexPath.row];
    
    return cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate photoFiltersView:self didSelectFilter:[self.filterNames objectAtIndex:indexPath.row]];
}
@end
