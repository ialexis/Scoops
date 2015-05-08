//
//  IAANewsTableViewController.m
//  Practica Scoops
//
//  Created by Ivan on 28/04/15.
//  Copyright (c) 2015 Ivan. All rights reserved.
//

#import "IAANewsTableViewController.h"
#import "IAASettings.h"
#import "IAANews.h"
#import "IAAOneNew.h"
#import "IAAOneNewsViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface IAANewsTableViewController ()
{
    MSClient * client;
    NSString *userFBId;
    NSString *tokenFB;
}

@end

@implementation IAANewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    // Muy importante, solo nos interesa los cambios en NUESTRO libro!
    [nc addObserver:self
           selector:@selector(newModels)
               name:DID_NEW_NEWS_NOTIFICATION_NAME
             object:nil];

    // llamamos a los metodos de Azure para crear y configurar la conexion
    [self warmupMSClient];
    [self loadUserdata];
   // [self loginFB];
    

    
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.model loadNewsFromAzure];
  //  [self newModels];
}
-(void) addPictureButtonWithUrlImage: (NSURL *) url
{
    //añadirmos esta linea para que muestre el boton de editar
   // UIBarButtonItem* PictureButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    dispatch_queue_t queue = dispatch_queue_create("descargaImagenes", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        NSData *buff = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *imagenPerfil=[UIImage imageWithData:buff];
            UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
            face.bounds = CGRectMake( 0, 0, imagenPerfil.size.width, imagenPerfil.size.height );
            face.layer.cornerRadius = imagenPerfil.size.width / 2;
            [face setImage:imagenPerfil forState:UIControlStateNormal];
            face.clipsToBounds = YES;
            UIBarButtonItem *faceBtn = [[UIBarButtonItem alloc] initWithCustomView:face];
            
            
            self.navigationItem.leftBarButtonItem = faceBtn;
        });
        
    });
    
    
    
    
    
   // UIImage *faceImage = [UIImage imageNamed:@"facebook.png"];
  //  UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    
    
    
  //  PictureButton.image = [UIImage imageWithData:<#(NSData *)#>]
    

    
}

-(void) addLogOffButton{
    //añadirmos esta linea para que muestre el boton de editar
    UIBarButtonItem* LogoffButton = [[UIBarButtonItem alloc]initWithTitle:@"Logoff" style:UIBarButtonItemStylePlain target:self action:@selector(logOff)];
    self.navigationItem.rightBarButtonItem = LogoffButton;
    
}
-(void) addLogInButton{
    //añadirmos esta linea para que muestre el boton de editar
    UIBarButtonItem* LogoffButton = [[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(loginFB)];
    self.navigationItem.rightBarButtonItem = LogoffButton;
}


-(void) newModels
{
    //[self.model loadNewsFromAzure];
    [self.tableView reloadData];
}

#pragma mark - init


-(id) initWithModel: (IAANews *) model style:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        _model=model;
        self.title=@"Scoop News";
    }
    return self;

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    
    if (userFBId)
    {
        return 3;
    }
    else
    {
        return 1;
        
    }
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (section==SECTION_NEWS_WRITED)
    {
        return TITLE_NEWS_WRITED;
    }
    else if (section==SECTION_NEWS_REVIEWED)
    {
        return TITLE_NEWS_REVIEWED;
    }
    else
    {
        return TITLE_NEWS_PUBLISED;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (section==SECTION_NEWS_PUBLISED)
    {
        return [self.model newsPublishedCount];
    }
    else if (section==SECTION_NEWS_REVIEWED)
    {
        return [self.model newsReviewedCount];
    }
    else
    {
         return [self.model newsWritedCount];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //averiguar de que modelo (personaje) esta solicitando la celda
    IAAOneNew *oneNew = [self noticiaAtIndexPath:indexPath];
    
    
    //Crear una celda
    static NSString * cellID=@"ScoopeCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell==nil)
    {
        //la tenemos que crear nosotros desde cero
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:cellID];
    }
    
    //Configurar la celta
    //sincronizacmos modelo (personaje) con la vista (la celda)
    
    //cell.imageView.image = character.photo;
    cell.textLabel.text=oneNew.title;
    cell.detailTextLabel.text=oneNew.text;
    
    //Devolver la celda
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Averiguar la NOTICIA
    IAAOneNew *noticia = [self noticiaAtIndexPath:indexPath];
    
    // Crear el controlador
    IAAOneNewsViewController *nVC = [[IAAOneNewsViewController alloc] initWithModel:noticia andClient:client];
    
    // Hacer el push
    [self.navigationController pushViewController:nVC
                                         animated:YES];
}





