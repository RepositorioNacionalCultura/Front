<%-- 
    Document   : view
    Created on : 23/04/2018, 05:39:10 PM
    Author     : rene.jara
--%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.semanticwb.model.UserRepository"%>
<%@page import="mx.gob.cultura.portal.resources.AnnotationsMgr"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="java.util.ArrayList"%>
<%@page import="mx.gob.cultura.portal.persist.AnnotationMgr"%>
<%@page import="org.semanticwb.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest" />
<%
    String userId = "";
    User user = paramRequest.getUser();
    if (user.isSigned()) userId=user.getId();
    boolean isAdmin=(boolean) request.getAttribute("isAdmin");
    boolean isAnnotator = (boolean)request.getAttribute("isAnnotator");
    
    int totalPages = (Integer)request.getAttribute("totalPages");
    int currentPage = (Integer)request.getAttribute("currentPage");
    
    String filter = (String)request.getAttribute("filter");
    String userlang = paramRequest.getUser().getLanguage();
    String siteid = paramRequest.getWebPage().getWebSiteId();

    String pagerUrl = paramRequest.getRenderUrl().setMode(AnnotationsMgr.MODE_MANAGE).toString();

    SWBResourceURL listURL = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT);
    listURL.setMode(AnnotationsMgr.ASYNC_LIST);
    SWBResourceURL accURL = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT);
    accURL.setMode(AnnotationsMgr.ASYNC_ACCEPT);
    SWBResourceURL rjcURL = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT);
    rjcURL.setMode(AnnotationsMgr.ASYNC_REJECT);
    SWBResourceURL modURL = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT);
    modURL.setMode(AnnotationsMgr.ASYNC_MODIFY);
    SWBResourceURL delURL = paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT);
    delURL.setMode(AnnotationsMgr.ASYNC_DELETE);
    List<Map<String,String>> annotations = (List<Map<String,String>>) request.getAttribute("annotations");
    if (!userId.isEmpty() && (isAdmin||isAnnotator)) {
%>

<script>
    function callAction(url,id,bodyValue){
        console.log("callAction"+id);
        $.getJSON(url,{'id':id,'bodyValue':bodyValue}, function (data) {
            if(data.deleted){
                $('#div_'+id).replaceWith('<div>borrado</div>');
            }else{
                $('#div_'+data.id).replaceWith(buildDiv(data));
            }    

        }).fail(function( jqxhr, textStatus, error ) {
            var err = textStatus + ", " + error;
            console.log( "Request Failed: " + err );
            alert(err);
        });
    }
    function buildDiv(element){
        console.log("buildDiv"+element);    
        lContent ='';
<%  
        if(isAdmin) {
%>        
        if(element.isOwn && element.isMod) {
            lContent += '<div class="media" id="div_'+element.id+'">'+
                        '<div class="media-body">'+
                        '<p class="mt-0 fecha">'+element.created+'</p>'+
                        '<p class="oswB uppercase">'+element.creator+'</p>'+
                        '<p class="mt-0 rojo"><a href="/<%=userlang%>/<%=siteid%>/detalle?id='+element.oid+'">'+element.bicTitle+'</a></p>';                       
            lContent += '<textarea id="bv'+element.id+'">'+element.bodyValue+'</textarea>'+
                        '<button type="button" class="btn btn-rojo" onclick="callAction(\'<%=modURL.toString()%>\',\''+element.id+'\',$(\'#bv'+element.id+'\').val());return false;">Cambiar</button>';
            lContent += '<a href="#" onclick="callAction(\'<%=delURL.toString()%>\',\''+element.id+'\');return false;">Borrar</a>'+
                        '<a href="#" onclick="callAction(\'<%=accURL.toString()%>\',\''+element.id+'\');return false;">Autorizar</a>';
            lContent += '</div>'+
                        '</div>';  
            liContent=lContent;
        }else{  
            lContent += '<div class="media" id="div_'+element.id+'">'+
                        '<div class="media-body">'+
                        '<p class="mt-0 fecha">'+element.created+'</p>'+
                        '<p class="oswB uppercase">'+element.creator+'</p>'+
                        '<p class="mt-0 rojo"><a href="/<%=userlang%>/<%=siteid%>/detalle?id='+element.oid+'">'+element.bicTitle+'</a></p>';                       
            bvs=element.bodyValue;
            if(bvs) {
                bva=bvs.split('\n');
                for (i=0;i<bva.length;i++){
                    if (i<2) {
                        lContent +='<p>'+bva[i]+'</p>';
                    }else{
                        if(i==2) {
                            lContent +='<div class="collapse" id="vermas-'+element.id+'">';
                        }
                        lContent +='<p>'+bva[i]+'</p>';                      
                        if(i==bva.length-1) {
                            lContent +='</div>'+
                                '<p class="vermas vermas-0 vermas-rojo vermas-'+element.id+'">'+
                                '<button aria-controls="vermas" aria-expanded="false" class="btn-vermas '+
                                'btn-vermas-'+element.id+'" data-target="#vermas-'+element.id+'" data-toggle="collapse" '+
                                'type="button">Ver más <span class="ion-plus-circled"></span></button>'+
                                '<span class="linea"></span>'+
                                '</p>';
                        }
                    }    
                }       
            }
            if(element.isMod) {
                lContent += '<a href="#" onclick="callAction(\'<%=accURL.toString()%>\',\''+element.id+'\');return false;">Autorizar</a>';
            }else {   
                lContent += '<a href="#" onclick="callAction(\'<%=rjcURL.toString()%>\',\''+element.id+'\');return false;">Desautorizar</a>';
            }    
            lContent += '</div>'+
                        '</div>';  
            liContent=lContent;
        }

<%
        }else {
%>        
        if(element.isMod) {
            lContent += '<div class="media" id="div_'+element.id+'">'+
                        '<div class="media-body">'+
                        '<p class="mt-0 fecha">'+element.created+'</p>'+
                        '<p class="oswB uppercase">'+element.creator+'</p>'+
                        '<p class="mt-0 rojo"><a href="/<%=userlang%>/<%=siteid%>/detalle?id='+element.oid+'">'+element.bicTitle+'</a></p>';                       
            lContent += '<textarea id="bv'+element.id+'">'+element.bodyValue+'</textarea>'+
                        '<button type="button" class="btn btn-rojo" onclick="callAction(\'<%=modURL.toString()%>\',\''+element.id+'\',$(\'#bv'+element.id+'\').val());return false;">Cambiar</button>';
            lContent += '<a href="#" onclick="callAction(\'<%=delURL.toString()%>\',\''+element.id+'\');return false;">Borrar</a>';
            lContent += '</div>'+
                        '</div>';  
            liContent=lContent;
        }else {            
            lContent += '<div class="media" id="div_'+element.id+'">'+
                        '<div class="media-body">'+
                        '<p class="mt-0 fecha">'+element.created+'</p>'+
                        '<p class="oswB uppercase">'+element.creator+'</p>'+
                        '<p class="mt-0 rojo"><a href="/<%=userlang%>/<%=siteid%>/detalle?id='+element.oid+'">'+element.bicTitle+'</a></p>';                       
            bvs=element.bodyValue;
            if(bvs) {
                bva=bvs.split('\n');
                for (i=0;i<bva.length && 1<3;i++) {
                    if (0<2) { //para no borrar el if
                        lContent +='<p>'+bva[i]+'</p>';
                    }else{
                        if(i==2) {
                            lContent +='<div class="collapse" id="vermas-'+element.id+'">';
                        }
                        lContent +='<p>'+bva[i]+'</p>';                      
                        if(i==bva.length-1){
                            lContent +='</div>'+
                                '<p class="vermas vermas-0 vermas-rojo vermas-'+element.id+'">'+
                                '<button aria-controls="vermas" aria-expanded="false" class="btn-vermas '+
                                'btn-vermas-'+element.id+'" data-target="#vermas-'+element.id+'" data-toggle="collapse" '+
                                'type="button">Ver más <span class="ion-plus-circled"></span></button>'+
                                '<span class="linea"></span>'+
                                '</p>';
                        }
                    }    
                }       
            }   
            lContent += '</div>'+
                        '</div>';  
            liContent=lContent;
        }
<%  
        }
%>  
        return liContent;
    }
</script>         
<%
    }
