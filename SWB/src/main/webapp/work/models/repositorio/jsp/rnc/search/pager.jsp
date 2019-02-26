<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>    
<%@page import="mx.gob.cultura.portal.utils.Utils, mx.gob.cultura.portal.response.Entry,java.util.List, org.semanticwb.portal.api.SWBParamRequest"%>
<%
    int numBloque = 0;
    int ultimoBloque = 0;
    int paginaFinalBloque = 0;
    int paginaInicialBloque = 0;
    int primerRegistroMostrado = 0;
    int ultimoRegistroMostrado = 0;
    Integer totalPages = (Integer)request.getAttribute("TOTAL_PAGES");
    Integer totalPaginas = (Integer)request.getAttribute("TOTAL_PAGES");
    Integer paginaActual = (Integer)request.getAttribute("NUM_PAGE_LIST");
    Integer paginasPorBloque = (Integer)request.getAttribute("PAGE_JUMP_SIZE");
    Integer registrosPorPagina = (Integer)request.getAttribute("NUM_RECORDS_VISIBLE");
    Integer totalRegistros = (Integer)request.getAttribute("NUM_RECORDS_TOTAL");
    Integer last = (Integer)request.getAttribute("LAST_RECORD");
    Integer first = (Integer)request.getAttribute("FIRST_RECORD");
    if (null == paginaActual) paginaActual = 1;
    if (paginaActual != 0 && totalPaginas !=0 && totalRegistros != 0 && registrosPorPagina != 0) {
	numBloque = (paginaActual-1)/paginasPorBloque - (paginaActual-1)%paginasPorBloque/paginasPorBloque;
	ultimoBloque = (totalPaginas-1)/paginasPorBloque - (totalPaginas-1)%paginasPorBloque/paginasPorBloque;
	paginaInicialBloque = numBloque*paginasPorBloque+1;
	paginaFinalBloque = paginaInicialBloque+paginasPorBloque-1;
	primerRegistroMostrado = (paginaActual-1)*registrosPorPagina+1;
	ultimoRegistroMostrado = primerRegistroMostrado+registrosPorPagina-1;
	if (ultimoRegistroMostrado>totalRegistros) ultimoRegistroMostrado = totalRegistros;
	if (paginaFinalBloque>totalPaginas) paginaFinalBloque = totalPaginas;
    }
    SWBParamRequest paramRequest = (SWBParamRequest)request.getAttribute("paramRequest");
    String m = null != request.getAttribute("m") ? (String)request.getAttribute("m") : "g";
    String f = null != request.getAttribute("sort") ? (String)request.getAttribute("sort") : "relvdes";
    String fs = null != request.getAttribute("filters") ? (String)request.getAttribute("filters") : "";
%>
<div class="paginacion">
    <p><%=Utils.decimalFormat("###,###", first)%>-<%=Utils.decimalFormat("###,###", last)%> <%=paramRequest.getLocaleString("usrmsg_view_search_of")%> <%=Utils.decimalFormat("###,###", totalRegistros)%> <%=paramRequest.getLocaleString("usrmsg_view_search_results")%></p>
    <ul class="azul">
    <!-- liga para saltar al bloque anterior -->
    <%
	if (totalPages > 1) { //TODO: Check condition
            if (numBloque==0) {
    %>
		<!--li><a href="#"><i class="ion-ios-arrow-back" aria-hidden="true"></i><i class="ion-ios-arrow-back" aria-hidden="true"></i></a></li-->
    <%
            }else {
		int primeraPaginaBloqueAnterior = (numBloque-1)*paginasPorBloque+1;
    %>
		<li>
                    <a href="#" onclick="javascript:doPage(<%= primeraPaginaBloqueAnterior+",'"+m+"','"+f+"','"+fs %>')"><i class="ion-ios-arrow-back" aria-hidden="true"></i><i class="ion-ios-arrow-back" aria-hidden="true"></i></a>
                </li>
    <%
            }
	}
    %>
    <!-- numeraci�n de p�ginas a mostrar -->
    <%
        int index = paginaInicialBloque;
        if (numBloque==ultimoBloque && totalPages > paginasPorBloque) {
            out.println("<li><a href=\"#\" onclick=\"javascript:doPage("+1+",'"+m+"','"+f+"','"+fs+"')\">"+1+"</a></li>");
            out.println("<li><a href=\"#\">...</a></li>");
            index=paginaInicialBloque-paginasPorBloque > 2 ? paginaInicialBloque-(paginasPorBloque-2) : paginaInicialBloque;
	}
        for (int i=index; i <= paginaFinalBloque; i++) {
            if (i==paginaActual) {
                out.println("<li><a href=\"#\" class=\"select\">"+i+"</a></li>");
            }else {
                out.println("<li><a href=\"#\" onclick=\"javascript:doPage("+i+",'"+m+"','"+f+"','"+fs+"')\">"+i+"</a></li>");
            }
	}
    %>
    
    <!-- liga para saltar a la p�gina final -->
	
    <%
        if (totalPages > paginasPorBloque && paginaActual != totalPages) {
            out.println("<li><a href=\"#\">...</a></li>");
            out.println("<li><a href=\"#\" onclick=\"javascript:doPage("+totalPages+",'"+m+"','"+f+"','"+fs+"')\">"+totalPages+"</a></li>");
        }
    %>
        
	<!-- liga para saltar al bloque posterior -->
    <%
        if (totalPages > 1) {
	    if (numBloque==ultimoBloque || totalRegistros==0) {
    %>
                <!--li><a href="#"><i class="ion-ios-arrow-forward" aria-hidden="true"></i><i class="ion-ios-arrow-forward" aria-hidden="true"></i></a></li-->
    <%
            }else {
                int primeraPaginaBloqueSiguiente = (numBloque+1)*paginasPorBloque+1;
    %>
		<li>
                    <a href="#" onclick="javascript:doPage(<%=primeraPaginaBloqueSiguiente+",'"+m+"','"+f+"','"+fs %>')"><i class="ion-ios-arrow-forward" aria-hidden="true"></i><i class="ion-ios-arrow-forward" aria-hidden="true"></i></a>
                </li>
    <%
            }
        }
    %>
    </ul>
</div>
<!-- final �ndice de paginaci�n -->