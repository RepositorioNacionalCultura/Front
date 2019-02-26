<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.model.User"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.semanticwb.model.User, mx.gob.cultura.portal.utils.Utils, org.semanticwb.SWBPortal, java.util.List, org.semanticwb.model.WebSite, org.semanticwb.portal.api.SWBParamRequest, mx.gob.cultura.portal.resources.MyCollections, org.semanticwb.portal.api.SWBResourceURL, org.semanticwb.model.WebPage" %>
<%@ page import="mx.gob.cultura.portal.response.Title, mx.gob.cultura.portal.response.Collection, mx.gob.cultura.portal.response.DigitalObject, mx.gob.cultura.portal.response.Entry, mx.gob.cultura.portal.response.Identifier, java.util.Date, org.bson.types.ObjectId"%>
<%
    Collection c = (Collection)request.getAttribute("collection");
    List<Entry> itemsList = (List<Entry>)request.getAttribute("myelements");
    SWBParamRequest paramRequest = (SWBParamRequest)request.getAttribute("paramRequest");
    WebSite site = paramRequest.getWebPage().getWebSite();
    String userLang = paramRequest.getUser().getLanguage();
    SWBResourceURL uedt = paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_EDIT);
    uedt.setCallMethod(SWBParamRequest.Call_DIRECT);
    //SWBResourceURL uels = paramRequest.getRenderUrl().setMode(MyCollections.MODE_VIEW_USR);
    WebPage wpdetail = site.getWebPage("Detalle_coleccion");
    String uels = wpdetail.getUrl();
   
    WebPage detail = site.getWebPage("detalle");
    String uri = detail.getRealUrl(paramRequest.getUser().getLanguage());
    
    SWBResourceURL delURL = paramRequest.getActionUrl();
    delURL.setMode(SWBResourceURL.Mode_VIEW);
    delURL.setAction(MyCollections.ACTION_DEL_FAV);
    
    SWBResourceURL clfURL = paramRequest.getActionUrl();
    clfURL.setMode(SWBResourceURL.Mode_VIEW);
    clfURL.setAction(MyCollections.ACTION_ADD_CLF);

    String userid = c.getUserid();
    String scriptFB = Utils.scriptFBCln(request);
    User usr = site.getUserRepository().getUser(userid);
    Integer favs = null != c.getFavorites() ? c.getFavorites() : 0;
    String username = null != c.getUserName() && !c.getUserName().trim().isEmpty() ? c.getUserName():"Anónimo";
    boolean back = null != request.getParameter("p");
    String _msg = null != request.getParameter("_msg") && "2".equals(request.getParameter("_msg")) ? "Se actualizó correctamente en su colección." : "";
%>
<script type="text/javascript" src="/swbadmin/js/rnc/detail.js"></script>
<%=scriptFB%>
<script>
    $(document).ready(function () {
        $("#alertSuccess").on('hidden.bs.modal', function () {
            window.location.replace('<%=uels%>?id=<%=c.getId()%>&_msg=2');
        });
    });
</script>
<script>
    function editByForm(id) {
	var xhttp = new XMLHttpRequest();
	var url = '<%=uedt%>'+'?id='+id;
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                jQuery("#editCollection").html(this.responseText);
		$('#editCollection').modal('show');
            }
	};
        xhttp.open("POST", url, true);
	xhttp.send();
    }
    function saveEdit(uri) {
        if (validateEdit()) {
            dojo.xhrPost({
                url: uri,
		form:'saveCollForm',
                sync: true,
		timeout:180000,
                load: function(data) {
                    var res = dojo.fromJson(data);
                    if (null != res.id) {
                        $('#editCollection').modal('hide');
			jQuery("#dialog-text").text("Se actualizó correctamente en su colección.");
                        $('#alertSuccess').modal('show');
			window.location.replace('<%=uels%>?id='+res.id+'&_msg=2');
                    }else {
                        jQuery("#dialog-msg-edit").text("Ya tiene una colección con éste nombre.");
                    }
		}
            });
	}
    }
    function validateEdit() {
        if (document.forms.saveCollForm.title.value === '') {
            jQuery("#dialog-msg-edit").text("Favor de proporcionar nombre de colección.");
            return false;
	}
        return true;
    }
    function del(id,entry) {
        var xhttp = new XMLHttpRequest();
	var url = '<%=delURL%>'+'?id='+id+'&entry='+entry;
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                jQuery("#dialog-text").text("Se actualizó correctamente en su colección.");
		$('#alertSuccess').modal('show');
            }
	};
        xhttp.open("POST", url, true);
        xhttp.send();
    }
    function add(id) {
	dojo.xhrPost({
            url: '<%=clfURL%>?id='+id,
            load: function(data) {
                var res = dojo.fromJson(data);
		if (null != res.id) {
                    dojo.byId('favs').innerHTML="<span class='ion-heart rojo'></span> Favoritos ("+res.favorites+")</a></div>";
		}else {
                    share('fv', 'true', '/<%=userLang%>/<%=site.getId()%>/Registro');
		}
            }
        });
    }
</script>
<div class="container miscolec">
    <div class="regresar">
        <% if (back) { %>
            <button class="btn btn-rojo" onclick="javascript:history.go(-1)">
                <span class="ion-chevron-left"></span>Regresar
            </button>
        <% } %>
    </div>
