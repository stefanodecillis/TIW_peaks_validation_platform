<%@ page import="java.sql.Connection" %>
<%@ page import="Handler.DBConnectionHandler" %>
<%@ page import="Util.Constants" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Handler.CookieHandler" %><%--
  Created by IntelliJ IDEA.
  User: step
  Date: 30/05/2018
  Time: 19:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="jquery-3.3.1.min.js"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>
    <script src="/Script/navjs.js"></script>
    <%
        Connection connection = DBConnectionHandler.getInstance().getConnection();
        if(!CookieHandler.getInstance().isSafe(request,response)){
            return;
        }
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
<div>
    <nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
        <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">PeakPlatform</a>
        <ul class="navbar-nav px-3">
            <li class="nav-item text-nowrap">
                <a class="nav-link" href="#" onclick="doLogout(<%=user_id%>)">Sign out</a>
            </li>
        </ul>
    </nav>
    <br><br>
    <div class="container-fluid">
        <div class="row">
            <nav class="col-md-2 d-none d-md-block bg-light sidebar">
                <div class="sidebar-sticky">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="#" onclick="returnHome()">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-home"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                                Home <span class="sr-only">(current)</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#" onclick="userDetailRedirect(<%=user_id%>)">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-users"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                User Details
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4"><div class="chartjs-size-monitor" style="position: absolute; left: 0px; top: 0px; right: 0px; bottom: 0px; overflow: hidden; pointer-events: none; visibility: hidden; z-index: -1;"><div class="chartjs-size-monitor-expand" style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;"><div style="position:absolute;width:1000000px;height:1000000px;left:0;top:0"></div></div><div class="chartjs-size-monitor-shrink" style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;"><div style="position:absolute;width:200%;height:200%;left:0; top:0"></div></div></div>
                <div>
                    <h2 align="center"><%=rs.getString("campaign_name")%></h2>
                    <br><br>
                    <table class="table" border>
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
                    <div class="formBtnClass">

                    <form id="firstForm" action = "<%=Constants.PATH+"/campaignstatuscontroller"%>" method = "post">
                        <input type="hidden" name="campaign" value="<%=campaign_id%>">
                        <input type="hidden" name="status" value="2">
                    </form>
                    <form action = "<%=Constants.PATH+"/inputdataform"%>" id="secondForm" method = "post">
                        <input type="hidden" name="campaign" value="<%=campaign_id%>">
                    </form>
                        <button type="submit" class="btn btn-primary" id="firstBtn" form="firstForm">Avvia</button>
                        <button type="submit" class="btn btn-info" id="secondBtn" form="secondForm">Carica Picchi</button>
                    </div>
                    <%
                    } else if(status == 2){
                    %>
                    <div class="formBtnClass">
                    <form id="mapForm" action = "<%=Constants.PATH + "/map2d"%>" method = "post">
                        <input type="hidden" name="campaign" value="<%=campaign_id%>">
                        <input type="hidden" name="job" value="2">
                    </form>
                    <form id="closeForm" action = "<%=Constants.PATH+"/campaignstatuscontroller"%>" method = "post">
                        <input type="hidden" name="campaign" value="<%=campaign_id%>">
                        <input type="hidden" name="status" value="2">
                    </form>
                        <button type="submit" class="btn btn-info" id="firstBtn2" form="mapForm">Mostra Mappa</button>
                        <button type="submit" class="btn btn-danger" id="secondBtn2" form="closeForm">Chiudi</button>
                    </div>
                    <%
                    } else if (status == 3){
                    %>
                    <form action = "<%=Constants.PATH+"/something"%>" method = "post"> <!-- TODO need to finish here -->
                        <input type="hidden" name="campaign" value="<%=campaign_id%>">
                        <input type="submit" class="btn btn-success" value="Visualizza Dettagli" />
                    </form>
                    <%
                        }
                    %>
                    <%
                        }
                    %>
                </div>
            </main>
        </div>
    </div>
</div>

</body>
<%
    } //close try scope
    catch (SQLException e){
        e.printStackTrace();
    }
%>
</html>
