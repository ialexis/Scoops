//
//  IAAOneNewsViewController.m
//  Practica Scoops
//
//  Created by Ivan on 29/04/15.
//  Copyright (c) 2015 Ivan. All rights reserved.
//

#import "IAAOneNewsViewController.h"
#import "IAAPhotoViewController.h"
#import "IAAOneNew.h"
#import "IAASettings.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface IAAOneNewsViewController ()
{
    MSClient * client;
    NSString *userFBId;
    NSString *tokenFB;
}

@end

@implementation IAAOneNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated
{
    self.tituloNoticia.text = self.model.title;
    self.textoNoticia.text=self.model.text;
    self.imagenNoticia.image = self.model.imagenNoticia;
    [self changeToNoEditMode];
    
    
   
}

-(id) initWithModel: ( IAAOneNew*) model
{
    if (self=[super initWithNibName:nil bundle:nil])
    {
        _model = model;
        
        
        
        
        self.title = [model title];
    }
    return self;
}

#pragma mark - edit mode and no edit mode
-(void) changeToEditMode
{
    
    userFBId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    tokenFB = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
    
    if (userFBId) {
        self.tituloNoticia.userInteractionEnabled=true;
        self.textoNoticia.userInteractionEnabled=true;
        self.imagenNoticia.userInteractionEnabled=true;
    }
    
    [self addSaveButton];
}
-(void) changeToNoEditMode
{
    self.tituloNoticia.userInteractionEnabled=false;
    self.textoNoticia.userInteractionEnabled=false;
    self.imagenNoticia.userInteractionEnabled=false;
    [self addEditButton];
}




#pragma mark - Buttons

-(void) addEditButton
{
    //añadirmos esta linea para que muestre el boton de editar
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc]initWithTitle:@"Editar" style:UIBarButtonItemStylePlain target:self action:@selector(changeToEditMode)];
    
    self.navigationItem.rightBarButtonItem = editButton;

}
-(void) addSaveButton
{
    //añadirmos esta linea para que muestre el boton de editar
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveNoticia)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

#pragma mark - Actions
- (IBAction)displayPhoto:(id)sender {
    /*   if (self.model.photo == nil)
     {
     self.model.photo = [IAAPhoto photoWithImage:nil context:self.model.managedObjectContext];
     }
     */
    
    
    // Crear un controlador de fotos
    IAAPhotoViewController *pVC = [[IAAPhotoViewController alloc]
                                   initWithImage:self.imagenNoticia.image];
    
    // Push que te crió
    [self.navigationController pushViewController:pVC
                                         animated:YES];
    
}
-(void) saveNoticia
{
    //[self addNewToAzure];
    [self editNewInAzure];
    [self changeToNoEditMode];
}
- (void)addNewToAzure{
     client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
                                             applicationKey:AZUREMOBILESERVICE_APPKEY];
    
    MSTable *news = [client tableWithName:@"news"];

        //NSDictionary * scoop= @{@"Titulo" : self.tituloNoticia.text, @"noticia" : self.textoNoticia.text,@"Imagen":self.imagenNoticia.image};
    NSDictionary * scoop= @{@"Titulo" : self.tituloNoticia.text, @"noticia" : self.textoNoticia.text};
    
    [news insert:scoop
      completion:^(NSDictionary *item, NSError *error) {
          if (error) {
              NSLog(@"Error %@", error);
          } else {
              NSLog(@"OK");
          }
       
          
      }];
}
- (void)editNewInAzure{
   client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
                                             applicationKey:AZUREMOBILESERVICE_APPKEY];
    
    MSTable *news = [client tableWithName:@"news"];
    
    //NSDictionary * scoop= @{@"Titulo" : self.tituloNoticia.text, @"noticia" : self.textoNoticia.text,@"Imagen":self.imagenNoticia.image};
    NSDictionary * scoop= @{@"id": self.model.id ,@"Titulo" : self.tituloNoticia.text, @"noticia" : self.textoNoticia.text};
    
    [news update:scoop completion:^(NSDictionary *item, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error);
        } else {
            NSLog(@"OK");
            
          /*  // Enviamos una notificación
            NSNotification *notification = [NSNotification notificationWithName: DID_NEW_NEWS_NOTIFICATION_NAME
                                          object:self
                                        userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self.navigationController.parentViewController newModels];
           */
            
            //modificamos el modelo
            [self.model setTitle:self.tituloNoticia.text];
           // self.model.text =self.textoNoticia.text;
        }
        
    }];
}

@end
