<%--
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
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
    <title>Hello World!</title>
    <script src="/Script/cesium-workshop-master/ThirdParty/Cesium/Cesium.js"></script>
    <style>
        @import url(/Script/cesium-workshop-master/ThirdParty/Cesium/Widgets/widgets.css);
        html, body, #cesiumContainer {
            width: 100%; height: 100%; margin: 0; padding: 0; overflow: hidden;
        }
    </style>
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
</script></body>
</html>
