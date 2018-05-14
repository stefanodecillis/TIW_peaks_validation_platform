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
    <link rel="stylesheet" type="text/css" href="/StyleSheets/registerStyle.css">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="/Script/authScript.js"></script>
    <title>Register</title>
</head>
<body background="blue">
<div class="form-reg-beauty" align="center">
    <form method="POST" id="registerForm" action="/registerService">
        <label>Email:</label> <br>
        <input name="mail" class="form-control" placeholder="insert your mail" id="email" type="email" required> <br>
        <label>Username:</label> <br>
        <input name="username" class="form-control" placeholder="choose your username" id="username" type="text" required> <br>
        <label>Password:</label> <br>
        <input name="psw" class="form-control" id="pwd" placeholder="insert password" type="password" onkeyup="check()" required> <br>
        <label>Conferm Password:</label> <br>
        <input name="psw-check" class="form-control" placeholder="Conferm password" id="pwd-check" type="password" onchange="check()" onkeyup="check()" required>
        <span id="message"></span>
        <label>Choose Job:</label>
        <select name="job" class="form-control" form="registerForm">
            <option value="worker" name="job">Worker</option>
            <option value="manager" name="job">Manager</option>
        </select>
        <br>
    </form>
    <button type="submit" form="registerForm" onclick="sendReg()" class="btn btn-warning" id="registerBtn">Registrati</button>
    <button class="btn btn-primary" onclick="doLogin()" id="loginBtn">Log In</button> <br>
</div>

</body>
</html>
