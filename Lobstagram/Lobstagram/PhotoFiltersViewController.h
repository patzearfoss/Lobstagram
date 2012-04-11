//
//  PhotoFiltersViewControllerViewController.h
//  Lobstagram
//
//  Created by Patrick Zearfoss on 4/10/12.
//  Copyright (c) 2012 Mindgrub Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoFiltersViewControllerDelegate;

@interface PhotoFiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *filtersTable;
@property (weak, nonatomic) id<PhotoFiltersViewControllerDelegate> delegate;
- (IBAction)cancelButtonTap:(id)sender;

@end

@protocol PhotoFiltersViewControllerDelegate <NSObject>

- (void)photoFiltersView:(PhotoFiltersViewController *)controller didSelectFilter:(NSString *)filter;
- (void)photoFiltersViewDidCancel:(PhotoFiltersViewController *)controller;

@end
