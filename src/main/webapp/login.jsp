<%@page import="org.sakaiproject.tool.cover.SessionManager"%>
<%@page import="org.sakaiproject.tool.api.Session"%>
<%@page import="org.sakaiproject.user.api.User"%>
<%@page import="org.sakaiproject.user.cover.UserDirectoryService"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	String target = request.getParameter("target");
	if ("POST".equals(request.getMethod())) {
		User user = UserDirectoryService.getCurrentUser();
		String remoteUser = user.getDisplayId()+"@OX.AC.UK";
		// From http://stackoverflow.com/questions/2201925/converting-iso8601-compliant-string-to-java-util-date
		String instant = javax.xml.bind.DatatypeConverter.printDateTime(GregorianCalendar.getInstance());
		
		Session sakaiSession = SessionManager.getCurrentSession();
		Map<String, String> extraHeaders = (Map<String,String>)sakaiSession.getAttribute("extra-headers");
		if (extraHeaders == null) {
			extraHeaders = new HashMap<String,String>();
			sakaiSession.setAttribute("extra-headers", extraHeaders);
		}
		extraHeaders.put("Shib-Authentication-Method", "urn:oasis:names:tc:SAML:2.0:ac:classes:TimeSyncToken");
		extraHeaders.put("Shib-Authentication-Instant", instant);
		extraHeaders.put("REMOTE_USER", remoteUser);
		response.sendRedirect(target);
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<form method="POST">
		<input type="hidden" name="target"
			value="<%=URLEncoder.encode(target)%>"> <input
			type="submit" name="login" value="Login">
	</form>

</body>
</html>