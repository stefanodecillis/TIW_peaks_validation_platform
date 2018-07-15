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
</head>
<body>

<!-- init data -->
<%
    int campaign = Integer.parseInt(request.getParameter("campaign"));
    AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
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
            iconSize:     [28, 45],  //size of marker
            shadowSize:   [50, 64],
            iconAnchor:   [22, 94],
            shadowAnchor: [4, 62],
            popupAnchor:  [-3, -76]
        }
    });

    //create icon
    var greenIcon = new LeafIcon({
        iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-green.png'
    });

    $.ajax({
        type: 'GET',
        url: 'campaign/getpeaks?campaign=<%=campaign%>',
        data: { get_param: 'value' },
        dataType: 'json',
        success: function (data) {
            var myIcon = L.divIcon({className: 'my-div-icon'});
// you can set .my-div-icon styles in CSS
            var markers = L.markerClusterGroup();

            mymap.addLayer(markers);
            $.each(data, function(index, element) {
                //var marker = L.marker([element.longitude, element.latitude]).addTo(mymap);
                var campaign = <%=campaign%>;
                var servletUrl = "<%=Constants.PATH +"/annotationcontroller"%>";
                console.log(user);
                <% //worker
                if (job == Job.WORKER.getId()){%>
                    markers.addLayer(L.marker([element.latitude, element.longitude]).bindPopup(
                    '<form id="peakForm" action="'+servletUrl+'" method="post" > ' +
                    '<label>Nome:'+ element.name + '</label><br>'+
                    '<label>Sorgente:'+ element.provenance + '</label><br>'+
                    '<label>Elevazione:'+ element.elevation + '</label><br>'+
                    '<label>Longitudine:'+ element.longitude + '</label><br>'+
                    '<label>Latitudine:'+ element.latitude + '</label><br>'+
                    '<label>Localized Names:'+ element.localized_name + '</label><br>'+
                    '<input type="hidden" name="peakId" value="'+element.peak_id+'">' +
                    '<input type="hidden" name="campaign" value="'+campaign+'">' +
                    '<input type="hidden" name="peakName" value="'+ element.name +'"> '+
                    '<input type="hidden" name="localizedNames" value="'+ element.localized_name +'" > '+
                    '<input type="hidden" name="latitude" value="'+ element.latitude +'"> '+
                    '<input type="hidden" name="longitude" value="'+ element.longitude +'"> '+
                    '<input type="hidden" name="elevation" value="'+ element.elevation +'"> '+
                    '</form>' +
                    '<button type="submit" form="peakForm" name="validation" value="1" >Valida</button>'+
                    '<button type="submit" form="peakForm" name="validation" value="0">Invalida</button>'));
                <%}
                //manager
                else if (job == Job.MANAGER.getId()) {%>
                    if(element.validation_status_id == 2){
                        var marker = L.marker([element.latitude,element.longitude], {icon: greenIcon});
                    } else {
                        var marker = L.marker([element.latitude, element.longitude]);
                    }
                    marker.bindPopup(
                    '<label>Nome:'+ element.name + '</label><br>'+
                    '<label>Sorgente:'+ element.provenance + '</label><br>'+
                    '<label>Elevazione:'+ element.elevation + '</label><br>'+
                    '<label>Longitudine:'+ element.longitude + '</label><br>'+
                    '<label>Latitudine:'+ element.latitude + '</label><br>'+
                    '<label>Localized Names:'+ element.localized_name + '</label><br>');
                    markers.addLayer(marker);
                <%}
                %>
            });
            mymap.addLayer(markers);
        }
    });</script>
<br>
<form name="to3dForm" align="right" method="POST" action="<%=Constants.PATH%>/map3d.jsp?campaign=<%=request.getParameter("campaign")%>&job=<%=request.getParameter("job")%>">
<input type="submit"  value="3D map" name="to3dMap">
</form>
</body>
</html>




