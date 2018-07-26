<%@ page import="Handler.CookieHandler" %>
<%@ page import="Entities.AuthCookie" %>
<%@ page import="Util.Constants" %>
<%@ page import="Enum.*" %><%--
  Created by IntelliJ IDEA.
  User: step
  Date: 02/06/2018
  Time: 19:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- Use correct character set. -->
    <meta charset="utf-8">
    <!-- Tell IE to use the latest, best version. -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Make the application on mobile take up the full browser screen and disable user scaling. -->
    <meta name="viewport"
          content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
    <title>Map 3D</title>
    <script src="/Script/cesium-workshop-master/ThirdParty/Cesium/Cesium.js"></script>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <style>
        @import url(/Script/cesium-workshop-master/ThirdParty/Cesium/Widgets/widgets.css);

        html, body, #cesiumContainer {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
            overflow: hidden;
        }
    </style>

    <%
        int campaign = Integer.parseInt(request.getParameter("campaign"));
        AuthCookie data = CookieHandler.getInstance().checkCookieUser(request);
        int job = Integer.parseInt(request.getParameter("job"));
    %>

</head>
<body>
<div id="cesiumContainer"></div>
<script>
    var viewer = new Cesium.Viewer('cesiumContainer');
    viewer._infoBox.frame.sandbox = "allow-same-origin allow-top-navigation allow-pointer-lock allow-popups allow-forms allow-scripts";
    viewer.terrainProvider = Cesium.createWorldTerrain();
    viewer.infoBox.frame.sandbox = "allow-same-origin allow-top-navigation allow-pointer-lock allow-popups allow-forms allow-scripts";
    var terrainProvider = Cesium.createWorldTerrain({
        requestVertexNormals: true
    });
    viewer.terrainProvider = terrainProvider;
    viewer.scene.globe.enableLighting = true;
    var terrainProvider = Cesium.createWorldTerrain({
        requestWaterMask: true
    });
    viewer.terrainProvider = terrainProvider;

    var pinBuilder = new Cesium.PinBuilder();
    const extent = Cesium.Rectangle.fromDegrees(2.928611, 35.311814, 21.121970, 48.512097);
    viewer.camera.setView({
        destination: extent
    });

    var campaign = <%=campaign%>;
    var server = "<%=Constants.PATH%>";
    var servletUrl = "<%=Constants.PATH +"/annotationcontroller"%>";
    var annJspUrl = "<%=Constants.PATH +"/annotationsdetails"%>";
    var name = null;

    <% //worker
                   if (job == Job.WORKER.getId()){%>
    $.ajax({
        type: 'GET',
        url: 'campaign/getpeaks?campaign=<%=campaign%>&job=<%=job%>',
        data: {get_param: 'value'},
        dataType: 'json',
        success: function (data) {
            $.each(data, function (index, element) {
                console.log("peaks");
                name=element.name;
                if(peakName == undefined){
                    var peakName = null;
                } else {
                    var peakName = element.name;
                }
                if(localizedNames == undefined){
                    var localizedNames = null;
                }  else {
                    var localizedNames = element.localizedNames;
                }
                if(elevation == undefined){
                    var elevation = null;
                } else {
                    var elevation = element.elevation;
                }
                if(latitude == undefined){
                   var latitude = null;
                } else {
                    var latitude = element.latitude;
                }
                if(longitude == undefined){
                    var longitude = null;
                } else {
                    var longitude = element.longitude;
                }
                var bluePin = viewer.entities.add({
                    position: Cesium.Cartesian3.fromDegrees(element.longitude, element.latitude, element.elevation),
                    description:
                    '<form id="peakForm" action="' + servletUrl + '" method="post"> ' +
                    '<label>Name:' + name + '</label><br>' +
                    '<label>Sorgente:' + element.provenance + '</label><br>' +
                    '<label>Elevazione:' + element.elevation.toFixed(2) + '</label><br>' +
                    '<label>Longitudine:' + element.longitude.toFixed(2) + '</label><br>' +
                    '<label>Latitudine:' + element.latitude .toFixed(2)+ '</label><br>' +
                    '<label>Localized Names:' + element.localizedNames + '</label><br>' +
                    '<input type="hidden" name="peakId" value="' + element.peak_id + '">' +
                    '<input type="hidden" name="campaign" value="' + campaign + '">' +
                    '<input type="hidden" name="peakName" value="' + element.name + '"> ' +
                    '<input type="hidden" name="localizedNames" value="' + element.localizedNames + '" > ' +
                    '<input type="hidden" name="latitude" value="' + element.latitude + '"> ' +
                    '<input type="hidden" name="longitude" value="' + element.longitude + '"> ' +
                    '<input type="hidden" name="elevation" value="' + element.elevation + '"> ' +
                    '<input type="hidden" name="map" value="3"> ' +
                    '</form>' +
                    '<button type="button"  name="validation" value="1" onclick="parent.validPeak('+element.peak_id+','+campaign+','+peakName+','+localizedNames+','+elevation+','+latitude+','+longitude+','+1+','+3+')" >Valida</button>' +
                    '<button type="button"  name="validation" value="0" onclick="parent.invalidPeak('+element.peak_id+','+campaign+','+peakName+','+localizedNames+','+elevation+','+latitude+','+longitude+','+0+','+3+')">Invalida</button>',
                    billboard: {
                        image: pinBuilder.fromColor(Cesium.Color.ROYALBLUE, 48).toDataURL(),
                        verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
                        translucencyByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001),
                        scaleByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001)
                    }
                });

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
            $.each(data, function (index, element) {
                console.log("peaks");
                name=element.name;
                if (element.validation_status_id == 2) {
                    var greenPin = viewer.entities.add({

                        position: Cesium.Cartesian3.fromDegrees(element.longitude, element.latitude, element.elevation),
                        description:
                        '<form id="peakForm"> ' +
                        '<label>Name:' + name + '</label><br>' +
                        '<label>Sorgente:' + element.provenance + '</label><br>' +
                        '<label>Elevazione:' + element.elevation.toFixed(2) + '</label><br>' +
                        '<label>Longitudine:' + element.longitude.toFixed(2) + '</label><br>' +
                        '<label>Latitudine:' + element.latitude.toFixed(2) + '</label><br>' +
                        '<label>Localized Names:' + element.localizedNames + '</label><br>',

                        billboard: {
                            image: pinBuilder.fromColor(Cesium.Color.CHARTREUSE, 48).toDataURL(),
                            verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
                            //translucencyByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001),
                            scaleByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001)
                        }
                    });
                } else if (element.has_ref_ann==true) {
                    var redPin = viewer.entities.add({

                        position: Cesium.Cartesian3.fromDegrees(element.longitude, element.latitude, element.elevation),
                        description:
                        '<form  method="POST" id="managerPopupForm" action= "' + annJspUrl + '"> ' +
                        '<label>Name:' + name + '</label><br>' +
                        '<label>Sorgente:' + element.provenance + '</label><br>' +
                        '<label>Elevazione:' + element.elevation.toFixed(2) + '</label><br>' +
                        '<label>Longitudine:' + element.longitude.toFixed(2) + '</label><br>' +
                        '<label>Latitudine:' + element.latitude.toFixed(2) + '</label><br>' +
                        '<label>Localized Names:' + element.localizedNames + '</label><br>' +
                        '<input type="hidden" name="peakId" value="' + element.peak_id + '">' +
                        '<input type="hidden" name="campaign" value="' + campaign + '">' +
                        '<input type="hidden" name="peakName" value="' + element.name + '"> ' +
                        '<input type="hidden" name="localizedNames" value="' + element.localized_name + '" > ' +
                        '<input type="hidden" name="elevation" value="' + element.elevation + '"> ' +
                        '</form>' +
                        '<button type="submit" form="managerPopupForm" onclick="parent.goDetails('+element.peak_id+','+campaign+','+element.name+','+element.localized_name+','+element.elevation+')" name="annListBtn">Annotations Details</button>',
                        billboard: {
                            image: pinBuilder.fromColor(Cesium.Color.RED, 48).toDataURL(),
                            verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
                            //translucencyByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001),
                            scaleByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001)
                        }
                    });
                } else if (element.num_positive_annotations + element.num_negative_annotations > 0) {
                    var orangePin = viewer.entities.add({

                        position: Cesium.Cartesian3.fromDegrees(element.longitude, element.latitude, element.elevation),
                        description:
                        '<form  method="POST" id="managerPopupForm" action= "' + annJspUrl + '"> ' +
                        '<label>Name:' + name + '</label><br>' +
                        '<label>Sorgente:' + element.provenance + '</label><br>' +
                        '<label>Elevazione:' + element.elevation.toFixed(2) + '</label><br>' +
                        '<label>Longitudine:' + element.longitude.toFixed(2) + '</label><br>' +
                        '<label>Latitudine:' + element.latitude.toFixed(2) + '</label><br>' +
                        '<label>Localized Names:' + element.localizedNames + '</label><br>' +
                        '<input type="hidden" name="peakId" value="' + element.peak_id + '">' +
                        '<input type="hidden" name="campaign" value="' + campaign + '">' +
                        '<input type="hidden" name="peakName" value="' + element.name + '"> ' +
                        '<input type="hidden" name="localizedNames" value="' + element.localizedNames + '" > ' +
                        '<input type="hidden" name="elevation" value="' + element.elevation + '"> ' +
                        '</form>' +
                        '<button type="submit" form="managerPopupForm" onclick="parent.goDetails('+element.peak_id+','+campaign+','+element.name+','+element.localizedNames+','+element.elevation+')" name="annListBtn">Annotations Details</button>',
                        billboard: {
                            image: pinBuilder.fromColor(Cesium.Color.ORANGE, 48).toDataURL(),
                            verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
                            //translucencyByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001),
                            scaleByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001)
                        }
                    });
                } else {
                    var yellowPin = viewer.entities.add({

                        position: Cesium.Cartesian3.fromDegrees(element.longitude, element.latitude, element.elevation),
                        description:
                        '<form id="peakForm"> ' +
                        '<label>Name:' + name + '</label><br>' +
                        '<label>Sorgente:' + element.provenance + '</label><br>' +
                        '<label>Elevazione:' + element.elevation.toFixed(2) + '</label><br>' +
                        '<label>Longitudine:' + element.longitude.toFixed(2) + '</label><br>' +
                        '<label>Latitudine:' + element.latitude.toFixed(2) + '</label><br>' +
                        '<label>Localized Names:' + element.localizedNames + '</label><br>',
                        billboard: {
                            image: pinBuilder.fromColor(Cesium.Color.YELLOW, 48).toDataURL(),
                            verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
                            translucencyByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.00001),
                            scaleByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.00001)
                        }
                    });
                }

            });

        }
    });
    <%}
                %>

    function goDetails(peakId, campaign,peakName,localizedNames,elevation){
        url = "/annotationsdetails?peakId="+peakId+"&campaign="+campaign+"&peakName="+peakName+"&localizedNames="+localizedNames+"&elevation="+elevation;
    };

    function invalidPeak(peakId, campaign,peakName,localizedNames,elevation,latitude,longitude,validation,map){
        console.log('invalid func called');
        url = server+"/annotationcontroller?peakId="+peakId+
            "&campaign="+campaign;
        if(peakName != undefined){
            url+="&peakName="+peakName;
        }
        if(localizedNames != undefined){
            url+= "&localizedNames="+localizedNames;
        }
         if(elevation != undefined){
            url+= "&elevation="+elevation;
         }
         if(latitude != undefined){
            url+= "&latitude=" +latitude;
         }
         if(longitude != undefined){
            url+= "&longitude=" + longitude;
         }
        url += "&validation=" + validation +
        "&map="+ map;

        $.ajax({
            type: 'post',
            url: url,
            success: function () {
                location.reload(true);
            }
        })

    };

    function validPeak(peakId, campaign,peakName,localizedNames,elevation,latitude,longitude,validation,map){
        var url = server+"/annotation?campaign=" + campaign + "&peakId=" + peakId;
        if(peakName != undefined && peakName != null){
            url+="&peakName="+peakName;
        }
        if(localizedNames != undefined ){
            url+= "&localizedNames="+localizedNames;
        }
        if(elevation != undefined){
            url+= "&elevation="+elevation;
        }
        if(latitude != undefined){
            url+= "&latitude=" +latitude;
        }
        if(longitude != undefined){
            url+= "&longitude=" + longitude;
        }
        url += "&validation=" + validation +
            "&map="+ map;
        location.href = url;
    };

</script>
</body>
</html>