</div>
<div class="container coleccionSecc">
    <div class="row">
        <div class="col-9 col-sm-8 coleccionSecc-01">
            <div class="precontent">
                <h2 class="oswM rojo"><%=c.getTitle()%></h2>
                <div class="row perfilHead">
                    <% 
                        if (null != usr && null != usr.getPhoto()) { %>
                        <img src="<%=SWBPortal.getWebWorkPath()+usr.getPhoto()%>" class="circle">
                    <% } else {%>
                        <img src="/work/models/<%=site.getId()%>/img/agregado-07.jpg" class="circle">
                    <% } %>
                    <p><%=username%>,&nbsp;&nbsp;<div id="fdate"></div></p>

                </div>
                <p><%=_msg%></p>
                <p><%=c.getDescription()%></p>
                <hr class="rojo">
                <div class="row redes">
                    <a href="#" onclick="share('fb', '<%=c.getStatus()%>', 'id=<%=c.getId()%>');"><span class="ion-social-facebook"></span> Compartir</a>
                    <a href="#"  _class="twitter-share-button" data-show-count="false" onclick="share('tw', '<%=c.getStatus()%>', '<%=site.getModelProperty("host_media")+paramRequest.getWebPage().getUrl()+"?id="%><%=c.getId()%>');"><span class="ion-social-twitter"></span> Tweet</a>
                    <a href="#" onclick="add('<%=c.getId()%>');" class="rojo"><div id="favs"><span class="ion-heart rojo"></span> Favoritos (<%=favs%>)</a></div>
                </div>
                <%
                    if (itemsList.isEmpty()) {
		%>
                        <div class="contactabloque imgColabora radius-overflow margen0 sinsombra">  
                            <div class="contactabloque-in ">
                                <p class="oswM">Busca obras de tu interés<br>
                                    y agrégalas a tus colecciones</p>
				<button class="btn-cultura btn-rojo" onclick="javascript:location.replace('/<%=userLang%>/<%=site.getId()%>/explorar');" type="button">EXPLORAR <span class="ion-chevron-right"></span></button>
                            </div>
			</div>
                <% } %>
            </div>
        </div>
        <div class="col-3 col-sm-4 coleccionSecc-02">
            <%  if (paramRequest.getUser().isSigned() && paramRequest.getUser().getId().equalsIgnoreCase(c.getUserid())) { %>
                    <button type="button" onclick="editByForm('<%=c.getId()%>');" class="btn-cultura btn-blanco btn-mayus d-none d-md-block"><span class="ion-edit"></span> Editar colección</button>
            <%  }  %>
            <button type="submit" class="btn-cultura btn-blanco btn-mayus d-block d-md-none"> <span class="ion-edit"></span> Editar</button>
        </div>
    </div>
</div>
<%
    if (!itemsList.isEmpty()) {
%>
    <div class="container">
	<div class="row">
            <div>
                <div id="references">
                    <div id="resultados" class="card-columns">
                        <%
                            for (Entry item : itemsList) {
                                List<String> resourcetype = item.getResourcetype();
                                String title = Utils.replaceSpecialChars(Utils.getTitle(item.getRecordtitle(), 0));
                                String creator = Utils.getRowData(item.getCreator(), 0, false);
                                String type = null != resourcetype && resourcetype.size() > 0 ? resourcetype.get(0) : "";
                        %>
                        <div class="pieza-res card">
                            <a href="<%=uri%>?id=<%=item.getId()%>">
                                <img src="<%=item.getResourcethumbnail()%>" />
                            </a>
                            <div>
                                <p class="oswB azul tit"><a href="<%=uri%>?id=<%=item.getId()%>"><%=title%></a></p>
                                <p class="azul autor"><a href="#"><%=creator%></a></p>
                                <p class="tipo"><%=type%></p>
                                <% if (null != paramRequest.getUser() && paramRequest.getUser().isSigned() && paramRequest.getUser().getId().equalsIgnoreCase(c.getUserid())) {%>
                                    <a href="#" onclick="del('<%=c.getId()%>', '<%=item.getId()%>')"><span class="ion-trash-a"></span></a>
                                <% } %>
                            </div>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--resultados -->
    <div class="coleccionSecc-03 col-12 col-md-8 col-lg-6">
        <div class="agregarColecc ">
            <a href="#" onclick="javascript:location.replace('/<%=userLang%>/<%=site.getId()%>/explorar');">
                <span class="ion-ios-plus"></span>
                <em class="oswM">Agregar  desde la colección</em>
                <span class="btn-cultura">Explorar <span class="ion-chevron-right"></span></span>
            </a>
            <div>
                <img src="/work/models/<%=site.getId()%>/img/cabecera-carranza.jpg">
            </div>
        </div>
    </div>
<%
    } else {
%>
    <div class="coleccionSecc-03 col-12 col-md-8 col-lg-6"></div>
<%
    }
%>
<script>
    var d = new Date("<%=c.getDate()%>");
    var months = ["ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"];
    document.getElementById("fdate").innerHTML = d.getDate() + " DE " + months[d.getMonth()] + " DE " + d.getFullYear();
</script>

<div class="modal fade" id="editCollection" tabindex="-1" role="dialog" aria-labelledby="modalTitle" aria-hidden="true"></div>

<div class="modal fade" id="alertSuccess" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Éxito</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <div id="dialog-text"></div>
            </div>
            <div class="modal-footer">
                <button type="button" id="closeAlert" class="btn btn-sm rojo" data-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="alertShare" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Importante</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <div id="dialog-share"></div>
            </div>
            <div class="modal-footer">
                <button type="button" id="closeAlert" class="btn btn-sm rojo" data-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>