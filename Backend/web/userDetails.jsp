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
  Time: 14:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <title>Modify User Details</title>
    <link rel="stylesheet" type="text/css" href="/StyleSheets/detailStyle.css">
</head>
<body>

<%  Connection connection = DBConnectionHandler.getInstance().getConnection();
    if(!CookieHandler.getInstance().isSafe(request,response)){
        return;
    }
    AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
    PreparedStatement statement = null;
    ResultSet user_appResultSet = null; %>
<%
    try{
        String query = Constants.USER_DETAILS;
        statement=connection.prepareStatement(query);
        statement.setInt(1, data.getUser_id());
        user_appResultSet=statement.executeQuery();
%>
<div class="table-responsive">
<table class="table" border>

    <tr><td colspan="3">User Details</td></tr>

    <%
        while (user_appResultSet.next()) {
            System.out.println("...retrieving data...");
    %>

    <tr><td>
        <td>Username: <%=user_appResultSet.getString("username")%></td>
        <td>Email: <%=user_appResultSet.getString("mail")%></td></tr>
    <%
        }
    %>

</table>
</div>
<a href="<%= Constants.PATH + "/modifyUserDetails.html?user_id=" + data.getUser_id()%>"><p>  Click for Modify User Details</p></a>

<%
        statement.close();
        user_appResultSet.close();
        connection.close();
    }catch (Exception ex){
        ex.printStackTrace();
    }

%>

<script language="javascript" type="text/javascript">
    function returnHome() {
        location.href = "/peakplatform";
    }
</script>
<br>
<button class="btn btn-primary" onclick="returnHome()">Return</button></div>

</body>
</html>
