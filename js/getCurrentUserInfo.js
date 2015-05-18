/** 
 * Created by byjuanmn on 22/04/15. 
 * 
 * Mobile Services API 
 * Nombre API: getCurrentUserInfo 
 * Esta API optiene del usuario activo algunos atributos usando el api graph de Facebook 
 */ 
 exports.get = function(request, response) 
 {     
     request.user.getIdentities(
     {
         success: function (identities) 
         {             
             var http = require('request');             
             console.log('Identities: ', identities);             
             var url = 'https://graph.facebook.com/me?fields=id,name,birthday,hometown,email,picture,gender,friends&access_token=' +  
                   identities.facebook.accessToken;
             var reqParams = { uri: url, headers: { Accept: 'application/json' } };            
             http.get(reqParams, function (err, resp, body) 
             {                 
                var userData = JSON.parse(body);                
                 console.log('Logado -> ' + userData.name);                 
                  response.send(200, userData);             
              });         
         }
      });
 };