<%--
  Created by IntelliJ IDEA.
  User: Paolo De Santis
  Date: 18/05/2018
  Time: 17:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

<div align="center">
    <h3>Empty form</h3>
    <br>
    <br>
    <p>Try again</p>
    <br> <br>
    <script language="javascript" type="text/javascript">
        function doModify() {
            location.href = "/modifyUserDetails";
        }
    </script>
    <button class="btn btn-primary" onclick="doModify()">Return</button>
</div>

</body>
</html>
