/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mx.gob.cultura.portal.resources;

import org.semanticwb.Logger;
import org.semanticwb.SWBUtils;
import org.semanticwb.SWBPlatform;

import mx.gob.cultura.portal.utils.Utils;
import mx.gob.cultura.portal.response.Entry;
import mx.gob.cultura.portal.request.GetBICRequest;
import org.semanticwb.portal.api.GenericAdmResource;

import org.semanticwb.model.WebSite;
import org.semanticwb.portal.api.SWBParamRequest;
import org.semanticwb.portal.api.SWBResourceException;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.net.HttpURLConnection;
import java.nio.charset.StandardCharsets;

import java.util.ArrayList;
import java.util.Collections;
import javax.servlet.ServletException;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.List;
import java.util.Random;
import mx.gob.cultura.portal.utils.Serie;
import mx.gob.cultura.portal.utils.Amplitude;
import mx.gob.cultura.portal.response.Document;
import mx.gob.cultura.portal.request.ListBICRequest;
import mx.gob.cultura.portal.response.DigitalObject;
import static mx.gob.cultura.portal.utils.Constants.SORT;
import static mx.gob.cultura.portal.utils.Constants.TOTAL;
import static mx.gob.cultura.portal.utils.Constants.WORD;
import static mx.gob.cultura.portal.utils.Constants.FILTER;
import static mx.gob.cultura.portal.utils.Constants.NUM_ROW;
import static mx.gob.cultura.portal.utils.Constants.NUM_RECORD;
import static mx.gob.cultura.portal.utils.Constants.IDENTIFIER;

/**
 *
 * @author sergio.tellez
 */
public class ArtDetail extends GenericAdmResource {

    private static final String POSITION = "n";
    private static final String MODE_VISUAL = "VISUAL";
    private static final String MODE_DIGITAL = "DIGITAL";
    
    public static final String MODE_RES_ADD = "RES_ADD";
    public static final String MODE_TCH_DTA = "TCH_DTA";
    private static final Logger LOG = SWBUtils.getLogger(ArtDetail.class);

    @Override
    public void processRequest(HttpServletRequest request, HttpServletResponse response, SWBParamRequest paramRequest) throws SWBResourceException, IOException {
        //response.setContentType("text/html; charset=UTF-8");
        String mode = paramRequest.getMode();
        if (MODE_DIGITAL.equals(mode)) {
            doDigital(request, response, paramRequest);
        } else if (MODE_VISUAL.equals(mode)) {
            doViewer(request, response, paramRequest);
        } else if (MODE_TCH_DTA.equals(mode)) {
            doTchdta(request, response, paramRequest);
        } else {
            super.processRequest(request, response, paramRequest);
        }
    }

    @Override
    public void doView(HttpServletRequest request, HttpServletResponse response, SWBParamRequest paramRequest) throws IOException {
        //String path = "/swbadmin/jsp/rnc/preview.jsp";
        WebSite site = paramRequest.getWebPage().getWebSite();
        String path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/preview.jsp";
        String baseUri = getBaseUri(paramRequest);
        String uri = getParamUri(baseUri, request);
        try {
            if (null != uri) {
                Entry entry = getEntry(request, uri);
                if (null != entry) {
                    int position = null != request.getParameter(POSITION) ? Utils.toInt(request.getParameter(POSITION)) : 0;
                    entry.setPosition(position);
                    DigitalObject ob = getDigitalObject(entry.getDigitalObject(), position);
                    SearchCulturalProperty.setThumbnail(entry, paramRequest.getWebPage().getWebSite(), position);
                    if (null != request.getParameter(POSITION)) {
                        path = this.getViewerPath(site, ob, SWBParamRequest.Mode_VIEW);
                    }else {
                        String mime = null != entry.getRights() && null != entry.getRights().getMedia() ? entry.getRights().getMedia().getMime() : "";
                        if (null == mime || mime.isEmpty() || mime.toLowerCase().startsWith("text")) mime = getMimeType(ob);
                        path = getViewerPath(site, mime, SWBParamRequest.Mode_VIEW);
                    }
                    incHits(entry, baseUri, uri);
                }
                request.setAttribute("entry", entry);
                request.setAttribute("serie", serie(entry, baseUri));
                request.setAttribute("collection", explore(entry, baseUri));
            }
            setParams(request, paramRequest);
            RequestDispatcher rd = request.getRequestDispatcher(path);
            rd.include(request, response);
        } catch (ServletException se) {
            LOG.error(se);
        }
    }
    
