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
    <title>User Details</title>
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
</head>
<body>

<% Connection connection = DBConnectionHandler.getInstance().getConnection();
    AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
    PreparedStatement statement = null;
    ResultSet user_appResultSet = null; %>
<%
    try {
        String query = Constants.USER_DETAILS;
        statement = connection.prepareStatement(query);
        statement.setInt(1, data.getUser_id());
        user_appResultSet = statement.executeQuery();
%>
<nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">PeakPlatform</a>
    <ul class="navbar-nav px-3">
        <li class="nav-item text-nowrap">
            <a class="nav-link" href="#" onclick="doLogout(<%=data.getUser_id()%>)">Sign out</a>
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
                <h1>User Details</h1>
                <br>
                <table class="table" border>
                    <thead class="thead-dark">
                    <tr>
                        <th scope="col">Username</th>
                        <th scope="col">Email</th>
                    </tr>
                    </thead>
                    <%
                        while (user_appResultSet.next()) {
                            System.out.println("...retrieving data...");
                    %>

                    <tr>
                        <td><%=user_appResultSet.getString("username")%>
                        </td>
                        <td><%=user_appResultSet.getString("mail")%>
                        </td>
                    </tr>
                    <%
                        }
                    %>

                </table>
            </div>

            <form action="<%= Constants.PATH + "/modifyUserDetails.jsp?user_id=" + data.getUser_id()%>" method="post">
                <input type="submit" class="btn btn-primary" value="Modify User Details"/>
            </form>

                <%
                statement.close();
                user_appResultSet.close();
                connection.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                %>
    </div>
    </main>
</div>
</body>
</html>