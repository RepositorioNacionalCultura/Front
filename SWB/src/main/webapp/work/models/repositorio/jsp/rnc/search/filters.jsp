<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Map, mx.gob.cultura.portal.response.Aggregation, mx.gob.cultura.portal.response.CountName"%>
<%@page import="mx.gob.cultura.portal.utils.Utils, mx.gob.cultura.portal.utils.Constants, org.semanticwb.portal.api.SWBParamRequest,org.semanticwb.portal.api.SWBResourceURL,java.util.ArrayList, java.util.List"%>
<%
    boolean showFilters = false;
    List<CountName> dates = new ArrayList<>();
    List<CountName> rights = new ArrayList<>();
    List<CountName> holders = new ArrayList<>();
    List<CountName> languages = new ArrayList<>();
    List<CountName> mediastype = new ArrayList<>();
    List<CountName> rightsmedia = new ArrayList<>();
    List<CountName> resourcetypes = new ArrayList<>();
    String word = (String)request.getAttribute("word");
    String texts = Utils.getFilterTypes(request, "text");
    String zips = Utils.getFilterTypes(request, "zip");
    String images = Utils.getFilterTypes(request, "image");
    String audios = Utils.getFilterTypes(request, "audio");
    String videos = Utils.getFilterTypes(request, "video");
    String three = Utils.getFilterTypes(request, "3d");
    String map = Utils.getFilterTypes(request, "map");
    String tech = Utils.getFilterTypes(request, "mix");
    String media = Utils.getFilterTypes(request, "multimedia");
    String files = Utils.getFilterTypes(request, "files");
    Aggregation aggs = (Aggregation)request.getAttribute("aggs");
    SWBParamRequest paramRequest = (SWBParamRequest)request.getAttribute("paramRequest");
    if (null != aggs) {
        showFilters = true;
	if (null !=  aggs.getDates()) dates = aggs.getDates();
	if (null !=  aggs.getRights()) rights = aggs.getRights();
        if (null !=  aggs.getHolders()) holders = aggs.getHolders();
        if (null !=  aggs.getLanguages()) languages = aggs.getLanguages();
	if (null !=  aggs.getMediastype()) mediastype = aggs.getMediastype();
        if (null !=  aggs.getRightsmedia()) rightsmedia = aggs.getRightsmedia();
        if (null !=  aggs.getResourcetypes()) resourcetypes = aggs.getResourcetypes();
    }
    SWBResourceURL pageURL = paramRequest.getRenderUrl().setMode("SORT");
    pageURL.setCallMethod(SWBParamRequest.Call_DIRECT);
    int lower = null != aggs ? aggs.getInterval().getLowerLimit() : 0;
    int upper = null != aggs ? aggs.getInterval().getUpperLimit() : 0;
    String attFilter = null != request.getAttribute("filters") ? (String)request.getAttribute("filters") : "";
    String filters = null != request.getParameter("filter") ? request.getParameter("filter") : attFilter.replaceFirst("&filter=", "");
    Map<String, List<CountName>> facets = (Map<String, List<CountName>>)request.getAttribute("facets");