    public void doTchdta(HttpServletRequest request, HttpServletResponse response, SWBParamRequest paramRequest) throws java.io.IOException {
        Entry tch = null;
        //String path = "/swbadmin/jsp/rnc/techrepl.jsp";
        String path = "/work/models/"+paramRequest.getWebPage().getWebSite().getId()+"/jsp/rnc/detail/techrepl.jsp";
        String baseUri = getBaseUri(paramRequest);
        String uri = getParamUri(baseUri, request);
        String _index = request.getParameter("_index");
        int index = Utils.toInt(_index)-1;
        try {
            if (null != uri) {
                Entry entry = getEntry(request, uri);
                if (null != entry) {
                    List<Entry> serie = serie(entry, baseUri);
                    if (index < 0 || null == serie || serie.isEmpty() || index > serie.size()) tch = entry;
                    else tch = serie.get(index);
                }
                request.setAttribute("entry", tch);
            }
            request.setAttribute("paramRequest", paramRequest);
            RequestDispatcher rd = request.getRequestDispatcher(path);
            rd.include(request, response);
        } catch (ServletException se) {
            LOG.error(se);
        }
    }
    
    public static Entry getEntry(HttpServletRequest request, String uri) {
        Entry entry = null;
        Document document = null;
        if (null != request.getParameter(IDENTIFIER)) {
            GetBICRequest req = new GetBICRequest(uri);
            entry = req.makeRequest();
        }else {
            ListBICRequest list = new ListBICRequest(uri);
            document = list.makeRequest();
            if (null != document && null != document.getRecords() && !document.getRecords().isEmpty()) {
                entry = document.getRecords().get(0);
                request.setAttribute(TOTAL, document.getTotal());
            }
        }
        return entry;
    }

    public void doDigital(HttpServletRequest request, HttpServletResponse response, SWBParamRequest paramRequest) throws java.io.IOException {
        int iDigit = 0;
        WebSite site = paramRequest.getWebPage().getWebSite();
        String baseUri = site.getModelProperty("search_endPoint");
        if (null == baseUri || baseUri.isEmpty())
            baseUri = SWBPlatform.getEnv("rnc/endpointURL", getResourceBase().getAttribute("url", "http://localhost:8080")).trim();
        String uri = baseUri + "/api/v1/search?identifier=";
        //String path = "/swbadmin/jsp/rnc/digitalobj.jsp";
        String path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/digitalobj.jsp";
        try {
            if (null != request.getParameter(IDENTIFIER)) {
                uri += request.getParameter(IDENTIFIER);
                if (null != request.getParameter(POSITION))
                    iDigit = Utils.toInt(request.getParameter(POSITION));
                GetBICRequest req = new GetBICRequest(uri);
                Entry entry = req.makeRequest();
                if (null != entry) {
                    entry.setPosition(iDigit);
                    DigitalObject ob = getDigitalObject(entry.getDigitalObject(), iDigit);
                    SearchCulturalProperty.setThumbnail(entry, paramRequest.getWebPage().getWebSite(), iDigit);
                    int images = null != entry.getDigitalObject() ? entry.getDigitalObject().size() : 0;
                    if (null != request.getParameter(POSITION))
                        path = getViewerPath(site, ob, MODE_DIGITAL);
                    else path = getViewerPath(site, entry.getRights().getMedia().getMime(), MODE_DIGITAL);
                    if (iDigit >= 0 && iDigit <= images) {
                        request.setAttribute("iDigit", iDigit);
                        request.setAttribute("digital", entry.getDigitalObject().get(iDigit));
                    }
                    if (ob.getMediatype().getMime().equalsIgnoreCase("wav") || ob.getMediatype().getMime().equalsIgnoreCase("mp3")) {
                        request.setAttribute("iprev", iPrev(entry.getDigitalObject(), iDigit, ob.getMediatype().getMime()));
                        request.setAttribute("inext", iNext(entry.getDigitalObject(), iDigit, ob.getMediatype().getMime()));
                    }
                    incHits(entry, baseUri, uri);
                }
                request.setAttribute("entry", entry);
            }
            setParams(request, paramRequest);
            request.setAttribute("paramRequest", paramRequest);
            RequestDispatcher rd = request.getRequestDispatcher(path);
            rd.include(request, response);
        } catch (ServletException se) {
            LOG.error(se);
        }
    }
    
