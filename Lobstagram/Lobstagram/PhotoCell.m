//
//  PhotoCell.m
//  Lobstagram
//
//  Created by Patrick Zearfoss on 4/5/12.
//  Copyright (c) 2012 Mindgrub Technologies. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

@synthesize photoTitleLabel, photoImageView;
@synthesize tweetButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    UIImage *tweetBg = [UIImage imageNamed:@"redButton.png"];
    UIImage *stretch = [tweetBg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
    [self.tweetButton setBackgroundImage:stretch forState:UIControlStateNormal];

}



@end
