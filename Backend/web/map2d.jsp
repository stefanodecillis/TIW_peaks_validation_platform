<%@ page import="Entities.AuthCookie" %>
<%@ page import="Handler.CookieHandler" %>
<%@ page import="Util.Constants" %>
<%@ page import="Enum.Job" %>
<%--Created by IntelliJ IDEA.
  User: step
  Date: 13/07/2018
  Time: 12:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Mappa 2D</title>
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
<%
    AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
%>
<div>
    <nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
        <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">PeakPlatform</a>
        <ul class="navbar-nav px-3">
            <li class="nav-item text-nowrap">
                <a class="nav-link" href="#" onclick="doLogout(<%=data.getUser_id()%>)">Sign out</a>
            </li>
        </ul>
    </nav>
</div>
<br><br>

<!-- init data -->
<%
    int campaign = Integer.parseInt(request.getParameter("campaign"));
    int job = Integer.parseInt(request.getParameter("job"));
%>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<div id="mapid"></div>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.1/dist/leaflet.css"
      integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ=="
      crossorigin=""/>
<!-- Make sure you put this AFTER Leaflet's CSS -->
<script src="https://unpkg.com/leaflet@1.3.1/dist/leaflet.js"
        integrity="sha512-/Nsx9X4HebavoBvEBuyp3I7od5tA0UzAxs+j83KgC8PU0kgB4XiK4Lfe4y4cgBtaRJQEIFCW+oC506aPT2L1zw=="
        crossorigin=""></script>
<link rel="stylesheet" href="/StyleSheets/styletesting.css">
<link rel="stylesheet" href="/node_modules/leaflet.markercluster/dist/MarkerCluster.css">
<link rel="stylesheet" href="/node_modules/leaflet.markercluster/dist/MarkerCluster.Default.css">
<script src="/node_modules/leaflet.markercluster/dist/leaflet.markercluster.js"></script>
<!--<script src="/Script/jstesting.js"></script>-->


