//
//  IAANews.m
//  Practica Scoops
//
//  Created by Ivan on 27/04/15.
//  Copyright (c) 2015 Ivan. All rights reserved.
//

#import "IAANews.h"

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "IAAOneNew.h"
#import "IAASettings.h"

@implementation IAANews



- (id) init
{
    
    if (self = [super init])
    {
        [self loadNewsFromAzure];
    }
    return self;
}


-(NSUInteger) newsPublishedCount
{
    return [self.modelPublished count];
}
- (NSUInteger) newsReviewedCount
{
    return [self.modelReviewed count];
}
- (NSUInteger) newsWritedCount
{
    return [self.modelWrited count];
}

- (void)loadNewsFromAzure{
    
    MSClient *  client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
                                             applicationKey:AZUREMOBILESERVICE_APPKEY];
    
    MSTable *table = [client tableWithName:@"news"];
    

    self.modelWrited = [[NSMutableArray alloc]init];
    self.modelReviewed = [[NSMutableArray alloc]init];
    self.modelPublished = [[NSMutableArray alloc]init];
    
    MSQuery *queryModel = [[MSQuery alloc]initWithTable:table];
    [queryModel readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
    

        
        
        for (id item in items) {
            NSLog(@"item -> %@", item);
            IAAOneNew *noticia = [[IAAOneNew alloc]initWithTitle:item[@"Titulo"] andID:item[@"id"] andPhoto:item[@"Imagen"] aText:item[@"noticia"] anAuthor:@"nil" aCoor:CLLocationCoordinate2DMake(0, 0)];
            
            
            
            NSString* status = item[@"status"];
            
            if (status == [NSNull null])
            {
                status=@"<null>";
            }
            
            if ([status isEqualToString:@"<null>"])
            {
                [self.modelWrited addObject:noticia];
            }
            if ([status isEqualToString:@"0"])
            {
                [self.modelWrited addObject:noticia];
            }

            if ([status isEqualToString:@"1"])
            {
                [self.modelReviewed addObject:noticia];
            }
            if ([status isEqualToString:@"2"])
            {
                [self.modelPublished addObject:noticia];
            }
            
         //   [self.modelWrited addObject:noticia];

            
        }
        
        // Enviamos una notificación
        NSNotification *notification =
        [NSNotification notificationWithName: DID_NEW_NEWS_NOTIFICATION_NAME
                                      object:self
                                    userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        

    }];
    
    
}
#pragma mark - Accessors
- (IAAOneNew *) newsPublishedAtIndex: (NSUInteger) index
{
    return [self.modelPublished objectAtIndex:index];
}


- (IAAOneNew *) newsReviwedAtIndex: (NSUInteger) index

{
    return [self.modelReviewed objectAtIndex:index];
}
- (IAAOneNew *) newsWritedAtIndex: (NSUInteger) index

{
    return [self.modelWrited objectAtIndex:index];
}




@end