%>        
    <section id="contenidoInterna">
        <div class="espacioTop"></div>
        <div class="content container">
            <!-- contenido -->
            <div class="container usrTit">
                <!--div class="row">
                   <img src="img/agregado-07.jpg" class="circle">
                   <div>
                       <h2 class="oswM nombre">Leonor Rivas Mercado</h2>
                       <p>Institución Lorem Ipsum</p>
                       <p>Mi Puesto, Área de interés</p>
                       <button class="btn-cultura btn-blanco">EDITAR PERFIL</button>
                   </div>
                </div>
                <div class="buscacol">
                    <button class="" type="submit"><span class="ion-search"></span></button>
                    <input id="buscaColeccion" class="form-control" type="text" placeholder="BUSCA EN LAS ANOTACIONES... " aria-label="Search">
                </div-->
            </div>
<!--div>
        <a href="<%=pagerUrl+"?p="+currentPage+"&o=&f="+filter%>">normal</a>
        <a href="<%=pagerUrl+"?p="+currentPage+"&o="+AnnotationsMgr.ORDER_DATE+"&f="+filter%>">fecha</a>
</div-->
    <div id="anotaciones" class="misanotaciones">
<%  
        if (isAdmin) {
%>                 
            <h3 class="oswB vino"><span class="h3linea"></span><%=paramRequest.getLocaleString("lbl_title1")%><span class="h3linea"></span></h3>
<%  
        }else {
%> 
            <h3 class="oswB vino"><span class="h3linea"></span><%=paramRequest.getLocaleString("lbl_title2")%><span class="h3linea"></span></h3>
<%  
        }