/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Utils
- (IAAOneNew *) noticiaAtIndexPath: (NSIndexPath *) indexPath
{
    IAAOneNew *oneNew;
    if (indexPath.section==SECTION_NEWS_PUBLISED)
    {
        oneNew = [self.model newsPublishedAtIndex:indexPath.row];
    }
    else if (indexPath.section==SECTION_NEWS_REVIEWED)
    {
        oneNew = [self.model newsReviwedAtIndex:indexPath.row];
        
    }
    else
    {
        oneNew = [self.model newsWritedAtIndex:indexPath.row];
    }
    return oneNew;
}


#pragma mark - Azure connect, setup, login etc...

-(void)warmupMSClient
{
    client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
                                 applicationKey:AZUREMOBILESERVICE_APPKEY];
    
    NSLog(@"%@", client.debugDescription);
}


- (void) loadUserdata
{
     self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem=nil;
    [self loadUserAuthInfo];
    
    if (client.currentUser){
        [client invokeAPI:@"getCurrentUserInfo" body:nil HTTPMethod:@"GET" parameters:nil headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
            
            //tenemos info extra del usuario
            NSLog(@"%@", result);
            //self.profilePicture =
            
            [self addPictureButtonWithUrlImage:[NSURL URLWithString:result[@"picture"][@"data"][@"url"]]];
            [self addLogOffButton];
            
        }];
        
        return;
    }
    
    [self addLogInButton];
    

}

- (void)loginAppInViewController:(UIViewController *)controller withCompletion:(completeBlock)bloque{
    
    
    
    [client loginWithProvider:@"facebook"
                   controller:controller
                     animated:YES
                   completion:^(MSUser *user, NSError *error) {
                       
                       if (error) {
                           NSLog(@"Error en el login : %@", error);
                           bloque(nil);
                       } else {
                           NSLog(@"user -> %@", user);
                           
                           [self saveAuthInfo];
                           [client invokeAPI:@"getCurrentUserInfo" body:nil HTTPMethod:@"GET" parameters:nil headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                               
                               //tenemos info extra del usuario
                               NSLog(@"%@", result);
                               
                               [self addPictureButtonWithUrlImage:[NSURL URLWithString:result[@"picture"][@"data"][@"url"]]];
                               [self addLogOffButton];
                               
                               [self newModels];

                               
                           }];
                           
                           bloque(@[user]);
                       }
                   }];
    
    
}


- (BOOL)loadUserAuthInfo{
    
    userFBId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    tokenFB = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
    
    if (userFBId) {
        client.currentUser = [[MSUser alloc]initWithUserId:userFBId];
        client.currentUser.mobileServiceAuthenticationToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
        
        
        
        return TRUE;
    }
    
    return FALSE;
}


- (void) saveAuthInfo{
    [[NSUserDefaults standardUserDefaults]setObject:client.currentUser.userId forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults]setObject:client.currentUser.mobileServiceAuthenticationToken
                                             forKey:@"tokenFB"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    userFBId = client.currentUser.userId;
    tokenFB = client.currentUser.mobileServiceAuthenticationToken;

    
}

-(void)logOff
{

    [client logout];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults]setObject:nil
                                             forKey:@"tokenFB"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    userFBId = nil;
    tokenFB = nil;
    
    [self loadUserdata];
    [self newModels];
   
}

-(void)setProfilePicture:(NSURL *)profilePicture{
    
    
    
 /*
    _profilePicture = profilePicture;
    
    dispatch_queue_t queue = dispatch_queue_create("descargaImagenes", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        NSData *buff = [NSData dataWithContentsOfURL:profilePicture];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.picProfile.image = [UIImage imageWithData:buff];
            self.picProfile.layer.cornerRadius = self.picProfile.frame.size.width / 2;
            self.picProfile.clipsToBounds = YES;
        });
        
    });
    */
    
}
- (void)loginFB {
    //login
    
    
    [self loginAppInViewController:self withCompletion:^(NSArray *results) {
        
        NSLog(@"Resultados ---> %@", results);
        
    }];
}

@end