    public void doViewer(HttpServletRequest request, HttpServletResponse response, SWBParamRequest paramRequest) throws java.io.IOException {
        int iDigit = 0;
        WebSite site = paramRequest.getWebPage().getWebSite();
        String baseUri = site.getModelProperty("search_endPoint");
        if (null == baseUri || baseUri.isEmpty())
            baseUri = SWBPlatform.getEnv("rnc/endpointURL", getResourceBase().getAttribute("url", "http://localhost:8080")).trim();
        String uri = baseUri + "/api/v1/search?identifier=";
        //String path = "/swbadmin/jsp/rnc/resources/artdetail.jsp";
        String path = "/work/models/"+site.getId()+"/jsp/rnc/resources/artdetail.jsp";
        try {
            if (null != request.getParameter(POSITION)) iDigit = Utils.toInt(request.getParameter(POSITION));
            if (null != request.getParameter(IDENTIFIER)) {
                uri += request.getParameter(IDENTIFIER);
                GetBICRequest req = new GetBICRequest(uri);
                Entry entry = req.makeRequest();
                if (null != entry) {
                    entry.setPosition(iDigit);
                    int images = null != entry.getDigitalObject() ? entry.getDigitalObject().size() : 0;
                    if (iDigit >= 0 && iDigit <= images) {
                        request.setAttribute("iDigit", iDigit);
                        request.setAttribute("digital", entry.getDigitalObject().get(iDigit));
                    }
                    DigitalObject ob = getDigitalObject(entry.getDigitalObject(), iDigit);
                    SearchCulturalProperty.setThumbnail(entry, paramRequest.getWebPage().getWebSite(), iDigit);
                    if (null != request.getParameter(POSITION)) path = getViewerPath(site, ob, MODE_DIGITAL);
                    else path = getViewerPath(site, entry.getRights().getMedia().getMime(), MODE_DIGITAL);
                }
                request.setAttribute("entry", entry);
            }
            path = path.replaceFirst("/rnc/", "/rnc/resources/").replaceFirst("digitalobj", "artdetail");
            request.setAttribute("paramRequest", paramRequest);
            RequestDispatcher rd = request.getRequestDispatcher(path);
            rd.include(request, response);
        } catch (ServletException se) {
            LOG.error(se);
        }
    }
    
    private List<Entry> serie(Entry entry, String endPoint) {
        String key = null;
        List<Entry> serieList = new ArrayList<>();
        if (null == entry) return serieList;
        if (null != entry.getSerie() && !entry.getSerie().isEmpty()) {
            key = null != entry.getSerie().get(0) && !entry.getSerie().get(0).trim().isEmpty() ? entry.getSerie().get(0) : "";
            if (Amplitude.getSerieList().containsKey(key)) return Amplitude.getSerieList().get(key);
            List<Entry> records = bookCase(endPoint, key, false);
            for (Entry e : records) {
                if (null != e.getSerie() && comparator(entry.getSerie(), e.getSerie())) {
                    serieList.add(e);
                }
            }
        }
        if (!serieList.isEmpty()) {
            Collections.sort(serieList, new Serie());
            Amplitude.getSerieList().put(key, serieList);
        }
        return serieList;
    }
    
    private boolean comparator(List<String> a, List<String> b) {
        if (null == a || null == b || a.isEmpty() || b.isEmpty() || a.size() != b.size()) return false;
        for (int i=0; i<a.size(); i++) {
            if (!a.get(i).equalsIgnoreCase(b.get(i))) return false;
        }
        return true;
    }
    
    private String getParamUri(String base, HttpServletRequest request) throws UnsupportedEncodingException {
        StringBuilder uri = new StringBuilder(base);
        uri.append("/api/v1/search?");
        if (null != request.getParameter(IDENTIFIER)) uri.append("identifier=").append(request.getParameter(IDENTIFIER));
        else {
            if (null != request.getParameter(WORD)) uri.append("q=").append(URLEncoder.encode(request.getParameter(WORD), StandardCharsets.UTF_8.name()));
            if (null != request.getParameter(FILTER)) uri.append(getPageFilter(request));
            if (null != request.getParameter(NUM_RECORD)) uri.append("&from=").append(request.getParameter(NUM_RECORD)).append("&size=1");
        }
        return uri.toString();
    }
    
