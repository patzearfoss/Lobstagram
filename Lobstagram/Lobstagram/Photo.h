//
//  Photo.h
//  Lobstagram
//
//  Created by Patrick Zearfoss on 4/5/12.
//  Copyright (c) 2012 Mindgrub Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSDate * filename;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) UNKNOWN_TYPE timestamp;

@end
