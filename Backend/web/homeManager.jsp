<%@ page import="Handler.DBConnectionHandler" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Util.Constants" %><%--
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
    <%! Connection connection = DBConnectionHandler.getInstance().getConnection();
        PreparedStatement statement = null;
        ResultSet resultSet = null; %>
</head>
<body>
<h1>List of your Campaign</h1>
<%
    try {
        String query = Constants.CHECK_CAMPAIGN_BY_OWNER_ID;
        statement = connection.prepareStatement(query);
        statement.setInt(1, Constants.TEST_USER_ID);
        resultSet = statement.executeQuery();
%>
<table border>

    <tr><td colspan="3">Campaign</td></tr>

    <%
        while (resultSet.next()) {
    %>

    <tr><td>

        <a href="campaign.jsp?campaign_id=<%=resultSet.getInt("campaign_id")%>">
            <%=resultSet.getString("campaign_name")%> </a></td>

        <td><%=resultSet.getInt("campaign_status_id")%></td>
        <td><%=resultSet.getDate("ts_date")%></td>
        <td><%=resultSet.getDate("ts_begin")%></td>
        <td><%=resultSet.getDate("ts_end")%></td></tr>
    <%
        }
    %>

</table>

<a href="<%= Constants.PATH + "/userDetails.jsp?user_id=" + Constants.TEST_USER_ID%>"><p>  Click for User Details</p></a>

<%
        statement.close();
        resultSet.close();
        connection.close();
    } catch (Exception ex) {

    }
%>
</body>
</html>
