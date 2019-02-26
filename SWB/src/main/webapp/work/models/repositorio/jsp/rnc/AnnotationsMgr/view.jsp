<%-- 
    Document   : view.jsp
    Created on : 24/07/2018, 10:51:22 PM
    Author     : rene.jara
--%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="mx.gob.cultura.portal.utils.Utils"%>
<%@page import="org.semanticwb.model.UserRepository"%>
<%@page import="mx.gob.cultura.portal.resources.AnnotationsMgr"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="mx.gob.cultura.portal.persist.AnnotationMgr"%>
<%@page import="mx.gob.cultura.portal.response.Annotation"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest" />
<%
    String userId = "";
    Map<String,String> annotation = (Map<String,String>) request.getAttribute("annotation");
    User user = paramRequest.getUser();
    boolean isAdmin=(boolean) request.getAttribute("isAdmin");
    boolean isAnnotator = (boolean)request.getAttribute("isAnnotator");
    if (user.isSigned()) userId=user.getId();  
    String siteid = paramRequest.getWebPage().getWebSiteId();
    String userlang = paramRequest.getUser().getLanguage();
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
    String scriptFB = Utils.getScriptFBShare(request);
%>
<%=scriptFB%>
<%
    if (!userId.isEmpty()&&(isAdmin||isAnnotator)){
%>

<script>
    function callAction(url,id){
        console.log("callAction"+id);
        $.getJSON(url,{'id':id}, function (data) { 
            console.log(data);
            if(data.deleted){
                $('#div_bodyValue').replaceWith('<div>Borrado </div>');
                waitBack;
            }else{
                updateActions(data);
            }  
        }).fail(function( jqxhr, textStatus, error ) {
            console.log(jqxhr);
            var err = textStatus + ", " + error;
            console.log( "Request Failed: " + err );
            alert(err);
        });
    }        
    
    function callUpdate(url,id,bodyValue){
        console.log("callUpdate"+id);
        $.getJSON(url,{'id':id,'bodyValue':bodyValue}, function (data) { 
            updateActions(data);
            updateDiv(data);
        }).fail(function( jqxhr, textStatus, error ) {
            var err = textStatus + ", " + error;
            console.log( "Request Failed: " + err );
            alert(err);
            //$("#dialog-message-tree").text(err);
            //$("#dialog-message-tree").dialog("open");
        });
    }
    
    function updateActions(element){
        console.log("updateActions"+element); 
        lContent ='';            
<%  
        if (isAdmin) {
%>              
        if (element.isOwn && element.isMod) {                   
            lContent += '<a href="#" onclick="editEnable();return false;" class="btn btn-blanco"><span class="ion-edit rojo"></span> <%=paramRequest.getLocaleString("btn_edit")%></a>';
            lContent += '<a href="#" onclick="callAction(\'<%=delURL.toString()%>\',\''+element.id+'\');return false;" class="btn btn-blanco"><span class="ion-edit rojo"></span> <%=paramRequest.getLocaleString("btn_del")%></a>'+
                        '<a href="#" onclick="callAction(\'<%=accURL.toString()%>\',\''+element.id+'\');return false;" class="btn btn-blanco"><span class="ion-edit rojo"></span> <%=paramRequest.getLocaleString("btn_acc")%></a>';                        
            liContent=lContent;
        }else {                  
            bvs=element.bodyValue;
            if (element.isMod) {                      
                lContent += '<a href="#" onclick="callAction(\'<%=accURL.toString()%>\',\''+element.id+'\');return false;" class="btn btn-blanco"><span class="ion-edit rojo"></span> <%=paramRequest.getLocaleString("btn_acc")%></a>';
            }else {                          
                lContent += '<a href="#" onclick="callAction(\'<%=rjcURL.toString()%>\',\''+element.id+'\');return false;" class="btn btn-blanco"><span class="ion-edit rojo"></span> <%=paramRequest.getLocaleString("btn_rjc")%></a>';
            }     
            liContent=lContent;
        }

<%
        }else {
%>        
            if (element.isMod) {
                lContent += '<a href="#" onclick="editEnable();return false;" class="btn btn-blanco"><span class="ion-edit rojo"></span> Editar anotación</a';
                lContent += '<a href="#" onclick="callAction(\'<%=delURL.toString()%>\',\''+element.id+'\');return false;" class="btn btn-blanco"><span class="ion-edit rojo"></span> <%=paramRequest.getLocaleString("btn_del")%></a>';
                liContent=lContent;
            }else { 
                bvs=element.bodyValue;
                liContent=lContent;
            }
<%  
        }
%>                    
        $('#div_actions').replaceWith('<div class="row redes" id="div_actions">'+liContent+'</div>');    
    }
    
    function updateDiv(element){
        console.log("updateDiv"+element); 
        lContent ='';                   
        if(element.isMod){
            bvs=element.bodyValue;
            if(bvs){            
                bva=bvs.split('\n');
                lContent +='<div id="bodyValueTar" class="d-none">'+
                            '<textarea id="bodyValue" rows="'+bva.length+'" cols="80" >'+
                            element.bodyValue+
                            '</textarea>'+
                            '<a href="#" onclick="callUpdate(\'<%=modURL.toString()%>\','+element.id+',$("#bodyValue").val());return false;" class="btn btn-blanco "><span class="ion-edit rojo"></span> <%=paramRequest.getLocaleString("btn_save")%></a>'+
                            '</div>';
                $('#bodyValueTar').replaceWith(lContent);
                console.log("bodyValueTar");
                lContent ='<div id="bodyValueTxt">';
                for (i=0;i<bva.length;i++){
                    lContent +='<p>'+bva[i]+'</p>';   
                }  
                lContent +='</div>';
                $('#bodyValueTxt').replaceWith(lContent);
                console.log("bodyValueTxt");
                //console.log(lContent);
            }
         
        }                           
    }
    
    function editEnable(){
        $('#bodyValueTar').removeClass('d-none');
        $('#bodyValueTxt').addClass('d-none');
    }
    function waitBack(){
        window.setTimeout(function(){window.location=document.referrer;},1500);
        
    }
    function back(){
        window.location=document.referrer;
        
    }
</script>         
<%
    }
    if (!annotation.isEmpty()) {
        String tmpphoto = "/work/models/"+siteid+"/img/usuario.jpg";
        if (null!=user.getPhoto() && user.getPhoto().trim().length()>0) tmpphoto = SWBPortal.getWebWorkPath()+user.getPhoto();
%>        
    
    <section id="contenidoInterna">
       <div class="container coleccionSecc anotaciondetalle">
                <div class="row">
                    <div class="col-3 col-sm-4 coleccionSecc-02">
                        <a href="/<%=userlang%>/<%=siteid%>/detalle?id=<%=annotation.get("oid")%>"><img src="<%=annotation.get("bicThumbnail")%>" /></a> 
                    </div>
                    <div class="col-9 col-sm-8 coleccionSecc-01">
                        <div class="precontent">
                            <h2 class="oswM rojo normalcase"><a href="/<%=userlang%>/<%=siteid%>/detalle?id=<%=annotation.get("oid")%>"><%=annotation.get("bicTitle")%></a></h2>
                            <p class="bold"><%=annotation.get("bicCreator")%></p>
                            <div class="row perfilHead">
                                <img src="<%=tmpphoto%>" class="circle">
                                <p><%=annotation.get("creator")%>, <%=annotation.get("creatorOrg")%> <br> <%=annotation.get("created")%></p>
                            </div>
                            <hr class="rojo">
                            <div class="row redes" id="div_actions">
                                <a href="#" onclick="fbShare();"><span class="ion-social-facebook"></span> <%=paramRequest.getLocaleString("btn_fb")%></a>
                                <script type="text/javascript">
                                    var url2Share = "https://twitter.com/intent/tweet?original_referer=" + encodeURIComponent(window.location) + "&url=" + encodeURIComponent(window.location);
                                </script>
                                <a href="#" _class="twitter-share-button" data-show-count="false" target="_new" onclick="window.open(url2Share,'', 'width=500,height=500'); return false;"><span class="ion-social-twitter"><%=paramRequest.getLocaleString("btn_tw")%></span></a>
<%      
        if (annotation.containsKey("isOwn")&&annotation.containsKey("isMod")) {   

%>       
            <a href="#" onclick="editEnable();return false;" class="btn btn-blanco "><span class="ion-edit rojo"></span> <%=paramRequest.getLocaleString("btn_edit")%></a>
            
<%
        }
%>                                
<%
        if (annotation.containsKey("isOwn")&&annotation.containsKey("isMod")) {
%>         
             <a href="#" onclick="callAction('<%=delURL.toString()%>','<%=annotation.get("id")%>');return false;" class="btn btn-blanco "><span class="ion-trash-a rojo"></span> <%=paramRequest.getLocaleString("btn_del")%></a>
<%      
        } 
        if (isAdmin) {
            if (annotation.containsKey("isMod")) {

%>         
                <a href="#" onclick="callAction('<%=accURL.toString()%>','<%=annotation.get("id")%>');return false;" class="btn btn-blanco" ><span class="ion-checkmark-round rojo"></span> <%=paramRequest.getLocaleString("btn_acc")%></a>             
<%
            }else{
%>         
                <a href="#" onclick="callAction('<%=rjcURL.toString()%>','<%=annotation.get("id")%>');return false;" class="btn btn-blanco"><span class="ion-close-round rojo"></span> <%=paramRequest.getLocaleString("btn_rjc")%></a>
<%
            }
        }
%>                                             
                            </div>
                        </div>
                    </div>                    
                </div>
            </div>
        <div class="espacioTop"></div>
        <div class="container" id="div_bodyValue" >
<%            
            String[] bvs=annotation.get("bodyValue").split("\n");
            
        if (annotation.containsKey("isOwn")&&annotation.containsKey("isMod")){
%>         
            <div id="bodyValueTar" class="d-none">
                <textarea id="bodyValue" rows="<%=bvs.length%>" cols="80" ><%=annotation.get("bodyValue")%></textarea>
                <a href="#" onclick="callUpdate('<%=modURL.toString()%>','<%=annotation.get("id")%>',$('#bodyValue').val());return false;" class="btn btn-blanco "><span class="ion-edit rojo"></span> <%=paramRequest.getLocaleString("btn_save")%></a>
            </div>    
<%      
        }
%>         
        <div id="bodyValueTxt" >
<%
            for(int i =0; i < bvs.length;i++){
%>                        
                <p><%=bvs[i]%></p>                       
<%
            } 
%>
        </div>
            <button class="btn btn-rojo" onclick="window.location=document.referrer;return false;"><%=paramRequest.getLocaleString("btn_back")%></button>
        </div>
    </section>
<%
    }
%>                    
