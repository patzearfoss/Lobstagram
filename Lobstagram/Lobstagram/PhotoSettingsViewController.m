//
//  SecondViewController.m
//  Lobstagram
//
//  Created by Patrick Zearfoss on 4/5/12.
//  Copyright (c) 2012 Mindgrub Technologies. All rights reserved.
//

#import "PhotoSettingsViewController.h"
#import "AppDelegate.h"
#import "Photo.h"

@interface PhotoSettingsViewController ()

@end

@implementation PhotoSettingsViewController
@synthesize photoImageView;
@synthesize titleTextField;
@synthesize managedObjectContext;
@synthesize delegate;
@synthesize image;
@synthesize doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoImageView.image = self.image;
    
    UIImage *doneBg = [UIImage imageNamed:@"redButton.png"];
    UIImage *stretch = [doneBg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
    [self.doneButton setBackgroundImage:stretch forState:UIControlStateNormal];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setPhotoImageView:nil];
    [self setTitleTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)doneButtonTap:(id)sender 
{
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:self.managedObjectContext];
    
    photo.title = titleTextField.text;
    photo.timestamp = [NSDate date];
    
    NSData *jpg = UIImageJPEGRepresentation(self.image, 1.0);
        
    photo.photo = jpg;
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message:@"The photo could not be saved" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [delegate photoSettingsViewController:self didSaveNewPhoto:photo];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
