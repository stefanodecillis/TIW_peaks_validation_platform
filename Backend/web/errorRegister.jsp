<%--
  Created by IntelliJ IDEA.
  User: step
  Date: 13/05/2018
  Time: 12:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Mountain Peak</title>
</head>
<body>
<div align="center">
    <h3>Registrazione fallita</h3>
    <br>
    <br>
    <p>Dati inseriti non validi. Riprovare</p>
    <br> <br>
    <script language="javascript" type="text/javascript">
        function doRegister() {
            location.href = "/register";
        }
    </script>
    <button class="btn btn-primary" onclick="doRegister()">Ritorna</button>
</div>
</body>
</html>
