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
    <title>Hello World!</title>
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
    viewer.terrainProvider = Cesium.createWorldTerrain();
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
    /*var bluePin = viewer.entities.add({
        name: 'peak',
        position: Cesium.Cartesian3.fromDegrees(0,0),
        billboard: {
            image: pinBuilder.fromColor(Cesium.Color.ROYALBLUE, 48).toDataURL(),
            verticalOrigin: Cesium.VerticalOrigin.BOTTOM
        }
    });
    viewer.flyTo(bluePin).then(function(){
        viewer.trackedEntity = bluePin;
    });*/

    $.ajax({
        type: 'GET',
        url: 'campaign/getpeaks?campaign=<%=campaign%>',
        data: {get_param: 'value'},
        dataType: 'json',
        success: function (data) {

            $.each(data, function (index, element) {

                var campaign = <%=campaign%>;
                var servletUrl = "<%=Constants.PATH +"/annotationcontroller"%>";
                var name = element.name;

                console.log("ciao");

                <% //worker
                if (job == Job.WORKER.getId()){ %>

                var bluePin = viewer.entities.add({
                    position: Cesium.Cartesian3.fromDegrees(element.longitude, element.latitude, element.elevation),
                    description:
                    '<form id="peakForm" action="'+servletUrl+'" method="post"> ' +
                    '<label>Name:' + name + '</label><br>' +
                    '<label>Sorgente:' + element.provenance + '</label><br>' +
                    '<label>Elevazione:' + element.elevation + '</label><br>' +
                    '<label>Longitudine:' + element.longitude + '</label><br>' +
                    '<label>Latitudine:' + element.latitude + '</label><br>' +
                    '<label>Localized Names:' + element.localized_name + '</label><br>' +
                    '<input type="hidden" name="peak_id" value="' + element.peak_id + '">' +
                    '<input type="hidden" name="peakId" value="' + element.peak_id + '">' +
                    '<input type="hidden" name="campaign" value="' + campaign + '">' +
                    '<input type="hidden" name="peakName" value="' + element.name + '"> ' +
                    '<input type="hidden" name="localizedNames" value="' + element.localized_name + '" > ' +
                    '<input type="hidden" name="latitude" value="' + element.latitude + '"> ' +
                    '<input type="hidden" name="longitude" value="' + element.longitude + '"> ' +
                    '<input type="hidden" name="elevation" value="' + element.elevation + '"> ' +
                    '</form>' +
                    '<button type="submit" form="peakForm" name="validation" value="1" >Valida</button>' +
                    '<button type="submit" form="peakForm" name="validation" value="0">Invalida</button>',
                    billboard: {
                        image: pinBuilder.fromColor(Cesium.Color.ROYALBLUE, 48).toDataURL(),
                        verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
                        translucencyByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001),
                        scaleByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001)
                    }
                });
                <%}
                //manager
                else if (job == Job.MANAGER.getId()) {%>
                if (element.validation_status_id == 2) {
                    var greenPin = viewer.entities.add({

                        position: Cesium.Cartesian3.fromDegrees(element.longitude, element.latitude, element.elevation),
                        description:
                        '<form id="peakForm"> ' +
                        '<label>Name:' + name + '</label><br>' +
                        '<label>Sorgente:' + element.provenance + '</label><br>' +
                        '<label>Elevazione:' + element.elevation + '</label><br>' +
                        '<label>Longitudine:' + element.longitude + '</label><br>' +
                        '<label>Latitudine:' + element.latitude + '</label><br>' +
                        '<label>Localized Names:' + element.localized_name + '</label><br>',
                        billboard: {
                            image: pinBuilder.fromColor(Cesium.Color.CHARTREUSE, 48).toDataURL(),
                            verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
                            //translucencyByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001),
                            scaleByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001)
                        }
                    });
                } else if (element.num_negative_annotations>0){
                    var redPin = viewer.entities.add({

                        position: Cesium.Cartesian3.fromDegrees(element.longitude, element.latitude, element.elevation),
                        description:
                        '<form id="peakForm"> ' +
                        '<label>Name:' + name + '</label><br>' +
                        '<label>Sorgente:' + element.provenance + '</label><br>' +
                        '<label>Elevazione:' + element.elevation + '</label><br>' +
                        '<label>Longitudine:' + element.longitude + '</label><br>' +
                        '<label>Latitudine:' + element.latitude + '</label><br>' +
                        '<label>Localized Names:' + element.localized_name + '</label><br>',
                        billboard: {
                            image: pinBuilder.fromColor(Cesium.Color.RED, 48).toDataURL(),
                            verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
                            //translucencyByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001),
                            scaleByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.001)
                        }
                    });
                } else if(element.num_positive_annotations>0){
                    var orangePin = viewer.entities.add({

                        position: Cesium.Cartesian3.fromDegrees(element.longitude, element.latitude, element.elevation),
                        description:
                        '<form id="peakForm"> ' +
                        '<label>Name:' + name + '</label><br>' +
                        '<label>Sorgente:' + element.provenance + '</label><br>' +
                        '<label>Elevazione:' + element.elevation + '</label><br>' +
                        '<label>Longitudine:' + element.longitude + '</label><br>' +
                        '<label>Latitudine:' + element.latitude + '</label><br>' +
                        '<label>Localized Names:' + element.localized_name + '</label><br>',
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
                        '<label>Elevazione:' + element.elevation + '</label><br>' +
                        '<label>Longitudine:' + element.longitude + '</label><br>' +
                        '<label>Latitudine:' + element.latitude + '</label><br>' +
                        '<label>Localized Names:' + element.localized_name + '</label><br>',
                        billboard: {
                            image: pinBuilder.fromColor(Cesium.Color.YELLOW, 48).toDataURL(),
                            verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
                            translucencyByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.00001),
                            scaleByDistance: new Cesium.NearFarScalar(0, 1.0, 1.8e6, 0.00001)
                        }
                    });
                }
                <% } %>
            });
        }
    });

</script>
</body>
</html>