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


@interface IAAOneNewsViewController ()
{
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
    self.labelPuntuacion.text = [self.model.puntuacion stringValue];
    self.sliderRating.value = [self.model.puntuacion floatValue];
    
    //tap en foto
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)];
    
    [self.imagenNoticia addGestureRecognizer:tap];
    
    // Fechas
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateStyle = NSDateFormatterShortStyle;
    
    self.labelFechaCreacion.text = [fmt stringFromDate:self.model.dateCreated];
    self.labelFechaModificacion.text = [fmt stringFromDate:self.model.dateModif];
    
    //coordenadas
    self.labelCoordenadas.text=[NSString stringWithFormat:@"Lat:%@, Long:%@",self.model.latitude,self.model.longitude];
    
    //status
    if ([self.model.status  isEqual:@0])
    {
        [self.switchPublicada setOn:false];
    }
    else
    {
        [self.switchPublicada setOn:TRUE];
    }
    
    //ponenoms el modo de no edicion
    [self changeToNoEditMode];
    
    //usuario
    if ([self loadUserAuthInfo])
    {
        if (self.client.currentUser){
            [self.client invokeAPI:@"getCurrentUserInfo" body:nil HTTPMethod:@"GET" parameters:nil headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
            
                //tenemos info extra del usuario
                NSLog(@"%@", result);
                //self.profilePicture =
                self.labelNombreAutor.text = result[@"name"];
                [self authorPictureWithUrlImage:[NSURL URLWithString:result[@"picture"][@"data"][@"url"]]];
            
            }];
        
            return;
        }
    }
    

 
    
    
   
}

-(void) authorPictureWithUrlImage: (NSURL *) url
{
    
    dispatch_queue_t queue = dispatch_queue_create("descargaImagenes", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        NSData *buff = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *imagenPerfil=[UIImage imageWithData:buff];

            //self.imagenAutor.bounds = CGRectMake( 0, 0, self.imagenAutor.image.size.width, self.imagenAutor.image.size.height );
            self.imagenAutor.layer.cornerRadius = self.imagenAutor.frame.size.width / 2;
            
            self.imagenAutor.image = imagenPerfil;
            self.imagenAutor.clipsToBounds = YES;
            
          //  self.picProfile.image = [UIImage imageWithData:buff];
          //  self.picProfile.layer.cornerRadius = self.picProfile.frame.size.width / 2;
          //  self.picProfile.clipsToBounds = YES;
            
        });
        
    });
    
}

-(id) initWithModel: (IAAOneNew *) model andClient: (MSClient *) client
{
    if (self=[super initWithNibName:nil bundle:nil])
    {
        _model = model;
        _client= client;
        
        
        
        self.title = [model title];
    }
    return self;
}

- (IBAction)changeRating:(id)sender {
    
    MSTable *table_comments = [self.client tableWithName:@"commets"];
    
    /*
    //borramos los anteriores ratings de esa noticia
    NSDictionary * scoopDelete= @{@"user" : userFBId, @"newsID":self.model.id};
    [table_comments delete:scoopDelete
                completion:^(NSDictionary *item, NSError *error) {
                    if (error) {
                        NSLog(@"Error %@", error);
                    } else {
                        NSLog(@"OK");
                    }
                    
                    
                }];

    
    */
 
    NSDictionary * scoop= @{@"userID" : userFBId, @"newsID":self.model.id,@"rating" : [NSNumber numberWithFloat:self.sliderRating.value]};
    
    [table_comments insert:scoop
      completion:^(NSDictionary *item, NSError *error) {
          if (error) {
              NSLog(@"Error %@", error);
          } else {
              NSLog(@"OK");
          }
      }];
}

#pragma mark - edit mode and no edit mode
-(void) changeToEditMode
{
    
    userFBId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    tokenFB = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
    
    if (userFBId) {
        self.tituloNoticia.userInteractionEnabled=YES;
        self.textoNoticia.userInteractionEnabled=YES;
        self.imagenNoticia.userInteractionEnabled=YES;
        self.switchPublicada.userInteractionEnabled=YES;
    }
    
    [self addSaveButton];
}
-(void) changeToNoEditMode
{
    self.tituloNoticia.userInteractionEnabled=NO;
    self.textoNoticia.userInteractionEnabled=NO;
    self.imagenNoticia.userInteractionEnabled=NO;
    self.switchPublicada.userInteractionEnabled=NO;
    
    userFBId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    tokenFB = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
    
    if (userFBId) {
        [self addEditButton];
        self.sliderRating.userInteractionEnabled=YES;
    }
    else
    {
         self.sliderRating.userInteractionEnabled=NO;
    }
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
    
    
    // Crear un controlador de fotos
    IAAPhotoViewController *pVC = [[IAAPhotoViewController alloc]
                                   initWithModel:self.model];
    
    // Push
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
    // client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
    //                                         applicationKey:AZUREMOBILESERVICE_APPKEY];
    
    MSTable *news = [self.client tableWithName:@"news"];

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
 //  client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
 //                                            applicationKey:AZUREMOBILESERVICE_APPKEY];
    
    MSTable *news = [self.client tableWithName:@"news"];
    
    NSNumber *mystatus=@0;
    if (self.switchPublicada.on)
    {
        mystatus=@1;
    }
    
    //NSDictionary * scoop= @{@"Titulo" : self.tituloNoticia.text, @"noticia" : self.textoNoticia.text,@"Imagen":self.imagenNoticia.image};
    NSDictionary * scoop= @{@"id": self.model.id ,@"Titulo" : self.tituloNoticia.text, @"noticia" : self.textoNoticia.text,@"author" : userFBId,@"status":mystatus};
    
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


- (BOOL)loadUserAuthInfo{
    
    userFBId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    tokenFB = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
    
    if (userFBId) {
        self.client.currentUser = [[MSUser alloc]initWithUserId:userFBId];
        self.client.currentUser.mobileServiceAuthenticationToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
        
        
        
        return TRUE;
    }
    
    return FALSE;
}



#pragma mark - Foto
-(void) selectPhoto:(id) sender{
    
    
    IAAPhotoViewController *photoVC = [[IAAPhotoViewController alloc] initWithModel:self.model];
    
    [self.navigationController pushViewController:photoVC animated:YES];
}


@end
