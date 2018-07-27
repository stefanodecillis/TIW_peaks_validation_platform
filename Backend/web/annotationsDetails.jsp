<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="Handler.DBConnectionHandler" %>
<%@ page import="Util.Constants" %>
<%@ page import="Handler.CookieHandler" %>
<%@ page import="Entities.AuthCookie" %>
<%@ page import="Enum.Job" %>
<%@ page import="Enum.AnnotationManagerStatus" %><%--
  Created by IntelliJ IDEA.
  User: Paolo De Santis
  Date: 22/07/2018
  Time: 17:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Annotations Details</title>
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
    <% Connection connection = DBConnectionHandler.getInstance().getConnection();
        PreparedStatement statement = null;
        ResultSet rs = null; %>
</head>
<body>
<%
    AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
    if (!CookieHandler.getInstance().isSafe(request, response)) {
        return;
    }
    try {
        String query = Constants.ANNOTATIONLIST;
        statement = connection.prepareStatement(query);
        statement.setInt(1, Integer.parseInt(request.getParameter("campaign")));
        statement.setInt(2, Integer.parseInt(request.getParameter("peakId")));
        rs = statement.executeQuery();
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
                    <h1>List of Annotations about:</h1>
                    <br>
                    <h4>Peak ID: <%=request.getParameter("peakId")%>
                    </h4>
                    <h4> Name: <%=request.getParameter("peakName")%>
                    </h4>
                    <h4>Elevation: <%=request.getParameter("elevation")%>
                    </h4>
                    <h4>Localized Names: <%=request.getParameter("localizedNames")%>
                    </h4>
                    <h4>Campaign ID: <%=request.getParameter("campaign")%>
                    </h4><br>

                    <table class="table" border>
                        <thead class="thead-dark">
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">User ID</th>
                            <th scope="col">Username</th>
                            <th scope="col">Validation</th>
                            <th scope="col">Elevation</th>
                            <th scope="col">Name</th>
                            <th scope="col">Localized Names</th>
                            <th scope="col"></th>
                        </tr>
                        </thead>

                        <%
                            while (rs.next()) {
                        %>

                        <tr>
                            <td><%=rs.getDate("timeslot_date")%>
                            </td>
                            <td><%=rs.getInt("user_id")%>
                            </td>
                            <td><%=rs.getString("username")%>
                            </td>
                            <td><%=rs.getInt("validation")%>
                            </td>
                            <td><%=rs.getInt("elevation")%>
                            </td>
                            <td><%=rs.getString("peak_name")%>
                            </td>
                            <td><%=rs.getString("localized_names")%>
                            </td>
                            <td>
                                <%
                                    if (rs.getInt("validation_status_id") == AnnotationManagerStatus.REFUSED.getId()) {
                                %>
                                Rejected
                                <%
                                } else {
                                %>
                                <form id="deleteAnnForm" action="<%=Constants.PATH%>/rejectAnnotationService"
                                      method="POST">
                                    <input type="hidden" name="annotation_id" value="<%=rs.getInt("annotation_id")%>">
                                    <input type="hidden" name="elevation"
                                           value="<%=request.getParameter("elevation")%>">
                                    <input type="hidden" name="localizedNames"
                                           value="<%=request.getParameter("localizedNames")%>">
                                    <input type="hidden" name="peakName" value="<%=request.getParameter("peakName")%>">
                                    <input type="hidden" name="peakId" value="<%=request.getParameter("peakId")%>">
                                    <input type="hidden" name="campaign" value="<%=request.getParameter("campaign")%>">
                                    <input type="submit" class="btn btn-danger" name="rejectBtn" value="Reject">
                                </form>
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                        <%
                            }
                        %>

                    </table>
                    <p>Validation = 0 : Invalid Annotation</p>
                    <p>Validation = 1 : Valid Annotation </p>


                        <%
        statement.close();
        rs.close();
        connection.close();
    } catch (Exception ex) {

    }

%>
                    <form id="to2dForm" method="POST"
                          action="<%=Constants.PATH%>/map2d.jsp?campaign=<%=request.getParameter("campaign")%>&job=<%=Job.MANAGER.getId()%>">
                        <input type="submit" class="btn btn-info" value="Return to 2D map" name="to2dMap">
                    </form>
                    <form id="to3dForm" method="POST"
                          action="<%=Constants.PATH%>/map3d.jsp?campaign=<%=request.getParameter("campaign")%>&job=<%=Job.MANAGER.getId()%>">
                        <input type="submit" class="btn btn-info" value="Return to 3D map" name="to3dMap">
                    </form>
            </main>
        </div>
    </div>
</div>
</div>
</body>
</html>
