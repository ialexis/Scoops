function insert(item, user, request) {
   
   // Borro todas las valoraciones previas para esa noticia y ese usuario
   var newsid = item.newsID;
   var userID = item.userID;

   var sql_delete = "DELETE FROM commets WHERE newsID= '" + newsid + "'and  userID='" + userID+"'";
   
   mssql.query(sql_delete, 
   {
        success: function(results)
        {
            console.log('Delete ok ' + newsid);            
            //calculo la media de las noticias
            var sql_media = "select SUM(rating) as miRatingSumado, COUNT(rating) as miRatingContado FROM commets WHERE newsID= '" + newsid + "'";
            mssql.query(sql_media, 
            {
                success: function(results)
                {
                     console.log('Media ok ' + results[0]);           
                     console.log('mi rating sumado:' + results[0].miRatingSumado);
                     console.log('mi nuevo rating:' + item.rating);
                     //grabar el resultado
                     var miResultadoSumado=results[0].miRatingSumado+item.rating;
                     var miResultadoContado=results[0].miRatingContado+1;
                    
                     var miResultado = miResultadoSumado/miResultadoContado;    
                     
                     
                     console.log (results[0]);
                     console.log (miResultado);
                     var sql_update_media = "update news set rating="+miResultado+" WHERE id= '" + newsid + "'";
                     console.log (sql_update_media);
                     
                     mssql.query(sql_update_media, 
                     {
                         success: function(results)
                         {
                             console.log('Update Media ok ' + results);   
                         }
                     });
                 }
              });
          }, error: function(err)
          {
            console.log('Error Delete: ' + err);
           }
     });
    
    request.execute();

}