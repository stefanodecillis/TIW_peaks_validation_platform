<%@ page import="Handler.DBConnectionHandler" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Util.Constants" %>
<%@ page import="Entities.AuthCookie" %>
<%@ page import="Handler.CookieHandler" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

    <title>Worker HomePage</title>
    <% Connection connection = DBConnectionHandler.getInstance().getConnection();
        PreparedStatement statement = null;
        PreparedStatement statement1 = null;
        ResultSet campaignNotJoined = null;
        ResultSet campaignJoined = null; %>
</head>
<body>
    <h1>Your Home</h1>

<%
    AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
    try {
    String query = Constants.CAMPAIGN_STARTED_JOINED;
    statement = connection.prepareStatement(query);
    statement.setInt(1, data.getUser_id());
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
        <td><%=campaignJoined.getDate("ts_end")%></td>
        <td><button formmethod="post" formaction="/something">Enter</button> </td></tr>
    <%    }
    %>

</table> <br>


<%

    String query2 = Constants.CAMPAIGN_NOT_JOINED;
    statement1 = connection.prepareStatement(query2);
    statement1.setInt(1, data.getUser_id());
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
        <td><%=campaignNotJoined.getDate("ts_end")%></td>
        <td><form action = "<%=Constants.PATH+"/registerCampaign?user="+ data.getUser_id() +"&campaign="+campaignNotJoined.getInt("campaign_id")%>" method = "post">
            <input type="submit" value="Sign Up" />
            </form> </td></tr>
    <%
        }
    %>

</table>

<a href="<%= Constants.PATH + "/userDetails.jsp?user_id=" + data.getUser_id()%>"><p>  Click for User Details</p></a>

<%
    statement.close();
    campaignNotJoined.close();
    campaignJoined.close();
    connection.close();
    } catch (Exception ex) {

    }
%>

    <form action = "<%=Constants.PATH+"/logout"%>" method = "post">
        <input type="submit" value="Logout" />
    </form>
</body>
</html>
