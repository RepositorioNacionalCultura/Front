/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mx.gob.cultura.portal.resources;

import java.util.List;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mx.gob.cultura.portal.response.Document;
import mx.gob.cultura.portal.request.ListBICRequest;

import mx.gob.cultura.portal.response.Entry;

import org.semanticwb.SWBPlatform;
import org.semanticwb.portal.api.GenericResource;
import org.semanticwb.portal.api.SWBParamRequest;
import org.semanticwb.portal.api.SWBResourceException;

import org.semanticwb.Logger;
import org.semanticwb.SWBUtils;
import static mx.gob.cultura.portal.utils.Constants.IDENTIFIER;
import static mx.gob.cultura.portal.utils.Constants.NUM_REL;


/**
 *
 * @author sergio.tellez
 */
public class RelatedDetail extends GenericResource {
    
    private static final Logger LOG = SWBUtils.getLogger(RelatedDetail.class);
    
    @Override
    public void doView(HttpServletRequest request, HttpServletResponse response, SWBParamRequest paramRequest) throws SWBResourceException, IOException {
        String path = "/swbadmin/jsp/rnc/resources/related.jsp";
        RequestDispatcher rd = request.getRequestDispatcher(path);
        try {
            StringBuilder base = new StringBuilder(endpoint(paramRequest));
            base.append("/api/v1/search?");
            StringBuilder uri =  new StringBuilder(base);
            if (null != request.getParameter(IDENTIFIER)) uri.append("identifier=").append(request.getParameter(IDENTIFIER));
            Entry entry = ArtDetail.getEntry(request, uri.toString());
            request.setAttribute("related", getRelated(entry, base, paramRequest));
            rd.include(request, response);
        }catch (IOException | ServletException se) {
            LOG.info(se.getMessage());
        }
        
    }
    
    private List<Entry> getRelated(Entry entry, StringBuilder endpoint, SWBParamRequest paramRequest) {
        endpoint.append("q=");
        String keywords = "";
        Document document = null;
        if (null == entry || entry.getKeywords().isEmpty()) return new ArrayList<>();
        for (String key : entry.getKeywords()) {
            keywords += key;
        }
        try {
            endpoint.append(URLEncoder.encode(keywords.trim(), StandardCharsets.UTF_8.name()));
            endpoint.append("&from=0&size=").append(NUM_REL);
        } catch (UnsupportedEncodingException ex) {
            LOG.info(ex.getMessage());
        }
        ListBICRequest req = new ListBICRequest(endpoint.toString());
        try {
            document = req.makeRequest();
            List<Entry> records = document.getRecords();
            if (null != records) {
                for (Entry related : records) {
                    SearchCulturalProperty.setThumbnail(related, paramRequest.getWebPage().getWebSite(), 0);
                }
            }
        } catch (Exception se) {
            LOG.error(se);
        }
        return null != document ? document.getRecords() : new ArrayList<>();
    }
    
    private String endpoint(SWBParamRequest paramRequest) {
        String baseUri = paramRequest.getWebPage().getWebSite().getModelProperty("search_endPoint");
        if (null == baseUri || baseUri.isEmpty())
            baseUri = SWBPlatform.getEnv("rnc/endpointURL", getResourceBase().getAttribute("url", "http://localhost:8080")).trim();
        return baseUri;
    }
    
}