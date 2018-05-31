<%@ page import="java.sql.Connection" %>
<%@ page import="Handler.DBConnectionHandler" %>
<%@ page import="Util.Constants" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: step
  Date: 30/05/2018
  Time: 19:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%
        Connection connection = DBConnectionHandler.getInstance().getConnection();
        if(request.getParameter("campaign") == null || request.getParameter("campaign").equalsIgnoreCase("")){
            response.sendRedirect(Constants.PATH+"/peakplatform");
            return;
        }
        int campaign_id = Integer.parseInt(request.getParameter("campaign"));
        int user_id = Integer.parseInt(request.getParameter("user"));
        try {
            PreparedStatement statement = connection.prepareStatement(Constants.SELECT_CAMPAIGN_BY_ID_CAMPAIGN_OWNER);
            statement.setInt(1, campaign_id);
            statement.setInt(2, user_id);
            ResultSet rs = statement.executeQuery();
            while(rs.next()) {
    %>
    <title><%=rs.getString("campaign_name")%></title>
</head>
<body>
<h2><%=rs.getString("campaign_name")%></h2>
<br><br>
<table border>

    <tr>
        <td colspan="3">Creation Date</td>
        <td><%=rs.getString("ts_date")%></td>
    </tr>
    <tr>
        <td colspan="3"> ID </td>
        <td><%=rs.getString("campaign_id")%></td>
    </tr>
    <tr>
        <td colspan="3">Status</td>
        <td>
            <%
                String statusTxt = null;
                int status = Integer.parseInt(rs.getString("campaign_status_id"));
                if(status == 1){
                    statusTxt = "Creata";
                } else if(status == 2){
                    statusTxt = "Avviata";
                } else if (status == 3){
                    statusTxt = "Chiusa";
                }
            %>
            <%=statusTxt%>
        </td>
    </tr>
</table>
<%
    if(status == 1){
       %>
            <form action = "<%=Constants.PATH+"/campaignstatuscontroller"%>" method = "post">
                <input type="hidden" name="campaign" value="<%=campaign_id%>">
                <input type="hidden" name="status" value="2">
                <input type="submit" value="Avvia" />
            </form>
        <%
    } else if(status == 2){
        %>
            <form action = "<%=Constants.PATH+"/campaignstatuscontroller"%>" method = "post">
                 <input type="hidden" name="campaign" value="<%=campaign_id%>">
                 <input type="hidden" name="status" value="2">
                 <input type="submit" value="Chiudi" />
            </form>
        <%
    } else if (status == 3){
        %>
            <form action = "<%=Constants.PATH+"/something"%>" method = "post">
                <input type="hidden" name="campaign" value="<%=campaign_id%>">
                <input type="submit" value="Visualizza Dettagli" />
            </form>
        <%
    }
        %>
<%
    }
%>
</body>
<%
    } //close try scope
    catch (SQLException e){
        e.printStackTrace();
    }
%>
</html>