%>
<script type="text/javascript">
    var filterDate = false;
    function sort(f) {
        doSort('<%=word%>',f.value);
    }
    function reset() {
        filterDate = false;
        var inputElements = document.getElementsByClassName('form-check-input');
	for (i=0; i<inputElements.length; i++) {
            inputElements[i].checked = false;
	}
        document.getElementById("bx1").value = <%=lower%>;
	document.getElementById("bx2").value = <%=upper%>;
	document.getElementById("ex1SliderVal").textContent = document.getElementById("bx1").value;
        document.getElementById("ex2SliderVal").textContent = document.getElementById("bx2").value;
        doSort('<%=word%>','imptdes');
    }
    <%=Utils.getFilter(facets, word)%>
    function selectAll(type) {
	var inputElements = document.getElementsByName(type.value);
	for (i=0; i<inputElements.length; i++) {
            inputElements[i].checked = type.checked;
	}
        filter();
    }
    function validate(ele, min, max) {
        var val = ele.value;
	if (!val.match(/^\d+$/)) {
            document.getElementById("bx1").value = min
            document.getElementById("bx2").value = max
            alert('<%=paramRequest.getLocaleString("usrmsg_view_search_year_digit_error")%>');
	}
        if (val < min) {
            ele.focus();
            alert('<%=paramRequest.getLocaleString("usrmsg_view_search_year_min_error")%> ' + min);
	}
        if (val > max) {
            ele.focus();
            alert('<%=paramRequest.getLocaleString("usrmsg_view_search_year_max_error")%> ' + max);
	}
        if (ele.name == 'bx1' && validateRange(document.getElementById("bx1").value, document.getElementById("bx2").value)) {
            document.getElementById("ex1SliderVal").textContent = document.getElementById("bx1").value;
            filterDate = true;
            filter();
	}
	if (ele.name == 'bx2' && validateRange(document.getElementById("bx1").value, document.getElementById("bx2").value)) {
            filterDate = true;
            document.getElementById("ex2SliderVal").textContent = document.getElementById("bx2").value;
            filter();
	}
    }
    function validateRange(min, max) {
        if (min > max) {
            alert('<%=paramRequest.getLocaleString("usrmsg_view_search_range_min_error")%>');
		return false;
            }
            if (max < min) {
		alert('<%=paramRequest.getLocaleString("usrmsg_view_search_range_max_error")%>');
                return false;
            }
	return true;
    }
    function moveSlide(sliderValue) {
        var str = sliderValue + "";
	var res = str.split(',');
	document.getElementById("bx1").value = res[0];
        document.getElementById("bx2").value = res[1];
	document.getElementById("ex1SliderVal").textContent = res[0];
        document.getElementById("ex2SliderVal").textContent = res[1];
	filterDate = true;
	return filterDate;
    }
    function doSort(w, f) {
        dojo.xhrPost({
            url: '<%=pageURL%>?word='+w+'&sort='+f,
            load: function(data) {
                dojo.byId('references').innerHTML=data;
                setBounds();
            }
        });
    }
    function setBounds() {
	var slider = new Slider('#ex1', {});
	slider.on("slide", function(sliderValue) {
            var str = sliderValue + "";
            var res = str.split(',');
            document.getElementById("bx1").value = res[0];
            document.getElementById("bx2").value = res[1];
            document.getElementById("ex1SliderVal").textContent = res[0];
            document.getElementById("ex2SliderVal").textContent = res[1];
	});
        slider.on("slideStop", function(sliderValue) {
            if (moveSlide(sliderValue))
		filter();
        });
    }