     private String getPageFilter(HttpServletRequest request) throws UnsupportedEncodingException { 
        StringBuilder filters = new StringBuilder();
        String [] params = request.getParameter(FILTER).split(",");
        for (int i=0; i<params.length; i++) {
            String [] pair = params[i].split(":");
            filters.append(",").append(pair[0]).append(":").append(URLEncoder.encode(pair[1], StandardCharsets.UTF_8.name()));
        }
        if (filters.length() > 0) {
            filters.deleteCharAt(0);
            filters.insert(0, "&filter=");
            request.setAttribute("filters", URLDecoder.decode(filters.toString(), StandardCharsets.UTF_8.name()));
        }
        return filters.toString();
    }
    
    private String getBaseUri(SWBParamRequest paramRequest) {
        //Get baseURI from site properties first
        String baseUri = paramRequest.getWebPage().getWebSite().getModelProperty("search_endPoint");
        if (null == baseUri || baseUri.isEmpty())
            baseUri = SWBPlatform.getEnv("rnc/endpointURL", getResourceBase().getAttribute("url", "http://localhost:8080")).trim();
        return baseUri;
    }
    
    private void setParams(HttpServletRequest request, SWBParamRequest paramRequest) throws IOException {
        request.setAttribute("paramRequest", paramRequest);
        request.setAttribute("back", back(request, paramRequest));
        if (null != request.getParameter(WORD)) request.setAttribute(WORD, request.getParameter(WORD));
        if (null != request.getParameter(FILTER)) request.setAttribute(FILTER, request.getParameter(FILTER));
        if (null != request.getParameter(TOTAL)) request.setAttribute(TOTAL, Utils.toInt(request.getParameter(TOTAL)));
        if (null != request.getParameter(NUM_RECORD)) request.setAttribute(NUM_RECORD, request.getParameter(NUM_RECORD));
    }
    
    private String back(HttpServletRequest request, SWBParamRequest paramRequest) throws java.io.IOException {
        StringBuilder params = new StringBuilder();
        int p = ((null != request.getParameter("leap") ? Utils.toInt(request.getParameter("leap")) : 0) / 8) + 1;
        params.append("/").append(paramRequest.getUser().getLanguage()).append("/").append(paramRequest.getWebPage().getWebSiteId()).append("/resultados");
        if (null != request.getParameter(WORD)) params.append("?word=").append(request.getParameter(WORD));
        if (null != request.getParameter(SORT)) params.append("&sort=").append(request.getParameter(SORT));
        if (null != request.getParameter(FILTER)) params.append("&filter=").append(request.getParameter(FILTER));
        if (p > 1) params.append("&p=").append(p);
        String back = (null != request.getParameter("word")) ? "javascript:location.replace('" + params.toString() + "');" : "javascript:history.go(-1)";
        return back;
    }

    private List<Entry> explore(Entry entry, String endPoint) {
        Random rand = new Random();
        List<Entry> bookCase = new ArrayList<>();
        if (null == entry) return bookCase;
        List<String> collection = entry.getCollection();
        int elements = Utils.toInt(getResourceBase().getAttribute("moreincollection", String.valueOf(NUM_ROW)));
        if (null != collection && !collection.isEmpty()) {
            for (String rack : collection) {
                List<Entry> qrack = bookCase(endPoint, rack, false);
                if (null != qrack && !qrack.isEmpty()) bookCase.addAll(qrack);
                /**if (!bookCase.isEmpty() && bookCase.size() > NUM_ROW) {
                    break;
                }**/
            }
        }
        if (bookCase.size() < elements && null != entry.getHolder()) {
            for (String rack : entry.getHolder()) {
                List<Entry> qrack = bookCase(endPoint, rack, true);
                if (null != qrack && !qrack.isEmpty()) {
                    for (Entry e : qrack) {
                        if (!bookCase.contains(e)) bookCase.add(e);
                    }
                }
                
            }
        }
        if (bookCase.size() > elements) {
            int randitem = rand.nextInt(bookCase.size()-elements);
            List<Entry> randomCase = new ArrayList<>();
            for (int i = 0; i<elements; i++){
                randomCase.add(bookCase.get(randitem+i));
            }
            return randomCase;
        } else {
            return bookCase;
        }
    }

