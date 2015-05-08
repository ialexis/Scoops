//
//  IAAOneNew.m
//  Practica Scoops
//
//  Created by Ivan on 27/04/15.
//  Copyright (c) 2015 Ivan. All rights reserved.
//

#import "IAAOneNew.h"


@implementation IAAOneNew

- (id)initWithTitle:(NSString*)title
              andID: (NSString *) ID
           andPhoto:(NSData *)img
              aText:(NSString*)text
          andAuthor:(NSString *)author
            andCoor:(CLLocationCoordinate2D) coors
          andStatus:(NSNumber *) status
    andCreationDate:(NSDate *) creationDate
andModificationDate:(NSDate *) modifDate
{ 
    if (self = [super init]) {
        _id = ID;
        _title = title;
        _text = text;
        _author = author;
        _coors = coors;
        _status=status;
        _image = img;
        _dateCreated = creationDate;
        _dateModif = modifDate;
    }
    
    return self;
    
}


-(UIImage *)imagenNoticia{
    
    
    if (self.image==nil)
    {
        
        
        // Load url image into NSData
        return [UIImage imageNamed:@"noimages.png"];
    }
    
   
    return [UIImage imageWithData:self.image];
}



#pragma mark - Overwritten

-(NSString*) description{
    return [NSString stringWithFormat:@"<%@ %@>", [self class], self.title];
}


- (BOOL)isEqual:(id)object{
    
    
    return [self.title isEqualToString:[object title]];
}

- (NSUInteger)hash{
    return [_title hash] ^ [_text hash];
}


@end
