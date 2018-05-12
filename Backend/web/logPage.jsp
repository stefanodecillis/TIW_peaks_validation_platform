<%--
  Created by IntelliJ IDEA.
  User: step
  Date: 12/05/2018
  Time: 16:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="/StyleSheets/loginStyle.css">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <title>Log in</title>
</head>
<body background="blue">
<div class="form-beauty" align="center">
    <form method="POST" action="/logService">
        <label>Email:</label> <br>
        <input name="mail" class="form-control" id="email" type="email"> <br><br>
        <label>Password:</label> <br>
        <input name="psw" class="form-control" id="pwd" type="password"> <br><br>
        <button type="submit" class="btn btn-primary">Accedi</button> <br>
    </form>
    <a href="localhost:8080/register" target="_blank"><button class="btn btn-warning">Registrati</button></a>
</div>

</body>
</html>