<!-- guarda https://github.com/Leaflet/Leaflet.markercluster -->
<script>
    var mymap = L.map('mapid').setView([41.277733, 16.4101], 5);
    L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
        attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
        maxZoom: 18,
        id: 'mapbox.streets',
        accessToken: 'pk.eyJ1Ijoic3RlZmFubzk2IiwiYSI6ImNqaHhrd2M5dzBic3czcm55eXU3ODBmMGIifQ.5QLpFduGJVrWHk032DinKg'
    }).addTo(mymap);
    var user = "user: <%=data.getUser_id()%>";
    //created costructor
    var LeafIcon = L.Icon.extend({
        options: {
            iconSize: [28, 45],  //size of marker
            shadowSize: [50, 64],
            iconAnchor: [22, 94],
            shadowAnchor: [4, 62],
            popupAnchor: [-3, -76]
        }
    });

    //create icon
    var greenIcon = new LeafIcon({
        iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-green.png'
    });
    var redIcon = new LeafIcon({
        iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png'
    });
    var yellowIcon = new LeafIcon({
        iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-yellow.png'
    });
    var orangeIcon = new LeafIcon({
        iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-orange.png'
    });


    var myIcon = L.divIcon({className: 'my-div-icon'});
    // you can set .my-div-icon styles in CSS
    var markers = L.markerClusterGroup();
    //var marker = L.marker([element.longitude, element.latitude]).addTo(mymap);
    var campaign = <%=campaign%>;
    var servletUrl = "<%=Constants.PATH +"/annotationcontroller"%>";
    var annJspUrl = "<%=Constants.PATH +"/annotationsdetails"%>";

    <% //worker
                if (job == Job.WORKER.getId()){%>
    $.ajax({
        type: 'GET',
        url: 'campaign/getpeaks?campaign=<%=campaign%>&job=<%=job%>',
        data: {get_param: 'value'},
        dataType: 'json',
        success: function (data) {
            mymap.addLayer(markers);
            $.each(data, function (index, element) {
                console.log("peaks");

                markers.addLayer(L.marker([element.latitude, element.longitude]).bindPopup(
                    '<form id="peakForm" action="' + servletUrl + '" method="post" > ' +
                    '<label>Nome:' + element.name + '</label><br>' +
                    '<label>Sorgente:' + element.provenance + '</label><br>' +
                    '<label>Elevazione:' + element.elevation + '</label><br>' +
                    '<label>Longitudine:' + element.longitude + '</label><br>' +
                    '<label>Latitudine:' + element.latitude + '</label><br>' +
                    '<label>Localized Names:' + element.localized_name + '</label><br>' +
                    '<input type="hidden" name="peakId" value="' + element.peak_id + '">' +
                    '<input type="hidden" name="campaign" value="' + campaign + '">' +
                    '<input type="hidden" name="peakName" value="' + element.name + '"> ' +
                    '<input type="hidden" name="localizedNames" value="' + element.localized_name + '" > ' +
                    '<input type="hidden" name="latitude" value="' + element.latitude + '"> ' +
                    '<input type="hidden" name="longitude" value="' + element.longitude + '"> ' +
                    '<input type="hidden" name="elevation" value="' + element.elevation + '"> ' +
                    '<input type="hidden" name="map" value="2"> ' +
                    '</form>' +
                    '<button type="submit" form="peakForm" name="validation" value="1" >Valida</button>' +
                    '<button type="submit" form="peakForm" name="validation" value="0">Invalida</button>'));
            });
        }
    });

    <%}
                //manager
                else if (job == Job.MANAGER.getId()) {%>
    $.ajax({
        type: 'GET',
        url: 'campaign/getpeaks?campaign=<%=campaign%>&job=<%=job%>',
        data: {get_param: 'value'},
        dataType: 'json',
        success: function (data) {
            mymap.addLayer(markers);
            $.each(data, function (index, element) {
                console.log("peaks");

                if (element.validation_status_id == 2) {
                    var marker = L.marker([element.latitude, element.longitude], {icon: greenIcon});
                } else if (element.num_negative_annotations > 0) {
                    var marker = L.marker([element.latitude, element.longitude], {icon: redIcon});
                } else if (element.num_positive_annotations > 0) {
                    var marker = L.marker([element.latitude, element.longitude], {icon: orangeIcon});
                } else {
                    var marker = L.marker([element.latitude, element.longitude], {icon: yellowIcon});
                }

                var totAnn = element.num_negative_annotations + element.num_positive_annotations;
                if (totAnn > 0) {
                    marker.bindPopup(
                        '<form method="POST" id="managerPopupForm" action= "' + annJspUrl + '">' +
                        '<label>Nome:' + element.name + '</label><br>' +
                        '<label>Sorgente:' + element.provenance + '</label><br>' +
                        '<label>Elevazione:' + element.elevation + '</label><br>' +
                        '<label>Longitudine:' + element.longitude + '</label><br>' +
                        '<label>Latitudine:' + element.latitude + '</label><br>' +
                        '<label>Localized Names:' + element.localized_name + '</label><br>' +
                        '<label>Annotations: ' + totAnn + '</label><br>' +
                        '<input type="hidden" name="peakId" value="' + element.peak_id + '">' +
                        '<input type="hidden" name="campaign" value="' + campaign + '">' +
                        '<input type="hidden" name="peakName" value="' + element.name + '"> ' +
                        '<input type="hidden" name="localizedNames" value="' + element.localized_name + '" > ' +
                        '<input type="hidden" name="elevation" value="' + element.elevation + '"> ' +
                        '</form>' +
                        '<button type="submit" form="managerPopupForm" name="annListBtn">Annotations Details</button>');
                } else {
                    marker.bindPopup(
                        '<label>Nome:' + element.name + '</label><br>' +
                        '<label>Sorgente:' + element.provenance + '</label><br>' +
                        '<label>Elevazione:' + element.elevation + '</label><br>' +
                        '<label>Longitudine:' + element.longitude + '</label><br>' +
                        '<label>Latitudine:' + element.latitude + '</label><br>' +
                        '<label>Localized Names:' + element.localized_name + '</label><br>' +
                        '<label>Annotations: ' + totAnn + '</label><br>');
                }

                markers.addLayer(marker);

            });

        }
    });
    <%}
                %>
    mymap.addLayer(markers);
</script>
<form name="to3dForm" align="right" method="POST"
      action="<%=Constants.PATH%>/map3d.jsp?campaign=<%=request.getParameter("campaign")%>&job=<%=request.getParameter("job")%>">
    <input type="submit" value="3D map" name="to3dMap">
</form>
</body>
</html>