%>                 
        <!--<div class="row anotacionesimg">-->                              
    <%
        for(Map<String,String> annotation:annotations) {
            String id=annotation.get("id");
            String autho = annotation.get("moderator");
            if (autho!=null && autho.trim().isEmpty()) autho=null;
            String classAutorizado = "";
            if (null != autho) classAutorizado=" autorizada";
    %>
                <div class="anotalista<%=classAutorizado%>">
                    <div class="anotalistaimg">
                        <img src="<%=annotation.get("bicThumbnail")%>">
                    </div>
                    <div class="anotalistainfo">  
                        <p class="anotacionp autoriza"><span class="ion-android-alert"></span>Autorización pendiente</p>
                        <p class="anotacionp fecha"><%=annotation.get("created")%></p>
                        <p class="anotacionp"><%=annotation.get("bicTitle")%></p>
                        <p class="anotacionp"><%=annotation.get("bicCreator")%></p>
                        <p class="">
                            <a href="<%=paramRequest.getWebPage().getUrl()%>?id=<%=annotation.get("id")%>" class="" ><%=paramRequest.getLocaleString("btn_see_more")%> <span class="ion-plus-circlVer anotacióned"></span></a>
                        </p>
                    </div>
                </div>                
    </div>
    <div class="container paginacion">
        <hr>
        <ul class="azul">
            <li><a href="<%=pagerUrl+"?p="+(currentPage>1?currentPage-1:1)%>"><i class="ion-ios-arrow-back" aria-hidden="true"></i></a></li>
            <%
                for (int i=1; i<=totalPages;i++) {
            %>        
                    <li><a href="<%=pagerUrl+"?p="+i%>" <%=currentPage==i?"class=\"select\"":""%>><%=i%></a></li>
            <%                
                }
            %>        
            <li><a href="<%=pagerUrl+"?p="+(currentPage<totalPages?currentPage+1:totalPages)%>"><i class="ion-ios-arrow-forward" aria-hidden="true"></i></a></li>
        </ul>
    </div>
    <!-- contenido -->
    </div>
    <button class="btn btn-rojo" onclick="window.location=document.referrer;return false;"><%=paramRequest.getLocaleString("btn_back")%></button>        
</section>
