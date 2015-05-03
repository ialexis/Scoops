//
//  IAAPhotoViewController.h
//  HackerBooks
//
//  Created by Ivan on 26/04/15.
//  Copyright (c) 2015 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IAAPhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

- (IBAction)takePhoto:(id)sender;
- (IBAction)deletePhoto:(id)sender;


@property(nonatomic, strong) UIImage *photo;

-(id) initWithImage:(UIImage*) imagen;


@end
