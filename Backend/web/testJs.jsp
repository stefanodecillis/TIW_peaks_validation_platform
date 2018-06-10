<%--
  Created by IntelliJ IDEA.
  User: step
  Date: 10/06/2018
  Time: 19:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>TestJS</title>
</head>
<body>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<p id="texttest"></p>
<div id="data"></div>
<script>

        $.get('campaign/getpeaks?campaign=5', function(data) {
            $('#data').text(data);
        });

</script>

</body>
</html>
