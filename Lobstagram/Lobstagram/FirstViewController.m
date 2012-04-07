//
//  FirstViewController.m
//  Lobstagram
//
//  Created by Patrick Zearfoss on 4/5/12.
//  Copyright (c) 2012 Mindgrub Technologies. All rights reserved.
//

#import "FirstViewController.h"
#import "PhotoCell.h"
#import "Photo.h"
#import "PhotoSettingsViewController.h"
#import "AppDelegate.h"

@interface FirstViewController ()
- (void)reload;
@property (nonatomic, strong) NSArray *photos;
@end

@implementation FirstViewController
@synthesize photosTable;
@synthesize managedObjectContext;
@synthesize photos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
        self.photos = [NSArray array];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosTable.rowHeight = 366;
    [self reload];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setPhotosTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [photos count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    PhotoCell *cell = (PhotoCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    Photo *photo = [photos objectAtIndex:indexPath.row];
    
    cell.photoTitleLabel.text = photo.title;
    cell.photoImageView.image = [UIImage imageWithData:photo.photo];
    
    return cell;
}

- (IBAction)takePictureButtonTap:(id)sender 
{    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo Source" 
                                                                 delegate:self 
                                                        cancelButtonTitle:@"Cancel" 
                                                   destructiveButtonTitle:nil 
                                                        otherButtonTitles:@"Camera", @"Photo Library", nil];
        [actionSheet showInView:self.view];
    }
    else 
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePickerController.delegate = self;
        [self presentModalViewController:imagePickerController animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePickerController.delegate = self;
        [self presentModalViewController:imagePickerController animated:YES];
    }
    else 
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePickerController.delegate = self;
        [self presentModalViewController:imagePickerController animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:NO];
    PhotoSettingsViewController *photoSettings = [[PhotoSettingsViewController alloc] initWithNibName:@"PhotoSettingsViewController" bundle:nil];
    photoSettings.managedObjectContext = self.managedObjectContext;
    photoSettings.delegate = self;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    photoSettings.image = image;
    [self presentModalViewController:photoSettings animated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)photoSettingsViewController:(PhotoSettingsViewController *)controller didSaveNewPhoto:(Photo *)photo
{
    [self dismissModalViewControllerAnimated:YES];
    [self reload];
}

- (void)photoSettingsViewControllerDidCancel:(PhotoSettingsViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark ()
- (void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    self.photos = results;
    
    [self.photosTable reloadData];
}
@end
