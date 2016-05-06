//
//  CustomListTableViewCell.m
//  ProficiencyExercise
//
//  Created by  Pankaj Nilangekar on 5/3/16.
//  Copyright © 2016  Pankaj Nilangekar. All rights reserved.
//

#import "CustomListTableViewCell.h"

@interface CustomListTableViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation CustomListTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.titleLabel = [self getCustomLabel];
        [self.contentView addSubview:self.titleLabel];
        
        
        self.descriptionLabel = [self getCustomLabel];
        [self.contentView addSubview:self.descriptionLabel];
        
        self.listImageView = [[UIImageView alloc] init];
        self.listImageView.image = [UIImage imageNamed:@"placeholder"];
        [self.listImageView sizeToFit];
        [self.contentView addSubview:self.listImageView];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[image(40)]-(10)-[label]-(5)-|" options:0 metrics:nil views:@{@"label":self.titleLabel, @"image":self.listImageView }]];  // horizontal constraint
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[image(40)]-(10)-[label2]-(5)-|" options:0 metrics:nil views:@{@"label2":self.descriptionLabel, @"image":self.listImageView }]];  // horizontal constraint

        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[image]-|" options:0 metrics:nil views:@{ @"image":self.listImageView }]];  // horizontal constraint
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[label]-5-[label2]-(5)-|" options:0 metrics:nil views:@{ @"label":self.titleLabel,@"label2":self.descriptionLabel }]];  // horizontal constraint
    }
    
    return self;
}

/*
 * getCustomLabel method returns instance of uilabel
 */

-(UILabel *)getCustomLabel
{
    UILabel *customLabel = [[UILabel alloc] init];
    [customLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [customLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [customLabel setNumberOfLines:0];
    [customLabel setTextAlignment:NSTextAlignmentLeft];
    [customLabel setTextColor:[UIColor blackColor]];
    [customLabel setBackgroundColor:[UIColor clearColor]];
    return customLabel;
}


/*
 * Setting Frmaes of the subviews
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    //self.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.descriptionLabel.frame);
    
}



@end
