function changeStatusNews() 
{
    var sql = 'UPDATE news SET status = 2 WHERE status = 1;'
    mssql.query(sql,
    {
        success:function(results)
        {

        console.log("Updated " + results.lenght);

        }
    });

}