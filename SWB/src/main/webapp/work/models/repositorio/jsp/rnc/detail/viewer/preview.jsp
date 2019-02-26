<%--
    Document   : preview.jsp
    Created on : 5/12/2017, 11:48:36 AM
    Author     : sergio.tellez
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mx.gob.cultura.portal.utils.Utils, mx.gob.cultura.portal.response.DateDocument, mx.gob.cultura.portal.response.DigitalObject"%>
<%@ page import="mx.gob.cultura.portal.resources.ArtDetail, mx.gob.cultura.portal.response.Entry, mx.gob.cultura.portal.response.Title, org.semanticwb.model.WebSite, org.semanticwb.portal.api.SWBParamRequest, org.semanticwb.portal.api.SWBResourceURL, java.util.ArrayList, java.util.List"%>
<script type="text/javascript" src="/swbadmin/js/rnc/detail.js"></script>
<script type="text/javascript" src="/swbadmin/js/dojo/dojo/dojo.js" djConfig="parseOnLoad: true, isDebug: false, locale: 'en'"></script>
<%
    int iDigit = 1;
    int images = 0;
    String title = "";
    String creator = "";
    DigitalObject digital = null;
    StringBuilder divVisor = new StringBuilder();
    List<DigitalObject> digitalobjects = new ArrayList<>();
    Entry entry = null != request.getAttribute("entry") ? (Entry) request.getAttribute("entry") : new Entry();
    Integer r = null != request.getParameter("r") ? Utils.toInt(request.getParameter("r")) : 0;
    String w = null != request.getParameter("word") ? request.getParameter("word") : "";
    SWBParamRequest paramRequest = (SWBParamRequest)request.getAttribute("paramRequest");
    WebSite site = paramRequest.getWebPage().getWebSite();
    String userLang = paramRequest.getUser().getLanguage();
    SWBResourceURL digitURL = paramRequest.getRenderUrl().setMode("DIGITAL");
    digitURL.setCallMethod(SWBParamRequest.Call_DIRECT);
    Integer t = null != request.getAttribute("t") ? (Integer)request.getAttribute("t") : 0;
    String fs = null != request.getAttribute("filter") ? "&filter="+request.getAttribute("filter") : "";
    if (null != entry) {
        if (null != entry.getDigitalObject()) {
            int n = 0;
            digitalobjects = entry.getDigitalObject();
            creator = Utils.getCreator(entry.getCreator());
            title = Utils.getTitle(entry.getRecordtitle(), 0);
            images = null != digitalobjects ? digitalobjects.size() : 0;
            digital = images >= iDigit ? digitalobjects.get(iDigit-1) : new DigitalObject();
            if (null == digital.getUrl()) digital.setUrl("");
            divVisor.append("<div class=\"tablaVisualizaCont\">")
                .append("	<div class=\"container\">")
                .append("		<h3 class=\"oswM\">").append(title).append("</h3>")
                .append("		<p class=\"oswL\">").append(creator).append("</p>")
                .append("		<div class=\"tablaVisualizaTab\">")
                .append("			<table>")
                .append("				<tr>");
            if (!entry.getDigitalObject().isEmpty()) {
                divVisor.append("		<th style=\"text-align:left; width:60%;\">")
                    .append("				Nombre")
                    .append("			</th>")
                    .append("			<th style=\"text-align:left;\">")
                    .append("				Formato")
                    .append("			</th>")
                    .append("			<th style=\"text-align:left;\">")
                    .append("				Enlace")
                    .append("			</th>");
            }else
            divVisor.append("		<th>").append(paramRequest.getLocaleString("usrmsg_view_detail_empty_object")).append("</th>");
            divVisor.append("				</tr>");
            for (DigitalObject ob : digitalobjects) {
                String mime = null != ob.getMediatype() ? ob.getMediatype().getMime() : "";
                String name = null != ob.getMediatype().getName() ? ob.getMediatype().getName() : paramRequest.getLocaleString("usrmsg_view_detail_file_name");
                String action = mime.equalsIgnoreCase("wav") || mime.equalsIgnoreCase("mp3") || mime.startsWith("audio/mpeg") ? "Escuchar" : "Ver";
                divVisor.append("		<tr>")
                    .append("					<td style=\"text-align:left; width:60%;\">")
                    .append(name)
                    .append("					</td>")
                    .append("					<td style=\"text-align:left;\">")
                    .append(ob.getMediatype().getMime())
                    .append("					</td>")
                    .append("					<td style=\"text-align:left;\">");
                if (mime.equalsIgnoreCase("web")) {
                    divVisor.append("<a href='").append(ob.getUrl()).append("' target='_blank'>").append(action).append("</a>");
                }else if (ob.getUrl().endsWith(".tiff") || ob.getUrl().endsWith(".avi") || ob.getUrl().endsWith(".zip") || 	ob.getUrl().endsWith(".rtf") || ob.getUrl().endsWith(".docx") || ob.getUrl().endsWith(".aiff")) {
                    action = "Descargar";
                    divVisor.append("<a href='").append(ob.getUrl()).append("'>").append(action).append("</a>");
                }else {
                    divVisor.append("<a href=\"/").append(userLang).append("/")	.append(site.getId()).append("/").append("detalle?id=").append(entry.getId()).append("&n=").append(n).append("&r=").append(r).append("&word=").append(w).append("&t=").append(t).append(fs).append("\">").append(action).append("</a>");
                }
                divVisor.append("					</td>")
                    .append("				</tr>");
                n++;
            }
            divVisor.append("			</table>")
                .append("		</div>")
                .append("	</div>")
                .append("</div>");
        }
    }
%>
<section id="detalle">
    <div id="idetail" class="detalleimg">
        <jsp:include page="../flow.jsp" flush="true"/>
        <div class="explora">
            <jsp:include page="../share.jsp" flush="true"/>
	 </div>
            <%=divVisor%>
    </div>
</section>
<section id="detalleinfo">
    <div class="container">
        <div class="row">              
            <jsp:include page="../rack.jsp" flush="true"/>
            <jsp:include page="../techdata.jsp" flush="true"/>
        </div>
    </div>
</section>
<section id="palabras">
    <div class="container">
        <div class="row">
            <jsp:include page="../keywords.jsp" flush="true"/>
	</div>
    </div>
</section>
<div id="dialog-message-tree" title="error">
    <p>
        <div id="dialog-text-tree"></div>
    </p>
</div>
<div id="dialog-success-tree" title="éxito">
    <p>
        <span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
	<div id="dialog-msg-tree"></div>
    </p>
</div>

<div id="addCollection">
	<p>
		<div id="addCollection-tree"></div>
	</p>
</div>

<div class="modal fade" id="newCollection" tabindex="-1" role="dialog" aria-labelledby="modalTitle" aria-hidden="true"></div>