<%--
  Created by IntelliJ IDEA.
  User: step
  Date: 13/05/2018
  Time: 00:59
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
    <title>Register</title>
</head>
<body background="blue">
<div class="form-beauty" align="center">
    <form method="POST" action="/registerService" id="registerForm">
        <label>Email:</label> <br>
        <input name="mail" class="form-control" id="email" type="email"> <br><br>
        <label>Username:</label> <br>
        <input name="username" class="form-control" id="username" type="text"> <br><br>
        <label>Password:</label> <br>
        <input name="psw" class="form-control" id="pwd" type="password"> <br><br>
        <label>Job:</label>
        <select name="job" class="form-control" form="registerForm">
            <option value="worker" name="job">Worker</option>
            <option value="manager" name="job">Manager</option>
        </select>

        <br><br>
        <button type="submit" class="btn btn-warning">Registrati</button> <br>
    </form>
    <br>
    o
    <br>
    <script language="javascript" type="text/javascript">
        function doLogin() {
            location.href = "/login";
        }
    </script>
    <button class="btn btn-primary" onclick="doLogin()">Log In</button>
</div>

</body>
</html>
