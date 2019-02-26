<%-- 
    Document   : themes
    Created on : 27/06/2018, 15:16:49 PM
    Author     : sergio.tellez
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.semanticwb.portal.api.SWBParamRequest, org.semanticwb.model.WebSite, mx.gob.cultura.portal.response.Collection, java.util.List"%>
<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    WebSite site = paramRequest.getWebPage().getWebSite();
    String userLang = paramRequest.getUser().getLanguage();
    StringBuilder url = new StringBuilder("/").append(userLang).append("/").append(site.getId()).append("/resultados?word=*");
    String memorysound = "&resourcetype=Programa de radio::Grabación sonora::Concierto::Ópera::Partitura::cantos::Entrevista&holder=Radio Educación::Fonoteca Nacional::Centro Nacional de las Artes::Biblioteca Vasconcelos::Instituto Nacional de Estudios Históricos de las Revoluciones de México::Instituto Nacional de Bellas Artes::Instituto Nacional de Bellas Artes y Literatura::INBA Digital&theme=Memoria Sonora";
    String memoryvisual = "&resourcetype=Fotografía::Programa de televisión::Documental::Cartel::Fotomontaje::Dibujo::Mapa::Video::Cápsula de video::Programa::Pintura::Obra gráfica&holder=Centro de la Imagen::Televisión Metropolitana S.A. de C.V.::Biblioteca de las Artes::Instituto Mexicano de Cinematografía::Dirección General de Culturas Populares::Instituto Nacional de Estudios Históricos de las Revoluciones de México::Instituto Nacional de Bellas Artes::Instituto Nacional de Bellas Artes y Literatura::INBA Digital::Instituto Nacional de Lenguas Indígenas::INALI::Museo Nacional del Virreinato::Instituto Nacional de Antropología e Historia::Mediateca::Museo Nacional de Historia::Museo de Arte Moderno&theme=Memoria Visual";
    String release = "&resourcetype=Conferencia::Foro::Presentación::Mesa de diálogo::Seminario::Cápsula de video::Entrevista::Curso::Coloquio::Artículo de Revista::Capítulo de libro::Conversación::Guía turística::Cuaderno de trabajo::Estudio de público::Expediente técnico de denominación::Manual::Proyecto de restauración::Proyecto museográfico::Reporte de prácticas::Catálogo digital::Interactivo&holder=Centro Nacional de las Artes::Biblioteca Vasconcelos::Instituto Nacional de Estudios Históricos de las Revoluciones de México::Instituto Nacional de Bellas Artes::Instituto Nacional de Bellas Artes y Literatura::INBA Digital::Instituto Nacional de Lenguas Indígenas::INALI::Instituto Nacional de Antropología e Historia::Mediateca&theme=Divulgación";
    String art = "&resourcetype=Danza::Busto::Cartel::Escultura::Estampa::Fotografía::Impreso::Manuscrito::Libro::Matriz::Ornamento::Pintura::Relieve::Alcancía::Ánfora::Capítulo de libro::Bastón::Batea::Baúl::Bolsa::Botellón::Candelero::Cartel::Cinturón::Falda::Florero::Fuete::Huarache::Jarra::Jícara::Juguete::Lazo::Mantel::Mecapal::Olla::Paragüero::Plato::Platón::Rebozo::Sarape::Sillón::Sombrero::Sopera::Taza::Tinaja::Trastero::Utensilio::Vasija::Animación::Documento::Grabación::Libro::Partitura::Presentación::Programa::Tesis::Video::Pintura de caballete::Pintura mural::Pintura mural moderna::Pintura mural novohispana::Elemento arquitectónico::Numismática::Pieza arqueológica::Pintura de caballete::Exvoto::Dibujo::Arte plumario::Cristalería::Enconchados::Vidrio::Instrumento musical::Obra gráfica::Gráfica::Obra escultórica&holder=Centro Nacional de las Artes::Museo Nacional de Arte::Instituto Nacional de Bellas Artes::Instituto Nacional de Bellas Artes y Literatura::INBA Digital::Instituto Nacional de Lenguas Indígenas::INALI::Instituto Nacional de Antropología e Historia::Mediateca::Museo Nacional del Virreinato::Museo Nacional de Historia::Museo Nacional de la Estampa::Museo de Arte Moderno::Museo Nacional de San Carlos&theme=Arte";
    String documents = "&resourcetype=Libro::Revista::Manuscrito::Borrador::Capítulo de Libro::Documento::Tesis::Narrativa::Cuadernos de trabajo::Catálogo de exposición::Reseña::Artículo de revista::Editorial::Plano::Códice::Mapa::Número de revista::Número de revista&holder=Biblioteca de las Artes::Dirección General de Bibliotecas::Dirección General de Publicaciones::Museo Nacional de Arte::Instituto Nacional de Bellas Artes::Instituto Nacional de Bellas Artes y Literatura::INBA Digital::Instituto Nacional de Lenguas Indígenas::INALI::Instituto Nacional de Antropología e Historia::Mediateca&theme=Libros, textos y documentos";
    String history = "&resourcetype=Curso::Coloquio::Fotografía::Programa de radio::Conferencia::Entrevista::Exposición::Foro::Premiación::Presentación::Seminario::Archivo histórico::Libro de coro::Acuerdo::Armas::Bandera::Cerámica::Códice::Contenedor::Elemento arquitectónico::Escultura::Heráldica::Herramienta::Indumentaria::Instrumento musical::Libro::Litografía::Mapa::Mapoteca::Maqueta::Máscara::Miniatura::Mobiliario::Numismática::Objeto de uso cotidiano::Objeto etnográfico::Objeto funerario::Objeto litúrgico::Ornamento::Pieza arqueológica::Pintura de caballete::Pintura mural novohispana::Plano::Resto geológico::Resto óseo::Textil::Vehículo::Vidrio::Arma::Elemento Arquitectónico::Equipo de oficina::Indumentaria::Instrumento musical::Joyería::Juguete::Miniatura::Mobiliario::Técnica Mixta::Utensilio::Vasija::Votivo::Costa del Golfo::Maya::Occidente::Aceitera::Árbol::Banca::Barreta::Barril::Baúl::Bieldo::Boletero::Bolsa::Cámara::Campana::Candado::Carrete::Coche::Cofre::Compás::Corneta::Cucharilla::Cucharón::Escatillón::Escudo::Extintor::Farola::Granada::Hielera::Inventario::Lámpara::Lechera::Llave::Locomotora::Machuelo::Manómetro::Microscopio::Modelo::Nivel::Parihuela::Pizarrón::Placa::Porta::Reloj::Resonador::Sello::Señal::Silbato::Taladro::Telegráfono::Tenaza::Teodolito::Velocímetro::Verificadora::Voltímetro&holder=Instituto Nacional de Estudios Históricos de las Revoluciones de México::Instituto Nacional de Antropología e Historia::Mediateca::Museo Nacional de Historia::Museo Nacional de Antropología::Museo Nacional de los Ferrocarriles&theme=Historia";
    String anthropology = "&resourcetype=Ceremonia::Etnografía::Cuestionario::Elicitación::Léxico::Lista de Palabras::Transcripción::Gramática::Pintural mural prehispánica::Armas::Cerámica::Contenedor::Elemento arquitectónico::Escultura::Heráldica::Herramienta::Indumentaria::Instrumento musical::Maqueta::Mobiliario::Numismática::Objeto de uso cotidiano::Objeto de uso personal::Ornamento::Pieza arqueológica::Pintura mural prehispánica::Resto óseo::Resto vegetal::Textil::Fósil::Resto geológico::Costa del Golfo::Maya::Occidente&holder=Instituto Nacional de Lenguas Indígenas::INALI::Instituto Nacional de Antropología e Historia::Mediateca::Museo Nacional de Historia::Museo Nacional de Antropología&theme=Antropología";
    String archeology = "&resourcetype=Ceremonia::Pieza arqueológica::Fósil::Resto geológico::Resto óseo::Herramienta::Arqueología&holder=Instituto Nacional de Lenguas Indígenas::INALI::Instituto Nacional de Antropología e Historia::Mediateca::Museo Nacional de Historia::Museo Nacional de Antropología&theme=Arqueología";

