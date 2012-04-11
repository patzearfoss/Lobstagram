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
#import "PhotoFiltersViewController.h"

@interface PhotoSettingsViewController ()
- (void)applyFilterToImage:(NSString *)filter;
@property (nonatomic, strong) UIImage *modifiedImage;
@end

@implementation PhotoSettingsViewController
@synthesize photoImageView;
@synthesize titleTextField;
@synthesize managedObjectContext;
@synthesize delegate;
@synthesize image;
@synthesize doneButton;
@synthesize modifiedImage;

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
    
    self.modifiedImage = self.image;
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
    
    NSData *jpg = UIImageJPEGRepresentation(self.modifiedImage, 1.0);
        
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

- (IBAction)filtersButtonTap:(id)sender 
{
    PhotoFiltersViewController *filtersViewController = [[PhotoFiltersViewController alloc] initWithNibName:@"PhotoFiltersViewController" bundle:nil];
    filtersViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    filtersViewController.delegate = self;
    
    [self presentModalViewController:filtersViewController animated:YES];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark PhotoFiltersViewController
- (void)photoFiltersView:(PhotoFiltersViewController *)controller didSelectFilter:(NSString *)filter
{
    [self dismissModalViewControllerAnimated:YES];
    [self applyFilterToImage:filter];
}

- (void)photoFiltersViewDidCancel:(PhotoFiltersViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark apply filter
- (void)applyFilterToImage:(NSString *)filter
{
    UIImageOrientation originalOrientation = self.image.imageOrientation;
    CGFloat originalScale = self.image.scale;
    
    CIContext *coreContext = [CIContext contextWithOptions:nil];
    CIImage *coreImage = [CIImage imageWithCGImage:self.image.CGImage];
    
    CIImage *outImage = nil;
    if ([filter isEqualToString:@"Invert"])
    {
        CIFilter *invert = [CIFilter filterWithName:@"CIColorInvert" keysAndValues:@"inputImage", coreImage, nil];
        outImage = [invert outputImage];
    }
    else if ([filter isEqualToString:@"Sepia"])
    {
        CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:@"inputImage", coreImage, @"inputIntensity",                           [NSNumber numberWithFloat:0.8], nil];
        outImage = [sepia outputImage];
    }
    else if ([filter isEqualToString:@"Redify"])
    {
        CIColor *red = [CIColor colorWithRed:0.9 green:0 blue:0];

        CIFilter *redify = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:@"inputImage", coreImage, @"inputIntensity",                           [NSNumber numberWithFloat:0.8], @"inputColor", red, nil];
        outImage = [redify outputImage];
    }
    else if ([filter isEqualToString:@"Gloomy"])
    {
        CIFilter *gamma = [CIFilter filterWithName:@"CIGammaAdjust" keysAndValues:@"inputImage", coreImage, @"inputPower", [NSNumber numberWithFloat:2.3], nil];
        outImage = [gamma outputImage];
    }
    else if ([filter isEqualToString:@"SuperColor"])
    {
        CIFilter *vibe = [CIFilter filterWithName:@"CIVibrance" keysAndValues:@"inputImage", coreImage, @"inputAmount", [NSNumber numberWithFloat:1.0], nil];
        outImage = [vibe outputImage];

    }
    
    CGImageRef cgimg = [coreContext createCGImage:outImage fromRect:[outImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg scale:originalScale orientation:originalOrientation];
    
    self.modifiedImage = newImg;
    self.photoImageView.image = self.modifiedImage;
    
    CGImageRelease(cgimg);
}

@end
