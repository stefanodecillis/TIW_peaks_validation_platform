<%@ page import="Handler.DBConnectionHandler" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: Paolo De Santis
  Date: 14/05/2018
  Time: 14:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Manager HomePage</title>
    <%! Connection connection = DBConnectionHandler.getInstance().getConnection();
        PreparedStatement statement = null;
        ResultSet user_appResultSet = null; %>
</head>
<body>

<%
    try{
        String query = "SELECT * FROM USER_APP WHERE user_id=?";
        statement=connection.prepareStatement(query);
        statement.setInt(1, Integer.parseInt(request.getParameter("user_id")));
        user_appResultSet=statement.executeQuery();

        //HTML

        statement.close();
        user_appResultSet.close();
        connection.close();
    }catch (Exception ex){

    }

%>

</body>
</html>
