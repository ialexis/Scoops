//
//  IAAOneNew.h
//  Practica Scoops
//
//  Created by Ivan on 27/04/15.
//  Copyright (c) 2015 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import CoreLocation;

@interface IAAOneNew : NSObject

- (id)initWithTitle:(NSString*)title
              andID: (NSString *) ID
           andPhoto:(NSData *)img
              aText:(NSString*)text
          andAuthor:(NSString *)author
            andLatitude:(NSNumber *) latitude
       andLongitude:(NSNumber *) longitude
          andStatus:(NSNumber *) status
    andCreationDate:(NSDate *) creationDate
andModificationDate:(NSDate *) modifDate;


- (id)initWithTitle:(NSString*)title
              aText:(NSString*)text
        andLatitude:(NSNumber*)latitude
       andLongitude:(NSNumber*)longitude;

@property (readonly) NSString *id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSNumber *status;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSData *image;
@property (readonly) NSDate *dateCreated;
@property (readonly) NSDate *dateModif;
@property (nonatomic, strong, readonly) UIImage *imagenNoticia;


@end
