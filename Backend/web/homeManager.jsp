<%@ page import="Handler.DBConnectionHandler" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Util.Constants" %>
<%@ page import="Entities.AuthCookie" %>
<%@ page import="Handler.CookieHandler" %><%--
  Created by IntelliJ IDEA.
  User: Paolo De Santis
  Date: 14/05/2018
  Time: 14:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manager HomePage</title>

</head>
<body>
<h1>List of your Campaign</h1>
<% Connection connection = DBConnectionHandler.getInstance().getConnection();
    AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
    PreparedStatement statement = null;
    ResultSet resultSet = null; %>
<%
    try {
        String query = Constants.CHECK_CAMPAIGN_BY_OWNER_ID;
        statement = connection.prepareStatement(query);
        statement.setInt(1, data.getUser_id());
        resultSet = statement.executeQuery();
%>
<table border>

    <tr><td colspan="3">Campaign</td></tr>

    <%
        while (resultSet.next()) {
    %>

    <tr><td>

        <a href="campaigndetails?campaign=<%=resultSet.getInt("campaign_id")%>&user=<%=data.getUser_id()%>">
            <%=resultSet.getString("campaign_name")%> </a></td>

        <td><%=resultSet.getInt("campaign_status_id")%></td>
        <td><%=resultSet.getDate("ts_date")%></td>
        <td><%=resultSet.getDate("ts_begin")%></td>
        <td><%=resultSet.getDate("ts_end")%></td></tr>
    <%
        }
    %>

</table>
<% //TODO what is it this? %>
<a href="<%= Constants.PATH + "/userDetails.jsp?user=" + data.getUser_id()%>"><p>  Click for User Details</p></a>
<br>
<%
        statement.close();
        resultSet.close();
        connection.close();
    } catch (Exception ex) {

    } finally {

    }
%>
<form action = "<%=Constants.PATH+"/campaigncreation"%>" method = "post">
    <input type="hidden" name="user" value="<%=data.getUser_id()%>">
    <input type="submit" value="Create Campaign" />
</form>
<form action = "<%=Constants.PATH+"/logout"%>" method = "post">
    <input type="submit" value="Logout" />
</form>
</body>
</html>
