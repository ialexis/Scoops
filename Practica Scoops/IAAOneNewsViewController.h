//
//  IAAOneNewsViewController.h
//  Practica Scoops
//
//  Created by Ivan on 29/04/15.
//  Copyright (c) 2015 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@class IAAOneNew;

@interface IAAOneNewsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imagenNoticia;
@property (weak, nonatomic) IBOutlet UIImageView *imagenAutor;
@property (weak, nonatomic) IBOutlet UILabel *labelNombreAutor;
@property (weak, nonatomic) IBOutlet UILabel *labelFechaCreacion;
@property (weak, nonatomic) IBOutlet UILabel *labelFechaModificacion;
@property (weak, nonatomic) IBOutlet UITextField *tituloNoticia;
@property (weak, nonatomic) IBOutlet UITextView *textoNoticia;
@property (weak, nonatomic) IBOutlet UISwitch *switchPublicada;
@property (weak, nonatomic) IBOutlet UILabel *labelCoordenadas;
@property (weak, nonatomic) IBOutlet UILabel *labelPuntuacion;

@property (weak, nonatomic) IBOutlet UISlider *sliderRating;
@property (nonatomic,strong) IAAOneNew *model;
@property (strong,nonatomic)   MSClient * client;
-(id) initWithModel: (IAAOneNew *) model andClient: (MSClient *) client;
- (IBAction)changeRating:(id)sender;

@end
