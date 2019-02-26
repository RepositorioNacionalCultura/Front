<%-- 
    Document   : footer
    Created on : 25/07/2018, 12:12:47 PM
    Author     : sergio.tellez
--%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    String siteid = paramRequest.getWebPage().getWebSiteId();
    String userlang = paramRequest.getUser().getLanguage();
%>
<footer class="gris21-bg">
    <div class="container">
        <div class="logo-cultura"><img class="img-responsive" src="/work/models/<%=siteid%>/img/logo-cultura.png" /></div>
        <div class="row pie-sube"><a href="#top"><i aria-hidden="true" class="ion-ios-arrow-thin-up"></i> </a></div>
        <div class="row datos">
            <div class="col-7 col-sm-6 col-md-4 col-lg-4 datos1">
                <ul>
                    <li><a href="/<%=userlang%>/<%=siteid%>/somos">Qui�nes somos y qu� hacemos</a></li>
                    <li><a href="/<%=userlang%>/<%=siteid%>/proveedores">Nuestros proveedores de datos</a></li>
                    <li><a href="/<%=userlang%>/<%=siteid%>/colaborar">C�mo colaborar con nosotros</a></li>
                </ul>
            </div>
            <div class="col-5 col-sm-6 col-md-4 col-lg-4 datos2">
                <ul>
                    <li><a href="/<%=userlang%>/<%=siteid%>/derechos">Declaraci�n de derechos</a></li>
                    <li><a href="/<%=userlang%>/<%=siteid%>/documentacion-tecnica">Documentaci�n</a></li>
                    <li><a href="/<%=userlang%>/<%=siteid%>/red-preservacion">Red de Preservaci�n</a></li>
                </ul>
            </div>
            <hr class="d-md-none" />
            <div class="col-7 col-sm-6 col-md-4 col-lg-4 datos3">
                <ul>
                    <li><a href="#">Contacto</a></li>
                    <li><a href="#">1234 5678 ext. 123 y 456</a></li>
                    <li><a href="#">email@cultura.gob.mx</a></li>
                </ul>
            </div>
            <hr class="d-none d-sm-none d-md-block" />
            <div class="col-5 col-sm-6 col-md-12 col-lg-12 datos4">
                <ul class="row">
                    <li class="col-md-4"><a href="#">Mapa de sitio</a></li>
                    <li class="col-md-4"><a href="#">Pol�tica de Privacidad</a></li>
                    <li class="col-md-4"><a href="/<%=userlang%>/<%=siteid%>/terminos">T�rminos de uso</a></li>
                </ul>
            </div>
        </div>
    </div>
</footer>
<div class="container-fluid pie-derechos">
    <p>Secretar�a de Cultura, 2017. Todos los derechos reservados.</p>
</div>