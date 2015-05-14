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

@interface IAANews ()
{
    MSClient * client;
    MSTable *table;
    NSString *userFBId;
    NSString *tokenFB;
}

@end

@implementation IAANews



- (id) init
{
    
    if (self = [super init])
    {
       // [self loadNewsFromAzure];
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
    
    userFBId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];

    
     client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
                                             applicationKey:AZUREMOBILESERVICE_APPKEY];
    
    table = [client tableWithName:@"news"];
    

    self.modelWrited = [[NSMutableArray alloc]init];
    self.modelReviewed = [[NSMutableArray alloc]init];
    self.modelPublished = [[NSMutableArray alloc]init];
    
    
    /*
    
    MSQuery *queryModel = [[MSQuery alloc]initWithTable:table];

   // MSQuery *queryModel = [table query];
    
    
    //queryModel.selectFields = @[@"id", @"__createdAt",@"__updatedAt" ,@"Titulo", @"noticia", @"Imagen", @"author"];

    queryModel.selectFields = @[@"id",@"Titulo", @"noticia",@"author",@"status" ,@"__createdAt",@"__updatedAt"];

    [queryModel readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
    

        
        
        for (id item in items) {
            NSLog(@"item -> %@", item);
           // IAAOneNew *noticia = [[IAAOneNew alloc]initWithTitle:item[@"Titulo"] andID:item[@"id"] andPhoto:item[@"Imagen"] aText:item[@"noticia"] anAuthor:@"nil" aCoor:
           //                       CLLocationCoordinate2DMake(0, 0)];
            
            
            IAAOneNew *noticia = [[IAAOneNew alloc]initWithTitle:item[@"Titulo"] andID:item[@"id"] andPhoto:nil  aText:item[@"noticia"] andAuthor:item[@"author"] andCoor: CLLocationCoordinate2DMake(0, 0) andStatus:item[@"status"] andCreationDate:item[@"__createdAt"]  andModificationDate:item[@"__updatedAt"] ];
            
            
            NSNumber* status = item[@"status"];
            
            if (status == [NSNull null])
            {
                status=@0;
            }
            
          //  if ([status isEqualToString:@"<null>"])
          //  {
          //      [self.modelWrited addObject:noticia];
          //  }
            if ([status  isEqual:@0])
            {
                [self.modelWrited addObject:noticia];
            }

            if ([status  isEqual:@1])
            {
                [self.modelReviewed addObject:noticia];
            }
            if ([status  isEqual:@2])
            {
                [self.modelPublished addObject:noticia];
            }
            
         //   [self.modelWrited addObject:noticia];

            
        }
        */
    
    [self recoverPublishedNews];
    [self recoverReviewedNews];
    [self recoverWritenNews];
    
        // Enviamos una notificación
        NSNotification *notification =
        [NSNotification notificationWithName: DID_NEW_NEWS_NOTIFICATION_NAME
                                      object:self
                                    userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        

 //   }];
    
    
}

-(void) recoverPublishedNews
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status = 2"];
    
    MSQuery *queryModel = [[MSQuery alloc]initWithTable:table predicate:predicate];
    
    
        queryModel.selectFields = @[@"id",@"Titulo", @"noticia",@"author",@"status" ,@"__createdAt",@"__updatedAt",@"latitude",@"longitude",@"rating"];
    
    [queryModel readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error)
     {
         for (id item in items)
         {
             NSLog(@"item -> %@", item);
             
             
             IAAOneNew *noticia = [[IAAOneNew alloc]initWithTitle:item[@"Titulo"] andID:item[@"id"] andPhoto:nil  aText:item[@"noticia"] andAuthor:item[@"author"] andLatitude:item[@"latitude"] andLongitude:item[@"longitude"] andStatus:item[@"status"] andCreationDate:item[@"__createdAt"]  andModificationDate:item[@"__updatedAt"] andRating:item[@"rating"] ];
             
             
             
             
             
             [self.modelPublished addObject:noticia];
             
         }
         // Enviamos una notificación
         NSNotification *notification =
         [NSNotification notificationWithName: DID_NEW_NEWS_NOTIFICATION_NAME
                                       object:self
                                     userInfo:nil];
         
         [[NSNotificationCenter defaultCenter] postNotification:notification];
         
         

         
     }];
}

-(void)recoverReviewedNews
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author == %@ && status = 1", userFBId];

    MSQuery *queryModel = [[MSQuery alloc]initWithTable:table predicate:predicate];
    
    
    queryModel.selectFields = @[@"id",@"Titulo", @"noticia",@"author",@"status" ,@"__createdAt",@"__updatedAt",@"latitude",@"longitude"];
    
    [queryModel readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error)
    {
        for (id item in items)
        {
            NSLog(@"item -> %@", item);
            
            
            
            
            IAAOneNew *noticia = [[IAAOneNew alloc]initWithTitle:item[@"Titulo"] andID:item[@"id"] andPhoto:nil  aText:item[@"noticia"] andAuthor:item[@"author"] andLatitude:item[@"latitude"] andLongitude:item[@"longitude"] andStatus:item[@"status"] andCreationDate:item[@"__createdAt"]  andModificationDate:item[@"__updatedAt"]andRating:item[@"rating"]];
            
            
            [self.modelReviewed addObject:noticia];
            
        }
        // Enviamos una notificación
        NSNotification *notification =
        [NSNotification notificationWithName: DID_NEW_NEWS_NOTIFICATION_NAME
                                      object:self
                                    userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        


    }];
}

     
-(void)recoverWritenNews
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author == %@ && status = 0", userFBId];
    
    MSQuery *queryModel = [[MSQuery alloc]initWithTable:table predicate:predicate];
    
    
    queryModel.selectFields = @[@"id",@"Titulo", @"noticia",@"author",@"status" ,@"__createdAt",@"__updatedAt",@"latitude",@"longitude"];
    
    [queryModel readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error)
     {
         for (id item in items)
         {
             NSLog(@"item -> %@", item);
             
             

             
             IAAOneNew *noticia = [[IAAOneNew alloc]initWithTitle:item[@"Titulo"] andID:item[@"id"] andPhoto:nil  aText:item[@"noticia"] andAuthor:item[@"author"] andLatitude:item[@"latitude"] andLongitude:item[@"longitude"] andStatus:item[@"status"] andCreationDate:item[@"__createdAt"]  andModificationDate:item[@"__updatedAt"]andRating:item[@"rating"]];
             
             
             [self.modelWrited addObject:noticia];
             
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
