//
//  AttachmentTableViewCell.h
//  EmailAttachment
//
//  Created by Simon on 7/7/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *fileLabel;

@end
