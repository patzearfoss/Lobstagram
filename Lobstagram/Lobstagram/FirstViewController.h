//
//  FirstViewController.h
//  Lobstagram
//
//  Created by Patrick Zearfoss on 4/5/12.
//  Copyright (c) 2012 Mindgrub Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoSettingsViewController.h"

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, PhotoSettingsViewControllerDelegate, UINavigationControllerDelegate>
{
    NSArray *photos;
    NSArray *imageCache;
}

@property (weak, nonatomic) IBOutlet UITableView *photosTable;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)takePictureButtonTap:(id)sender;


@end
