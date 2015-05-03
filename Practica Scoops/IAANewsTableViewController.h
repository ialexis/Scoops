//
//  IAANewsTableViewController.h
//  Practica Scoops
//
//  Created by Ivan on 28/04/15.
//  Copyright (c) 2015 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IAANews;


typedef void (^profileCompletion)(NSDictionary* profInfo);
typedef void (^completeBlock)(NSArray* results);
typedef void (^completeOnError)(NSError *error);
typedef void (^completionWithURL)(NSURL *theUrl, NSError *error);



@interface IAANewsTableViewController : UITableViewController

@property (strong,nonatomic) IAANews *model;
@property (strong, nonatomic) NSURL *profilePicture;

-(id) initWithModel: (IAANews *) model style:(UITableViewStyle)style;
@end
