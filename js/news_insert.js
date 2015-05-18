function insert(item, user, request) {

    if (item.Titulo && item.noticia)
    {
        request.execute();
    }
    else
    {
        request.respond(400, 'titulo o texto no encontrado');
    }
}