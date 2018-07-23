<%@ page import="Handler.CookieHandler" %>
<%@ page import="Util.Constants" %><%--
  Created by IntelliJ IDEA.
  User: step
  Date: 31/05/2018
  Time: 21:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
   <%
       if(!CookieHandler.getInstance().isSafe(request,response)){
           return;
       }
   %>
    <title>Peak input</title>
</head>
<body>
<h3>Drag here your file</h3>
<label for="input-folder-1">Upload File From Folder</label>
<div class="file-loading">
    <form action="/loading" method="post" id="dataForm" enctype="multipart/form-data">
        <input name="campaign" type="hidden" value="<%=request.getParameter("campaign")%>">
        <input id="input-folder-1" name="file" type="file" webkitdirectory>
        <select name="fileStatus" form="dataForm">
            <option value="1" name="fileStatus">Da annotare</option>
            <option value="2" name="fileStatus">Da non annotare</option>
        </select><br><br><br>
        <input type="submit" value="Upload file">
    </form>
</div>
<script>
    $(document).on('ready', function() {
        $("#input-folder-1").fileinput({
            browseLabel: 'Select Folder...'
        });
    });

</script>

</body>
</html>
