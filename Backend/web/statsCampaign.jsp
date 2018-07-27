<%@ page import="Handler.CookieHandler" %>
<%@ page import="Entities.AuthCookie" %><%--
  Created by IntelliJ IDEA.
  User: step
  Date: 15/07/2018
  Time: 19:01
  To change this template use File | Settings | File Templates.
--%>
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
    <title>Campaign Stats</title>
    <link rel="stylesheet" href="/StyleSheets/statsStyle.css">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

</head>
<body>

<%
    int campaign = Integer.parseInt(request.getParameter("campaign"));
    AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
%>
<div>
    <nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
        <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">PeakPlatform</a>
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
                    <div class="external">
                        <div class="internal">
                            <h3> Number of Peaks with 0 Annotations: </h3>
                            <br>
                            <br>
                            <p class="result" id="counter1"></p>
                        </div>
                        <div class="internal">
                            <h3> Number of Peaks with 1 or more Annotations:</h3>
                            <br>
                            <br>
                            <p class="result" id="counter2"></p>
                        </div>
                        <div class="internal">
                            <h3> Number of Peaks with at least 1 Annotation Rejected: </h3>
                            <br>
                            <br>
                            <p class="result" id="counter3"></p>
                        </div>
                        <div class="internal">
                            <h3> Number of Conflicts:</h3>
                            <br>
                            <br>
                            <p class="result" id="counter4"></p>
                        </div>
                    </div>
                    <div class="external">
                        <div class="internal">
                            <button id="btn1" type="button" class="btn btn-primary">Peaks with Annotations List</button>
                            <div id="box1"></div>
                            <div id="boxResult1"></div>
                        </div>
                        <div class="internal">
                            <button id="btn2" type="button" class="btn btn-primary">Peaks with at least 1 Annotation Rejected List
                            </button>
                            <div id="box2"></div>
                        </div>
                        <div  class="internal">
                            <button id="btn3" type="button" class="btn btn-primary">Peaks with Conflict Annotations List </button>
                            <div id="box3"></div>
                        </div>
                    </div>
                    <br>
                    <div id="boxResult" class="external" align="center">
                        <div id="boxResultPeak" align="center">
                        </div>
                        <br>
                        <div id="boxResultDetails" align="center" class="chartjs-size-monitor">
                        </div>
                    </div>
                </div>

                <script>
                    var btn1 = document.getElementById('btn1');
                    var btn2 = document.getElementById('btn2');
                    var btn3 = document.getElementById('btn3');

                    btn1.onclick = function () {
                        cleanBoxResult();
                        var box = document.getElementById('boxResultPeak');
                        var list = document.createElement('table');
                        list.classList.add('table');

                        $.ajax({
                            type: 'GET',
                            url: 'stats-api?campaign=<%=campaign%>&stat=5&depth=1',
                            dataType: 'json',
                            success: function (data) {
                                $.each(data, function (index, element) {
                                    var tr = document.createElement('tr');
                                    var td = document.createElement('td');
                                    var btn = document.createElement('button');
                                    var text = document.createTextNode(element.peak_id);
                                    btn.appendChild(text);
                                    btn.onclick = function () {
                                        getAnnotation(element.peak_id, 1);
                                    }
                                    td.appendChild(btn);
                                    tr.appendChild(td);
                                    list.appendChild(tr);
                                });

                            }
                        });
                        box.appendChild(list);
                    };

                    btn2.onclick = function () {

                        cleanBoxResult()
                        var box = document.getElementById('boxResultPeak');
                        var list = document.createElement('table');
                        list.classList.add('table');

                        $.ajax({
                            type: 'GET',
                            url: 'stats-api?campaign=<%=campaign%>&stat=6&depth=1',
                            dataType: 'json',
                            success: function (data) {
                                $.each(data, function (index, element) {
                                    var tr = document.createElement('tr');
                                    var td = document.createElement('td');
                                    var btn = document.createElement('button');
                                    var text = document.createTextNode(element.peak_id);
                                    btn.appendChild(text);
                                    btn.onclick = function () {
                                        getAnnotation(element.peak_id, 2);
                                    }
                                    td.appendChild(btn);
                                    tr.appendChild(td);
                                    list.appendChild(tr);
                                });

                            }
                        });
                        box.appendChild(list);
                    };

                    btn3.onclick = function () {
                        cleanBoxResult();
                        var box = document.getElementById('boxResultPeak');
                        var list = document.createElement('table');
                        list.classList.add('table');

                        var tbody = document.createElement('tbody');

                        $.ajax({
                            type: 'GET',
                            url: 'stats-api?campaign=<%=campaign%>&stat=7',
                            dataType: 'json',
                            success: function (data) {
                                $.each(data, function (index, element) {
                                    var tr = document.createElement('tr');

                                    var fieldCell = document.createElement('td');
                                    var field = document.createTextNode((index + 1) + ")");
                                    fieldCell.style.width = "10px";
                                    fieldCell.appendChild(field);
                                    tr.appendChild(fieldCell);

                                    var td = document.createElement('td');
                                    td.appendChild(document.createTextNode(element.peak_id));
                                    tr.appendChild(td);
                                    td = document.createElement('td');

                                    //positive annotations
                                    fieldCell = document.createElement('td');
                                    field = document.createTextNode('# positive annotations: ');
                                    fieldCell.appendChild(field);
                                    tr.appendChild(fieldCell);

                                    td.appendChild(document.createTextNode(element.num_positive_annotations));
                                    tr.appendChild(td);
                                    td = document.createElement('td');

                                    //negative annotations
                                    fieldCell = document.createElement('td');
                                    field = document.createTextNode('# negative annotations: ');
                                    fieldCell.appendChild(field);
                                    tr.appendChild(fieldCell);
                                    td.appendChild(document.createTextNode(element.num_negative_annotations));
                                    tr.appendChild(td);

                                    tbody.appendChild(tr);
                                });

                            }
                        });
                        list.appendChild(tbody);
                        box.appendChild(list);
                    };

                    function getAnnotation(peakId, apiRequest) {
                        var box2 = document.getElementById('boxResultDetails');
                        while (box2.hasChildNodes()) {
                            box2.removeChild(box2.firstChild);
                        }
                        var list = document.createElement('table');
                        list.classList.add('table');
                        list.style.justifyContent = "flex-start";

                        //choose api

                        var urlData;
                        if (apiRequest == 1) {
                            urlData = 'stats-api?campaign=<%=campaign%>&stat=5&depth=2&peak=' + peakId;
                        } else if (apiRequest == 2) {
                            urlData = 'stats-api?campaign=<%=campaign%>&stat=6&depth=2&peak=' + peakId;
                        }
                        var tbody = document.createElement('tbody');
                        tbody.style.justifyContent = "flex-start";
                        $.ajax({
                            type: 'GET',
                            url: urlData,
                            dataType: 'json',
                            success: function (data) {
                                var thtr = document.createElement('tr');
                                var indexth = document.createElement('th');
                                var usernameth = document.createElement('th');
                                var validationth = document.createElement('th');
                                var elevationth = document.createElement('th');
                                var latitudeth = document.createElement('th');
                                var longitudeth = document.createElement('th');
                                var locNamesth = document.createElement('th');
                                var peakNameth = document.createElement('th');

                                indexth.appendChild(document.createTextNode(''));
                                usernameth.appendChild(document.createTextNode('Username'));
                                validationth.appendChild(document.createTextNode('Validation'));
                                peakNameth.appendChild(document.createTextNode('Peak Name'));
                                locNamesth.appendChild(document.createTextNode('Localized Names'));
                                elevationth.appendChild(document.createTextNode('Elevation'));
                                latitudeth.appendChild(document.createTextNode('Latitude'));
                                longitudeth.appendChild(document.createTextNode('Longitude'));

                                thtr.appendChild(indexth);
                                thtr.appendChild(usernameth);
                                thtr.appendChild(validationth);
                                thtr.appendChild(peakNameth);
                                thtr.appendChild(locNamesth);
                                thtr.appendChild(elevationth);
                                thtr.appendChild(latitudeth);
                                thtr.appendChild(longitudeth);
                                tbody.appendChild(thtr);
                                $.each(data, function (index, element) {
                                    if (element.validation == 2) {
                                        createRowForTable(tbody, element.username, "Valid", element.elevation, element.latitude.toFixed(2), element.longitude.toFixed(2), element.localized_names, element.peak_name, index + 1);
                                        createRowForTable(tbody, null);
                                    } else {
                                        createRowForTable(tbody, element.username, "Invalid", element.elevation, element.latitude.toFixed(2), element.longitude.toFixed(2), element.localized_names, element.peak_name, index + 1);
                                        createRowForTable(tbody, null);
                                    }
                                });

                            }
                        });

                        list.appendChild(tbody);
                        box2.appendChild(list);
                    };

                    function createRowForTable(table, username, validation, elevation, latitude, longitude, localizedNames, peakName, index) {

                        if (username == null) {
                            var tr = document.createElement('tr');
                            var td = document.createElement('td');
                            var text = document.createElement('br');
                            td.appendChild(text);
                            table.appendChild(tr);
                        } else {
                            var tr = document.createElement('tr');
                            var indexRow = document.createTextNode(index + ")");
                            var indexCell = document.createElement('td');
                            indexCell.appendChild(indexRow)
                            tr.appendChild(indexCell);

                            var username = document.createTextNode(username);
                            var validation = document.createTextNode(validation);
                            var elevation = document.createTextNode(elevation);
                            var latitude = document.createTextNode(latitude);
                            var longitude = document.createTextNode(longitude);
                            var peakName = document.createTextNode(peakName);
                            var localizedNames = document.createTextNode(localizedNames);

                            var usernameTd = document.createElement('td');
                            var validationTd = document.createElement('td');
                            var elevationTd = document.createElement('td');
                            var latitudeTd = document.createElement('td');
                            var longitudeTd = document.createElement('td');
                            var peakNameTd = document.createElement('td');
                            var localizedNamesTd = document.createElement('td');

                            usernameTd.appendChild(username);
                            validationTd.appendChild(validation);
                            elevationTd.appendChild(elevation);
                            latitudeTd.appendChild(latitude);
                            longitudeTd.appendChild(longitude);
                            peakNameTd.appendChild(peakName);
                            localizedNamesTd.appendChild(localizedNames);

                            //username

                            tr.appendChild(usernameTd);

                            //validation



                            tr.appendChild(validationTd);

                            //peakName



                            tr.appendChild(peakNameTd);

                            //localizedNames



                            tr.appendChild(localizedNamesTd);

                            //elevation



                            tr.appendChild(elevationTd);

                            //latitude



                            tr.appendChild(latitudeTd);

                            //longitude


                            tr.appendChild(longitudeTd);

                            tr.style.height = "4px";

                            table.appendChild(tr);
                        }
                    };

                    function init() {
                        var counter1 = document.getElementById('counter1');
                        $.ajax({
                            type: 'GET',
                            url: 'stats-api?campaign=<%=campaign%>&stat=1',
                            dataType: 'json',
                            success: function (data) {
                                counter1.textContent = data;
                            }
                        });
                        var counter2 = document.getElementById('counter2');
                        $.ajax({
                            type: 'GET',
                            url: 'stats-api?campaign=<%=campaign%>&stat=2',
                            dataType: 'json',
                            success: function (data) {
                                counter2.textContent = data;
                            }
                        });
                        var counter3 = document.getElementById('counter3');
                        $.ajax({
                            type: 'GET',
                            url: 'stats-api?campaign=<%=campaign%>&stat=3',
                            dataType: 'json',
                            success: function (data) {
                                counter3.textContent = data;
                            }
                        });
                        var counter4 = document.getElementById('counter4');
                        $.ajax({
                            type: 'GET',
                            url: 'stats-api?campaign=<%=campaign%>&stat=4',
                            dataType: 'json',
                            success: function (data) {
                                counter4.textContent = data;
                            }
                        });
                    };

                    function cleanBoxResult() {
                        var box = document.getElementById('boxResultDetails');
                        while (box.hasChildNodes()) {
                            box.removeChild(box.firstChild);
                        }
                        box = document.getElementById('boxResultPeak');
                        while (box.hasChildNodes()) {
                            box.removeChild(box.firstChild);
                        }
                    };

                    init();
                </script>
            </main>
        </div>
    </div>
</div>
</body>
</html>
