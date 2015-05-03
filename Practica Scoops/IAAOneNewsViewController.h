//
//  IAAOneNewsViewController.h
//  Practica Scoops
//
//  Created by Ivan on 29/04/15.
//  Copyright (c) 2015 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IAAOneNew;

@interface IAAOneNewsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imagenNoticia;
@property (weak, nonatomic) IBOutlet UIImageView *imagenAutor;
@property (weak, nonatomic) IBOutlet UILabel *labelNombreAutor;
@property (weak, nonatomic) IBOutlet UILabel *labelFechaCreacion;
@property (weak, nonatomic) IBOutlet UILabel *labelFechaModificacion;
@property (weak, nonatomic) IBOutlet UITextField *tituloNoticia;
@property (weak, nonatomic) IBOutlet UITextView *textoNoticia;

@property (nonatomic,strong) IAAOneNew *model;

-(id) initWithModel: (IAAOneNew *) model;

@end
