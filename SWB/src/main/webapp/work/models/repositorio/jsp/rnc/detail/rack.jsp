<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="mx.gob.cultura.portal.utils.Utils, mx.gob.cultura.portal.response.Entry, mx.gob.cultura.portal.response.Title, mx.gob.cultura.portal.resources.SearchCulturalProperty, mx.gob.cultura.portal.response.Entry"%>
<%@page import="org.semanticwb.model.WebSite, org.semanticwb.portal.api.SWBParamRequest,org.semanticwb.portal.api.SWBResourceURL,java.util.ArrayList,java.util.List"%>
<%
        List<Entry> c = (List<Entry>)request.getAttribute("collection");
	SWBParamRequest paramRequest = (SWBParamRequest)request.getAttribute("paramRequest");
	WebSite site = paramRequest.getWebPage().getWebSite();
	String userLang = paramRequest.getUser().getLanguage();
	Entry entry = (Entry)request.getAttribute("entry");
	String rackuri = "javascript:location.replace('/"+paramRequest.getUser().getLanguage()+"/"+paramRequest.getWebPage().getWebSiteId()+"/resultados?word=";
	if (null != entry && null != entry.getCollection() && !entry.getCollection().isEmpty()) {
		rackuri += entry.getCollection().get(0);
	}
	rackuri += "')";
%>
<div class="col-12 col-sm-6  col-md-3 col-lg-3 order-md-1 order-sm-2 order-2 mascoleccion">
    <div>
	<p class="tit2"><%=paramRequest.getLocaleString("usrmsg_view_detail_more_collection")%></p>
	<%  if (null != c && !c.isEmpty()) {
                int i = 0;
		for (Entry book : c)  {
                    String title = Utils.getTitle(book.getRecordtitle(), 50);
                    String holder = Utils.getRowData(book.getHolder(), 0, false);
                    String creator = Utils.getRowData(book.getCreator(), 0, true);
                    SearchCulturalProperty.setThumbnail(book, site, 0);
                    if (null == book.getResourcethumbnail()) book.setResourcethumbnail("/work/models/" + site.getId() + "/img/no-multimedia.png");
	%>
                    <div>
                        <a href="/<%=userLang%>/<%=site.getId()%>/detalle?id=<%=book.getId()%>&n=0">
                            <img src=<%=book.getResourcethumbnail()%> class="img-responsive">
                        </a>
			<p></p>
			<p class="tit"><%=title%></p>
			<p class="autor"><%=creator%></p>
			<p class="tipo"><%=holder%></p>
                    </div><hr>
	<% 
                    if (i>0) break;
                        i++;
		}
            }
	%>
	<p class="vermas"><a href="#" onclick="<%=rackuri%>"><%=paramRequest.getLocaleString("usrmsg_view_detail_show_more")%> <span class="ion-plus-circled"></span></a></p>
    </div>
</div>