<%@ page import="Handler.DBConnectionHandler" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Util.Constants" %>
<%@ page import="Entities.AuthCookie" %>
<%@ page import="Handler.CookieHandler" %>
<%@ page import="Enum.Job" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="jquery-3.3.1.min.js"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css"
          integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
            integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"
            integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T"
            crossorigin="anonymous"></script>
    <script src="/Script/navjs.js"></script>
    <style>
        #title {
            color: white;
        }
    </style>
    <title>Worker HomePage</title>
    <% Connection connection = DBConnectionHandler.getInstance().getConnection();
        PreparedStatement statement = null;
        PreparedStatement statement1 = null;
        ResultSet campaignNotJoined = null;
        ResultSet campaignJoined = null; %>
</head>
<body>
<%
    AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
    if (!CookieHandler.getInstance().isSafe(request, response)) {
        return;
    }
    try {
        String query = Constants.CAMPAIGN_STARTED_JOINED;
        statement = connection.prepareStatement(query);
        statement.setInt(1, data.getUser_id());
        campaignJoined = statement.executeQuery();
%>
<div>
    <nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
        <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">PeakPlatform</a>
        <span id="title" class="nav-link" href="#">Home</span>
        <ul class="navbar-nav px-3">
            <li class="nav-item text-nowrap">
                <a class="nav-link" href="#" onclick="doLogout(<%=data.getUser_id()%>)">Log out</a>
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
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                     fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                     stroke-linejoin="round" class="feather feather-home">
                                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                    <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                </svg>
                                Home <span class="sr-only">(current)</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#" onclick="userDetailRedirect(<%=data.getUser_id()%>)">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                     fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                     stroke-linejoin="round" class="feather feather-users">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                </svg>
                                User Details
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                <div class="chartjs-size-monitor"
                     style="position: absolute; left: 0px; top: 0px; right: 0px; bottom: 0px; overflow: hidden; pointer-events: none; visibility: hidden; z-index: -1;">
                    <div class="chartjs-size-monitor-expand"
                         style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
                        <div style="position:absolute;width:1000000px;height:1000000px;left:0;top:0"></div>
                    </div>
                    <div class="chartjs-size-monitor-shrink"
                         style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
                        <div style="position:absolute;width:200%;height:200%;left:0; top:0"></div>
                    </div>
                </div>
                <div>
                    <h2>Campaigns joined</h2>
                    <table class="table" border>
                        <thead class="thead-dark">
                        <tr>
                            <th scope="col">Name</th>
                            <th scope="col">Creation Date</th>
                            <th scope="col">Last Update</th>
                            <th scope="col"></th>
                        </tr>
                        </thead>
                        <%
                            while (campaignJoined.next()) {
                        %>
                        <tr>
                            <td>
                                <%=campaignJoined.getString("campaign_name")%>
                            </td>
                            <td><%=campaignJoined.getDate("ts_begin")%>
                            </td>
                            <td><%=campaignJoined.getDate("ts_date")%>
                            </td>
                            <td>
                                <form action="<%=Constants.PATH%>/map2d"
                                      method="post">
                                    <input type="hidden" name="campaign"
                                           value="<%=campaignJoined.getInt("campaign_id")%>">
                                    <input type="hidden" name="job" value="<%=Job.WORKER.getId()%>">
                                    <button type="submit" class="btn btn-secondary">Enter</button>
                                </form>
                            </td>
                            <%-- redirect bottone enter sbagliato
                            <td><form id="enterForm" action="<%=Constants.PATH+"/map2d"%>" method="post">
                                <input type="hidden" name="campaign" value="<%=campaignJoined.getInt("campaign_id")%>">
                                <input type="hidden" name="job" value="1">
                            </form>
                                <button type="submit" class="btn btn-primary" form="enterForm">Enter</button> </td>--%>
                        </tr>
                        <% }
                        %>
                    </table>
                    <br>
                    <%
                        String query2 = Constants.CAMPAIGN_NOT_JOINED;
                        statement1 = connection.prepareStatement(query2);
                        statement1.setInt(1, data.getUser_id());
                        campaignNotJoined = statement1.executeQuery();
                    %>
                    <h2>Campaigns not joined</h2>
                    <table border class="table">
                        <thead class="thead-dark">
                        <tr>
                            <th scope="col">Name</th>
                            <th scope="col">Creation Date</th>
                            <th scope="col">Last Update</th>
                            <th scope="col"></th>
                        </tr>
                        </thead>

                        <%
                            while (campaignNotJoined.next()) {
                        %>
                        <tr>
                            <td>
                                    <%=campaignNotJoined.getString("campaign_name")%>
                            </td>
                            <td><%=campaignNotJoined.getDate("ts_begin")%>
                            </td>
                            <td><%=campaignNotJoined.getDate("ts_date")%>
                            </td>
                            <td>
                                <form action="<%=Constants.PATH+"/registerCampaign?user="+ data.getUser_id() +"&campaign="+campaignNotJoined.getInt("campaign_id")%>"
                                      method="post">
                                    <button type="submit" class="btn btn-secondary">Join</button>
                                </form>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </table>
                    <%
                            statement.close();
                            campaignNotJoined.close();
                            campaignJoined.close();
                            connection.close();
                        } catch (Exception ex) {

                        }
                    %>
                </div>
            </main>
        </div>
    </div>
</div>
</body>
</html>