    private List<Entry> bookCase(String endPoint, String rack, boolean clean) {
        Document document = null;
        String uri = endPoint + "/api/v1/search?q=";
        try {
            uri += URLEncoder.encode(rack, StandardCharsets.UTF_8.name());
            if (clean) uri = uri.replaceAll("%C2%A0", "%20");
        } catch (UnsupportedEncodingException uex) {
            LOG.error(uex);
        }
        ListBICRequest req = new ListBICRequest(uri);
        try {
            document = req.makeRequest();
        } catch (Exception se) {
            LOG.error(se);
        }
        return null != document ? document.getRecords() : new ArrayList<>();
    }

    private DigitalObject getDigitalObject(List<DigitalObject> list, int position) {
        if (null == list || list.isEmpty() || position > list.size()) return null;
        if (position <= 0) return list.get(0);
        return list.get(position);
    }
    
    private Integer iNext (List<DigitalObject> list, int position, String type) {
        Integer inext = 0;
        for (int i = position++; i < list.size(); i++) {
            DigitalObject o = list.get(i);
            if (!o.getMediatype().getMime().equalsIgnoreCase(type)) {
                inext = i;
                break;
            } 
        }
        return inext;
    }
    
    private Integer iPrev(List<DigitalObject> list, int position, String type) {
        Integer iprev = 0;
        if (position > list.size()+1 || position < 1) return iprev;
        for (int i = position--; i > 0; i--) {
            DigitalObject o = list.get(i);
            if (!o.getMediatype().getMime().equalsIgnoreCase(type)) {
                iprev = i;
                break;
            }
        }
        return iprev;
    }
    
