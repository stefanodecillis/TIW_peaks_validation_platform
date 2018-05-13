<%@ page import="Util.Constants" %><%--
  Created by IntelliJ IDEA.
  User: step
  Date: 12/05/2018
  Time: 20:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Mountain Peak</title>
</head>
<body>
<div align="center">
    <h3>Autorizzazione fallita</h3>
    <br>
    <script language="javascript" type="text/javascript">
        function doLogin() {
            location.href = "/login";
        }
    </script>
    <button class="btn btn-primary" onclick="doLogin()">Ritorna</button>
</div>
</body>
</html>
