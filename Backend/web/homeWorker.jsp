<%@ page import="Handler.DBConnectionHandler" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Util.Constants" %><%--
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
        PreparedStatement statement1 = null;
        ResultSet campaignNotJoined = null;
        ResultSet campaignJoined = null;%>
</head>
<body>
<% try {

    String query = Constants.CAMPAIGN_STARTED_JOINED;
    statement = connection.prepareStatement(query);
    statement.setInt(1, Constants.WORKER_TEST_USER_ID);
    campaignJoined = statement.executeQuery();
%>
<table border>

    <tr><td colspan="3">Campaign started joined</td></tr>

    <%
        while (campaignJoined.next()) {
    %>

    <tr><td>

        <a href="campaign.jsp?campaign_id=<%=campaignJoined.getInt("campaign_id")   %> " >
            <%=campaignJoined.getString("campaign_name")%> </a></td>

        <td><%=campaignJoined.getInt("campaign_status_id")%></td>
        <td><%=campaignJoined.getDate("ts_date")%></td>
        <td><%=campaignJoined.getDate("ts_begin")%></td>
        <td><%=campaignJoined.getDate("ts_end")%></td></tr>
        <td><button formmethod="post" formaction="/registerCampaign" value="Sign Up"></button> </td>
    <%
        }
    %>

</table> <br>


<%

    String query2 = Constants.CAMPAIGN_NOT_JOINED;
    statement1 = connection.prepareStatement(query2);
    statement1.setInt(1, Constants.WORKER_TEST_USER_ID);
    campaignNotJoined = statement1.executeQuery();
%>
<table border>

    <tr><td colspan="3">Campaign not joined</td></tr>

    <%
        while (campaignNotJoined.next()) {
    %>

    <tr><td>

        <a href="campaign.jsp?campaign_id=<%=campaignNotJoined.getInt("campaign_id")  %>">
            <%=campaignNotJoined.getString("campaign_name")%> </a></td>

        <td><%=campaignNotJoined.getInt("campaign_status_id")%></td>
        <td><%=campaignNotJoined.getDate("ts_date")%></td>
        <td><%=campaignNotJoined.getDate("ts_begin")%></td>
        <td><%=campaignNotJoined.getDate("ts_end")%></td></tr>
    <%
        }
    %>

</table>

<a href="<%= Constants.PATH + "/userDetails.jsp?user_id=" + Constants.WORKER_TEST_USER_ID%>"><p>  Click for User Details</p></a>

<%
    statement.close();
    campaignNotJoined.close();
    campaignJoined.close();
    connection.close();
    } catch (Exception ex) {

    }
%>
</body>
</html>