    private String getViewerPath(WebSite site, String type, String mode) {
        //String path = "/swbadmin/jsp/rnc/preview.jsp";
        String path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/preview.jsp";
        if (null == type || type.isEmpty() || type.equalsIgnoreCase("conjunto de archivos")) return path;
        if (mode.equalsIgnoreCase(MODE_DIGITAL)) {
            if (type.equalsIgnoreCase("pdf") || type.equalsIgnoreCase("application/pdf")) {
                //path = "/swbadmin/jsp/rnc/viewer/pdfdigital.jsp";
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/pdfdigital.jsp";
            }else if (type.equalsIgnoreCase("video") || type.equalsIgnoreCase("mp4") || type.equalsIgnoreCase("mov"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/videodigital.jsp";//path = "/swbadmin/jsp/rnc/viewer/videodigital.jsp";
            else if (type.equalsIgnoreCase("epub"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/epubdigital.jsp";//path = "/swbadmin/jsp/rnc/viewer/epubdigital.jsp";
            else if (type.equalsIgnoreCase("audio") || type.equalsIgnoreCase("wav") || type.equalsIgnoreCase("mp3"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/audiodigital.jsp";//path = "/swbadmin/jsp/rnc/viewer/audiodigital.jsp";
            else if (type.equalsIgnoreCase("3d") || type.contains("3d"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/sketchdigital.jsp";//path = "/swbadmin/jsp/rnc/viewer/sketchdigital.jsp";
            else
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/digitalobj.jsp";//path = "/swbadmin/jsp/rnc/digitalobj.jsp";
        } else {
            if (type.equalsIgnoreCase("imagen") || type.startsWith("image") || type.equalsIgnoreCase("jpg") || type.equalsIgnoreCase("png"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/artdetail.jsp";//path = "/swbadmin/jsp/rnc/artdetail.jsp";
            else if (type.equalsIgnoreCase("pdf") || type.equalsIgnoreCase("application/pdf"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/pdfdetail.jsp";//path = "/swbadmin/jsp/rnc/viewer/pdfdetail.jsp";
            else if (type.equalsIgnoreCase("video") || type.equalsIgnoreCase("mp4") || type.equalsIgnoreCase("mov"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/videodetail.jsp";//path = "/swbadmin/jsp/rnc/viewer/videodetail.jsp";
            else if (type.equalsIgnoreCase("epub"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/epubdetail.jsp";//path = "/swbadmin/jsp/rnc/viewer/epubdetail.jsp";
            else if (type.equalsIgnoreCase("audio") || type.equalsIgnoreCase("wav") || type.equalsIgnoreCase("mp3"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/audiodetail.jsp";//path = "/swbadmin/jsp/rnc/viewer/audiodetail.jsp";
            else if (type.equalsIgnoreCase("3d") || type.contains("3d"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/sketchdetail.jsp";//path = "/swbadmin/jsp/rnc/viewer/sketchdetail.jsp";
        }
        return path;
    }

    private String getViewerPath(WebSite site, DigitalObject digital, String mode) {
        //String path = "/swbadmin/jsp/rnc/artdetail.jsp";
        String path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/artdetail.jsp";
        if (null == digital) return path;
        String type = getMimeType(digital);
        if (null == type || type.isEmpty()) return path;
        if (mode.equalsIgnoreCase(MODE_DIGITAL)) {
            if (type.equalsIgnoreCase("pdf") || type.equalsIgnoreCase("application/pdf"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/pdfdigital.jsp";//path = "/swbadmin/jsp/rnc/viewer/pdfdigital.jsp";
            else if (type.equalsIgnoreCase("mp4") || type.equalsIgnoreCase("mov"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/videodigital.jsp";//path = "/swbadmin/jsp/rnc/viewer/videodigital.jsp";
            else if (type.equalsIgnoreCase("epub"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/epubdigital.jsp";//path = "/swbadmin/jsp/rnc/viewer/epubdigital.jsp";
            else if (type.equalsIgnoreCase("audio") || type.equalsIgnoreCase("wav") || type.equalsIgnoreCase("mp3"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/audiodigital.jsp";//path = "/swbadmin/jsp/rnc/viewer/audiodigital.jsp";
            else if (type.equalsIgnoreCase("3d") || type.contains("3d"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/sketchdigital.jsp";//path = "/swbadmin/jsp/rnc/viewer/sketchdigital.jsp";
            else
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/digitalobj.jsp";//path = "/swbadmin/jsp/rnc/digitalobj.jsp";
        } else {
            if (type.equalsIgnoreCase("imagen") || type.startsWith("image") || type.equalsIgnoreCase("jpg") || type.equalsIgnoreCase("png"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/artdetail.jsp";//path = "/swbadmin/jsp/rnc/artdetail.jsp";
            else if (type.equalsIgnoreCase("pdf") || type.equalsIgnoreCase("application/pdf"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/pdfdetail.jsp";//path = "/swbadmin/jsp/rnc/viewer/pdfdetail.jsp";
            else if (type.equalsIgnoreCase("video") || type.equalsIgnoreCase("mp4") || type.equalsIgnoreCase("mov"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/videodetail.jsp";//path = "/swbadmin/jsp/rnc/viewer/videodetail.jsp";
            else if (type.equalsIgnoreCase("epub"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/epubdetail.jsp";//path = "/swbadmin/jsp/rnc/viewer/epubdetail.jsp";
            else if (type.equalsIgnoreCase("audio") || type.equalsIgnoreCase("wav") || type.equalsIgnoreCase("mp3") || type.startsWith("audio"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/audiodetail.jsp";//path = "/swbadmin/jsp/rnc/viewer/audiodetail.jsp";
            else if (type.equalsIgnoreCase("3d") || type.contains("3d"))
                path = "/work/models/"+site.getId()+"/jsp/rnc/detail/viewer/sketchdetail.jsp";//path = "/swbadmin/jsp/rnc/viewer/sketchdetail.jsp";
        }
        return path;
    }
    
    private String getMimeType(DigitalObject digital) {
        if (null != digital && null != digital.getMediatype() && null != digital.getMediatype().getMime()) {
            return digital.getMediatype().getMime();
        } else {
            return "";
        }
    }

    private void incHits(Entry entry, String baseUri, String uri) {
        HttpURLConnection connection = null;
        try {
            if (null != entry) {
                uri = baseUri
                        + "/api/v1/search/hits/"
                        + entry.getId();
                URL url = new URL(uri);
                connection = (HttpURLConnection) url.openConnection();
                connection.setDoOutput(true);
                connection.setRequestMethod("POST");
                connection.getOutputStream().close();
                connection.getResponseCode();
            }
        } catch (IOException se) {
            LOG.info(se.getMessage());
        } finally {
            if(null!=connection) connection.disconnect();
        }
    }
}