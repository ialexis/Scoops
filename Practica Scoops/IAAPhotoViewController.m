//
//  IAAPhotoViewController.m
//  HackerBooks
//
//  Created by Ivan on 26/04/15.
//  Copyright (c) 2015 Ivan. All rights reserved.
//

#import "IAAPhotoViewController.h"


@interface IAAPhotoViewController ()

@end

@implementation IAAPhotoViewController

#pragma mark - Init
-(id) initWithModel:(IAAOneNew*) model
{
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _model = model;
    }
    
    return self;
}

#pragma mark - View Life cycle
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Me aseguro que la vista no ocupa toda la
    // pantalla, sino lo que queda disponible
    // dentro del navigation
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    // sincronizo modelo -> vista
    self.photoImage.image = [self.model imagenNoticia];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    self.model.image = UIImageJPEGRepresentation(self.photoImage.image,9);
}



#pragma mark - Actions
- (IBAction)takePhoto:(id)sender {
    
    // Creamos un UIImagePickerController
    UIImagePickerController *picker = [UIImagePickerController new];
    
    // Lo configuro
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // Uso la cámara
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else{
        // Tiro del carrete
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    picker.delegate = self;
    
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Lo muestro de forma modal
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                         // Esto se va a ejecutar cuando termine la
                         // animación que muestra al picker.
                     }];
    
    
    
}

- (IBAction)deletePhoto:(id)sender {
    
    // la eliminamos del modelo
    
   // self.photo.image = nil;
    
    // sincronizo modelo -> vista
    CGRect oldRect = self.photoImage.bounds;
    [UIView animateWithDuration:0.7
                     animations:^{
                         
                         self.photoImage.alpha = 0;
                         self.photoImage.bounds = CGRectZero;
                         self.photoImage.transform = CGAffineTransformMakeRotation(M_PI_2);
                         
                     } completion:^(BOOL finished) {
                         
                         self.photoImage.alpha = 1;
                         self.photoImage.bounds = oldRect;
                         self.photoImage.transform = CGAffineTransformIdentity;
                         self.photoImage.image = nil;
                     }];
    
    
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // ¡OJO! Pico de memoria asegurado, especialmente en
    // dispositivos antiguos
    
    
    // Sacamos la UIImage del diccionario
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    // La guardo en el modelo
    self.photoImage.image=img;
    self.model.image = UIImageJPEGRepresentation(img, 9);
    
    //pongo a nil la imagen para liberar memoria
    img = nil;
    
    // Quito de encima el controlador que estamos presentando
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 // Se ejecutará cuando se haya ocultado del todo
                             }];
}
@end