</script>
<div id="sidebar">
    <div id="accordionx" role="tablist">
        
    <% 
        out.println(Utils.getFacet(facets, filters, "es", paramRequest.getLocaleString("usrmsg_view_search_select_all"), paramRequest.getLocaleString("usrmsg_view_search_show_more"), paramRequest.getLocaleString("usrmsg_view_search_show_less")));
    %>

    <%  if (!dates.isEmpty()) { %>
            <div class="card card-fecha">
                <div class="" role="tab" id="heading3">
                    <a data-toggle="collapse" href="#collapse3" aria-expanded="true" aria-controls="collapse3" class="btnUpDown collapsed"><%=paramRequest.getLocaleString("usrmsg_view_search_date")%> <span class="mas ion-plus"></span><span class="menos ion-minus"></span></a>
                </div>
                <div id="collapse3" class="collapse show" role="tabpanel" aria-labelledby="heading3" data-parent="#accordion">
                    <div class="slider">  
                        <p class="oswM">[ <input id="bx1" type="text" class="sliderinput oswB rojo" onchange="validate(this, <%=aggs.getInterval().getLowerLimit() %>, <%=aggs.getInterval().getUpperLimit()%>);" value="<%=Utils.getIvl(request.getParameter("filter"), "datestart", aggs) %>" /> - <input id="bx2" name="bx2" type="text" class="sliderinput oswB rojo"  onchange="validate(this, <%=aggs.getInterval().getLowerLimit() %>, <%=aggs.getInterval().getUpperLimit()%>);" value="<%=Utils.getIvl(request.getParameter("filter"), "dateend", aggs) %>" /> ]</p>               
                        <input id="ex1" data-slider-id='ex1Slider' type="text" data-slider-min="<%=aggs.getInterval().getLowerLimit() %>" data-slider-max="<%=aggs.getInterval().getUpperLimit() %>" data-slider-step="1" data-slider-value="[<%=aggs.getInterval().getLowerLimit() %>,<%=aggs.getInterval().getUpperLimit() %>]"/>
                        <div class="d-flex">
                            <div class="p-2" id="ex1SliderVal"><%=aggs.getInterval().getLowerLimit() %></div>
                            <div class="ml-auto p-2" id="ex2SliderVal"><%=aggs.getInterval().getUpperLimit() %></div>
                        </div>
                    </div>
                </div>
            </div>		
    <%  } %>

    <%	if (null != languages && !languages.isEmpty()) { %>
        <div class="card">
            <div class="" role="tab" id="heading5">
                <a data-toggle="collapse" href="#collapse5" aria-expanded="false" aria-controls="collapse5" class="btnUpDown collapsed"><%=paramRequest.getLocaleString("usrmsg_view_search_languages")%> <span class="mas ion-plus"></span><span class="menos ion-minus"></span></a>
            </div>
            <div id="collapse5" class="collapse" role="tabpanel" aria-labelledby="heading5" data-parent="#accordion">
                <ul>
                    <li>
                        <ul>
                            <%
                                int i = 0;
                                for (CountName r : languages) {
                                    if (r.getName().equalsIgnoreCase("es")) continue;
                                    if (null != r.getName() && !r.getName().equalsIgnoreCase("es")) {
                            %>
					<li><label class="form-check-label"><input class="form-check-input" type="checkbox" onclick="filter()" name="languages" value="<%=r.getName()%>" <% if (Utils.chdFtr(filters, "lang", r.getName())) out.print("checked"); %>><span><%=r.getName()%></span><span> <%=Utils.decimalFormat("###,###", r.getCount())%></span><span class="checkmark"></span></label></li>
                            <%      
                                        if (i>3) break; else i++; 
                                    }
				}
                                if (i<languages.size()) {
                            %>
                                    <div class="collapse" id="morelangs">
                            <%
                                        int j=0;
                                        for (CountName r : languages) {
                                            if (null != r.getName() && !r.getName().equalsIgnoreCase("es")) {
                                                if (j<=i) {j++;} 
                                                else { 
                            %>
                                                    <li><label class="form-check-label"><input class="form-check-input" type="checkbox" onclick="filter()" name="languages" value="<%=r.getName()%>" <% if (Utils.chdFtr(filters, "lang", r.getName())) out.print("checked"); %>><span><%=r.getName()%></span><span> <%=Utils.decimalFormat("###,###", r.getCount())%></span><span class="checkmark"></span></label></li>
                            <%			
                                                }
                                            }
                                        }
                            %>
                                    </div>
                            <%  }  %>
                            <li><label class="form-check-label"><input class="form-check-input" type="checkbox" onclick="selectAll(this)" name="allanguages" value="languages"><span><%=paramRequest.getLocaleString("usrmsg_view_search_select_all")%></span><span> </span><span class="checkmark"></span></label></li>
                        </ul>
                        <%  if (languages.size() > 5) { %>
                                <p class="vermas-filtros">
                                    <button class="btn-vermas" type="button" data-toggle="collapse" data-target="#morelangs" aria-expanded="false" aria-controls="morelangs">
                                        <span class="ion-plus-circled"><span><%=paramRequest.getLocaleString("usrmsg_view_search_show_more")%></span></span>
                                        <span class="ion-minus-circled"><span><%=paramRequest.getLocaleString("usrmsg_view_search_show_less")%></span></span> 
                                    </button>
				</p>
			<%  } %>
                    </li>
                </ul>
            </div>
        </div>
    <%  } %>

    <%
        if (showFilters) {
    %>
            <div class="card cardfecha">
                <div class="form-group">
                    <label for="selfecha"><%=paramRequest.getLocaleString("usrmsg_view_search_order_by")%>:</label>
                    <select class="form-control" id="selfecha" onchange="sort(this)">
                        <option value="datedes" <% if (Utils.chdFtr(request.getParameter("sort"), "selfecha", "datedes")) out.print("selected"); %>><%=paramRequest.getLocaleString("usrmsg_view_search_date")%></option>
			<option value="relvdes" <% if (Utils.chdFtr(request.getParameter("sort"), "selfecha", "datedes")) out.print("selected"); %>><%=paramRequest.getLocaleString("usrmsg_view_search_relevance")%></option>
                        <option value="statdes" <% if (Utils.chdFtr(request.getParameter("sort"), "selfecha", "datedes")) out.print("selected"); %>><%=paramRequest.getLocaleString("usrmsg_view_search_popularity")%></option>
                        <option value="statdes" <% if (Utils.chdFtr(request.getParameter("sort"), "selfecha", "imptdes")) out.print("selected"); %>><%=paramRequest.getLocaleString("usrmsg_view_search_important")%></option>
                    </select>
		</div>
            </div>
            <button type="button" onclick="reset();" class="btn-cultura btn-rojo"><%=paramRequest.getLocaleString("usrmsg_view_search_delete_filters")%></button>
    <%  } %>
    </div>
</div>
<script>setBounds();</script>