
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.eperson.Mycourse" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="java.util.List" %>
<%@ page import="org.dspace.content.Bitstream"%>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.factory.ContentServiceFactory" %>
<%@ page import="org.dspace.content.service.CollectionService" %>
<%@ page import="org.dspace.browse.ItemCounter" %>

<%@ page import="org.dspace.content.service.ItemService" %>
<%@ page import="org.dspace.content.*"%>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>


<dspace:layout titlekey="jsp.community-list.title">


<ul class="media-list">
<li class="media well">
<div class="media-body"><h4 class="media-heading" >Your response has been noted.Thanks for your feedback.<h4></div>
</li>
</ul>

<div class="row">
	<%@ include file="discovery/static-tagcloud-facet.jsp" %>
</div>
</dspace:layout>

