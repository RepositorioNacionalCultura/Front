<%-- 
    Document   : audiodetail.jsp
    Created on : 22/05/2018, 11:48:36 AM
    Author     : sergio.tellez
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="mx.gob.cultura.portal.resources.ArtDetail, mx.gob.cultura.portal.utils.Utils, org.semanticwb.model.WebSite, org.semanticwb.portal.api.SWBResourceURL, org.semanticwb.portal.api.SWBParamRequest"%>
<%@ page import="java.util.List, java.util.ArrayList, mx.gob.cultura.portal.response.Title, mx.gob.cultura.portal.response.Entry, mx.gob.cultura.portal.response.DateDocument, mx.gob.cultura.portal.response.DigitalObject"%>

<%
    int audios = 0;
    String suri = "";
    String title = "";
    String creator = "";
    List<Entry> series = new ArrayList<>();
    StringBuilder callBack = new StringBuilder();
    StringBuilder divVisor = new StringBuilder();
    StringBuilder scriptHeader = new StringBuilder();
    StringBuilder scriptCallVisor = new StringBuilder();
    List<DigitalObject> digitalobjects = new ArrayList<>();
    Entry entry = (Entry)request.getAttribute("entry");
    SWBParamRequest paramRequest = (SWBParamRequest)request.getAttribute("paramRequest");
    WebSite site = paramRequest.getWebPage().getWebSite();
    SWBResourceURL tchURL = paramRequest.getRenderUrl().setMode(ArtDetail.MODE_TCH_DTA);
    tchURL.setCallMethod(SWBParamRequest.Call_DIRECT);
    if (null != entry) {
        suri = entry.getId();
        if (null != entry.getSerie() && null != request.getAttribute("serie")) {
            series = (List<Entry>)request.getAttribute("serie");
            digitalobjects = Utils.getAudio(entry, series);
            callBack.append(",")
                .append("\"callbacks\": {")
		.append("	'song_change': function() {")
		.append("		doSerie(Amplitude.getActiveIndex(),'").append(suri).append("');")
		.append("	}")
		.append("}");
	}else digitalobjects = entry.getDigitalObject();
	if (null != digitalobjects) {
            audios = null != digitalobjects ? digitalobjects.size() : 0;
            title = Utils.replaceSpecialChars(Utils.getTitle(entry.getRecordtitle(), 0));
            creator = Utils.getRowData(entry.getCreator(), 0, false);
            if (audios > 0) {
                scriptHeader.append("<link rel=\"stylesheet\" type=\"text/css\" href=\"/work/models/").append(site.getId()).append("/audio/css/audio.css\"/>");
		divVisor.append("<script>")
                    .append("	$(document).ready(function(){")
                    .append("       $(\"#play-pause\").click(function(){")
                    .append("		$(\".audio-bit\").toggleClass(\"playbit\");")
                    .append("       });")
                    .append("	});")
                    .append("</script>");
                scriptCallVisor.append("<script type=\"text/javascript\">")
                    .append("   Amplitude.init({")
                    .append("       \"songs\": [");
                    for (DigitalObject digital : digitalobjects) {
                        String type = (null != digital.getMediatype() && null != digital.getMediatype().getMime()) ?  digital.getMediatype().getMime() : "";
			if (!type.isEmpty() && type.equalsIgnoreCase("wav") || type.equalsIgnoreCase("mp3")) {
                            scriptCallVisor.append("    {")
                                .append("	\"name\": \"").append(title).append("\",")
				.append("	\"artist\": \"").append(creator).append("\",")
				//.append("	\"album\": \"").append(null != digital.getMediatype() ? digital.getMediatype().getName() : "").append("\",")
				.append("	\"url\": \"").append(digital.getUrl()).append("\",")
				.append("	\"cover_art_url\": \"/work/models/").append(site.getId()).append("/audio/img/waves.png\"")
				.append("   },");
			}
                    }
                    if (scriptCallVisor.length() > 0) scriptCallVisor.deleteCharAt(scriptCallVisor.length()-1);
                    scriptCallVisor.append("       ]")
                        .append(callBack)
			.append("	});")
			.append("</script>");
            }
        }
    }
    String scriptFB = Utils.getScriptFBShare(request);
%>
<%=scriptFB%>
<%=scriptHeader%>
<%=divVisor%>
<script>
    function doSerie(index, id) {
        dojo.xhrPost({
            url: '<%=tchURL%>?_index='+index+'&id='+id,
            load: function(data) {
		dojo.byId('tchdta').innerHTML=data;
		location.href = '#showPage';
            }
        });
    }
