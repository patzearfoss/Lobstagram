//
//  SecondViewController.h
//  Lobstagram
//
//  Created by Patrick Zearfoss on 4/5/12.
//  Copyright (c) 2012 Mindgrub Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoFiltersViewController.h"

@class Photo;
@protocol PhotoSettingsViewControllerDelegate;

@interface PhotoSettingsViewController : UIViewController <UITextFieldDelegate, PhotoFiltersViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) id<PhotoSettingsViewControllerDelegate> delegate; 
@property (strong, nonatomic) UIImage *image;

- (IBAction)doneButtonTap:(id)sender;
- (IBAction)filtersButtonTap:(id)sender;

@end

@protocol PhotoSettingsViewControllerDelegate <NSObject>
@required
- (void)photoSettingsViewControllerDidCancel:(PhotoSettingsViewController *)controller;
- (void)photoSettingsViewController:(PhotoSettingsViewController *)controller didSaveNewPhoto:(Photo *)photo;

@end