%>
<div id="explorar">
    <div class="row grid">
        <div class="col-sm-6 col-md-4 anim-box">
            <a class="a-img" href="<%=url%><%=memorysound%>"><img src="/work/models/<%=site.getId()%>/img/temas/ms.jpg" alt=""></a>
            <div class="caption"><a class="a-int oswB" href="<%=url%><%=memorysound%>"><%=paramRequest.getLocaleString("usrmsg_view_search_memory_sound")%></a></div>
        </div>
        <div class="col-sm-6 col-md-4 anim-box ej2">
            <a class="a-img" href="<%=url%><%=memoryvisual%>"><img src="/work/models/<%=site.getId()%>/img/temas/visual.jpg" alt=""></a>
            <div class="caption"><a class="a-int oswB" href="<%=url%><%=memoryvisual%>"><%=paramRequest.getLocaleString("usrmsg_view_search_memory_visual")%></a></div>
        </div>
        <div class="col-sm-6 col-md-4 anim-box">
            <a class="a-img" href="<%=url%><%=release%>"><img src="/work/models/<%=site.getId()%>/img/temas/divulgacion.jpg" alt=""></a>
            <div class="caption"><a class="a-int oswB" href="<%=url%><%=release%>"><%=paramRequest.getLocaleString("usrmsg_view_search_divulgation")%></a></div>
        </div>				
        <div class="col-sm-6 col-md-4 anim-box ej2">
            <a class="a-img" href="<%=url%><%=art%>"><img src="/work/models/<%=site.getId()%>/img/temas/arte2.jpg" alt=""></a>
            <div class="caption"><a class="a-int oswB" href="<%=url%><%=art%>"><%=paramRequest.getLocaleString("usrmsg_view_search_art")%></a></div>
        </div>			
        <div class="col-sm-6 col-md-4 anim-box">
            <a class="a-img" href="<%=url%><%=documents%>"><img src="/work/models/<%=site.getId()%>/img/temas/libros3.jpg" alt=""></a>
            <div class="caption"><a class="a-int oswB" href="<%=url%><%=documents%>"><%=paramRequest.getLocaleString("usrmsg_view_search_documents")%></a></div>
        </div>			
        <div class="col-sm-6 col-md-4 anim-box ej2">
            <a class="a-img" href="<%=url%><%=history%>"><img src="/work/models/<%=site.getId()%>/img/temas/historia2.jpg" alt=""></a>
            <div class="caption"><a class="a-int oswB" href="<%=url%><%=history%>"><%=paramRequest.getLocaleString("usrmsg_view_search_history")%></a></div>
        </div>			
        <div class="col-sm-6 col-md-4 anim-box ej2">
            <a class="a-img" href="<%=url%><%=anthropology%>"><img src="/work/models/<%=site.getId()%>/img/temas/antropologia2.jpg" alt=""></a>
            <div class="caption"><a class="a-int oswB" href="<%=url%><%=anthropology%>"><%=paramRequest.getLocaleString("usrmsg_view_search_anthropology")%></a></div>
        </div>			
        <div class="col-sm-6 col-md-4 anim-box ej2">
            <a class="a-img" href="<%=url%><%=archeology%>"><img src="/work/models/<%=site.getId()%>/img/temas/arqueologia.jpg" alt=""></a>
            <div class="caption"><a class="a-int oswB" href="<%=url%><%=archeology%>"><%=paramRequest.getLocaleString("usrmsg_view_search_archeology")%></a></div>
        </div>
    </div>
</div>