</script>
<section id="detalle" class="vis-audio">
    <jsp:include page="../flow.jsp" flush="true"/>
    <div id="idetail" class="detallelist">
        <div class="explora">
            <jsp:include page="../share.jsp" flush="true"/>
        </div>
        <div class="" id="amplitude-player">
            <div class="row audiorow">
                <div class="col-12 col-sm-8" id="amplitude-left">
                    <div id="meta-container">
                        <div class="row">
                            <div class="bit1 col-3 col-md-4">
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit-100"></div>
                            </div>
                            <div class="bit2 col-9 col-md-8">
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>                                    
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit"></div>
                                <div class="audio-bit-100"></div>
                            </div>
                            <div class="bit3 col-3 col-md-4">
                                <div class="audio-bit2"></div>
                                <div class="audio-bit-100"></div>
                            </div>
                            <div class="bit4 col-9 col-md-8">
                                <span amplitude-song-info="name" amplitude-main-song-info="true" class="song-name oswM"></span>
                                <div class="song-artist-album">
                                    <span amplitude-song-info="album" amplitude-main-song-info="true" class="oswM"></span>
                                    <span amplitude-song-info="artist" amplitude-main-song-info="true"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="player-left-bottom" class="barra-controles row">
                        <div class="col-12 col-md-8">
                            <div id="control-container" class="col-12">
                                <div id="central-control-container"> 
                                    <div id="central-controls">
                                        <div class="amplitude-prev" id="previous">
                                            <span class="ion-ios-skipbackward"></span>
                                        </div>
                                        <div class="amplitude-play-pause" amplitude-main-play-pause="true" id="play-pause">
                                            <span class="ion-ios-play"></span>
                                            <span class="ion-ios-pause"></span>
                                        </div>
                                        <div class="amplitude-next" id="next">
                                            <span class="ion-ios-skipforward"></span>
                                        </div>
                                    </div>
                                </div> <!-- pre PLAY next -->
                            </div> <!-- CONTROLES -->
                            <div id="time-container" class="col-12"> 
                                <span class="current-time"> 
                                    <span class="amplitude-current-hours oswM" amplitude-main-current-hours="true"></span><b>:</b><span class="amplitude-current-minutes oswM" amplitude-main-current-minutes="true"></span><b>:</b><span class="amplitude-current-seconds oswM" amplitude-main-current-seconds="true"></span>
                                </span> <!-- 00 : 00-->
                                <input type="range" class="amplitude-song-slider" amplitude-main-song-slider="true" step=".1"/> <!-- linea --->
                                <span class="duration"> 
                                    <span class="amplitude-duration-hours oswM" amplitude-main-duration-hours="true"></span><b>:</b><span class="amplitude-duration-minutes oswM" amplitude-main-duration-minutes="true"></span><b>:</b><span class="amplitude-duration-seconds oswM" amplitude-main-duration-seconds="true"></span>
                                </span> <!-- 33 : 33-->
                            </div> <!-- TIEMPO -->
                        </div>
                        <div id="volume-container" class="col-4">
                            <div class="volume-controls row">
                                <div class="amplitude-mute col-3 col-sm-3 col-md-2 amplitude-not-muted">
                                    <span class="ion-ios-volume-high"></span>
                                    <span class="ion-ios-volume-low"></span>
                                </div>
                                <div class="col-8 col-sm-9 col-md-10">
                                    <input type="range" class="amplitude-volume-slider" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
		<div class="col-12 col-sm-4" id="amplitude-right">
                <%
                    int index = 0;
                    for (DigitalObject digital : digitalobjects) {
                        int id = index + 1;
                        String type = (null != digital.getMediatype() && null != digital.getMediatype().getMime()) ?  digital.getMediatype().getMime() : "";
                        String song = (null != digital.getMediatype() && null != digital.getMediatype().getName()) ?  digital.getMediatype().getName() : "";
			if (!type.isEmpty() && type.equalsIgnoreCase("wav") || type.equalsIgnoreCase("mp3")) {
		%>
                            <div class="song amplitude-song-container amplitude-play-pause" amplitude-song-index="<%=index%>">
                                <span class="song-number"><%=id%>.</span>
                                <div class="song-meta-data">
                                    <span class="song-title"><%=song%></span>
                                    <span class="song-artist"><%=creator%></span>
                                </div>
                                <!--span class="song-duration">3:30</span-->
                            </div>
                <%
                            index++;
			}
                    } 
                %>
		</div>
            </div>
	</div>
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
<%=scriptCallVisor%>
<div id="dialog-message-tree" title="error">
    <p>
        <div id="dialog-text-tree"></div>
    </p>
</div>

<div id="dialog-success-tree" title="�xito">
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