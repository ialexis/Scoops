//
//  IAANews.h
//  Practica Scoops
//
//  Created by Ivan on 27/04/15.
//  Copyright (c) 2015 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAAOneNew.h"

@interface IAANews : NSObject
@property (strong,nonatomic)   NSMutableArray *modelPublished;
@property (strong,nonatomic)   NSMutableArray *modelReviewed;
@property (strong,nonatomic)   NSMutableArray *modelWrited;


/* Total number of news */
@property (nonatomic, readonly) NSUInteger newsPublishedCount;
@property (nonatomic, readonly) NSUInteger newsReviewedCount;
@property (nonatomic, readonly) NSUInteger newsWritedCount;


- (IAAOneNew *) newsPublishedAtIndex: (NSUInteger) index;
- (IAAOneNew *) newsReviwedAtIndex: (NSUInteger) index;
- (IAAOneNew *) newsWritedAtIndex: (NSUInteger) index;

- (void)loadNewsFromAzure;
@end
