<%@ page import="Handler.DBConnectionHandler" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Util.Constants" %>
<%--
  Created by IntelliJ IDEA.
  User: Paolo De Santis
  Date: 25/05/2018
  Time: 16:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Campaign Details</title>
</head>
<body>
    <% Connection connection = DBConnectionHandler.getInstance().getConnection();
    PreparedStatement statement = null;
    ResultSet resultSet = null;

        try {
            String query = Constants.CAMPAIGN_DETAILS;
            statement = connection.prepareStatement(query);
            statement.setInt(1, Constants.TEST_USER_ID);
            statement.setString(2, request.getParameter("name"));
            resultSet = statement.executeQuery();








            statement.close();
            resultSet.close();
            connection.close();
        } catch (Exception ex) {

        }
    %>


</body>
</html>
