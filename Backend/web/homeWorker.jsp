<%@ page import="Handler.DBConnectionHandler" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: Paolo De Santis
  Date: 14/05/2018
  Time: 14:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Worker HomePage</title>
    <%! Connection connection = DBConnectionHandler.getInstance().getConnection();
        PreparedStatement statement = null;
        ResultSet campaignNotJoined = null;
        ResultSet campaignJoined = null;%>
</head>
<body>
<h1>Campaign not Joined</h1>
<%

%>

<h1>Campaign Joined</h1>
<h1>Campaign Joined</h1>
<%

%>





</body>
</html>
