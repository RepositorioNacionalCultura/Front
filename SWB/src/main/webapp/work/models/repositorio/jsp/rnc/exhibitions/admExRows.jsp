<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="mx.gob.cultura.portal.response.DigitalObject, mx.gob.cultura.portal.utils.ArtWork, mx.gob.cultura.portal.response.Entry, mx.gob.cultura.portal.response.Identifier, mx.gob.cultura.portal.response.Title, org.semanticwb.portal.api.SWBParamRequest, org.semanticwb.model.Resource"%>
<%@ page import="mx.gob.cultura.portal.utils.Utils, java.util.List" %>
<%@ page import="org.semanticwb.model.WebSite" %>
<%
    String mode = "card-columns";
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    WebSite site = paramRequest.getWebPage().getWebSite();
    //Resource base = (Resource) request.getAttribute("base");
    List<ArtWork> references = (List<ArtWork>) request.getAttribute("PAGE_LIST");
    Integer last = (Integer) request.getAttribute("LAST_RECORD");
    Integer first = (Integer) request.getAttribute("FIRST_RECORD");
    Integer total = (Integer) request.getAttribute("NUM_RECORDS_TOTAL");
    String userLang = paramRequest.getUser().getLanguage();
    if (null == first) first = 1;
    if (!references.isEmpty()) {
%>
<a name="showPage"></a>
<div id="references">
    <div class="ruta row">
        <div class="col-12 col-sm-8 col-md-8">
            <p class="oswLc"><%=first%>-<%=last%> de <%=total%> resultados</p>
        </div>
        <div class="col-12 col-sm-4 col-md-4 ordenar">
            <!--a href="#" onclick="setGrid();"><i class="fa fa-th select" aria-hidden="true"></i></a>
            <a href="#" onclick="setList();"><i class="fa fa-th-list" aria-hidden="true"></i></a-->
        </div>
    </div>
    <div id="resultados" class="<%=mode%>">
        <%
            for (ArtWork art : references) {
                Entry reference = art.getEntry();
                reference.setPosition(0);
                DigitalObject digital = new DigitalObject();
                List<DigitalObject> digitalobject = reference.getDigitalObject();
                if (!digitalobject.isEmpty()) digital = digitalobject.get(0);
		String title = Utils.getTitle(reference.getRecordtitle(), 0);
		String creator = Utils.getRowData(reference.getCreator(), 0, true);
                String holder = Utils.getRowHold(reference.getHolder(), 0, false);
        %>
                <div class="pieza-res card">
                    <a href="/<%=userLang%>/<%=site.getId()%>/detalle?id=<%=reference.getId()%>&n=<%=reference.getPosition()%>" target="_blank">
                        <img src="<%=digital.getUrl()%>" />
                    </a>
                    <div>
                        <p class="oswB azul tit"><a href="#"><%=title%></a></p>
                        <p class="azul autor"><a href="#"><%=creator%></a></p>
                        <p class="tipo"><%=holder%></p>
                    </div>
                </div>
        <%
            }
        %>
    </div>
    <jsp:include page="admExPager.jsp" flush="true"/>
</div>
<%
    }
%>