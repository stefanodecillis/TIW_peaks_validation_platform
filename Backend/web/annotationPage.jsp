<%@ page import="Handler.DBConnectionHandler" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="Entities.AuthCookie" %>
<%@ page import="Handler.CookieHandler" %><%--
  Created by IntelliJ IDEA.
  User: step
  Date: 15/07/2018
  Time: 13:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Annotation Page</title>
</head>
<body>
    <%
        if(!CookieHandler.getInstance().isSafe(request,response)){
            return;
        }
        AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
    %>

    <form action="/validator" method="post">
        <input type="text" name="peakName" value="<%=request.getParameter("peakName")%>">
        <input type="hidden" name="latitude" value="<%=request.getParameter("latitude")%>">
        <input type="hidden" name="longitude" value="<%=request.getParameter("longitude")%>">
        <input type="number" name="elevation" value="<%=request.getParameter("elevation")%>">
        <input type="text" name="localizedNames" value="<%=request.getParameter("localizedNames")%>">
        <input type="hidden" name="campaign" value="<%=request.getParameter("campaign")%>">
        <input type="hidden" name="user" value="<%=data.getUser_id()%>">
        <input type="hidden" name="peakId" value="<%=request.getParameter("peakId")%>">
        <input type="hidden" name="map" value="<%=request.getParameter("map")%>">
        <input type="submit" value="Send Annotation">
    </form>
</body>
</html>
