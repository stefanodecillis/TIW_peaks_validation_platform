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
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css"
          integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
            integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"
            integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T"
            crossorigin="anonymous"></script>
    <script src="/Script/navjs.js"></script>
    <script src="/Script/authScript.js"></script>
    <title>Register</title>
</head>
<body>
<div>
    <nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
        <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">PeakPlatform</a>
        <ul class="navbar-nav px-3">
        </ul>
    </nav>
</div>
<br><br>
<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block bg-light sidebar">
            <div class="sidebar-sticky">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active" href="#" onclick="doLogin()">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                 stroke-linejoin="round" class="feather feather-home">
                                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                <polyline points="9 22 9 12 15 12 15 22"></polyline>
                            </svg>
                            Log In <span class="sr-only">(current)</span>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
            <div class="chartjs-size-monitor"
                 style="position: absolute; left: 0px; top: 0px; right: 0px; bottom: 0px; overflow: hidden; pointer-events: none; visibility: hidden; z-index: -1;">
                <div class="chartjs-size-monitor-expand"
                     style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
                    <div style="position:absolute;width:1000000px;height:1000000px;left:0;top:0"></div>
                </div>
                <div class="chartjs-size-monitor-shrink"
                     style="position:absolute;left:0;top:0;right:0;bottom:0;overflow:hidden;pointer-events:none;visibility:hidden;z-index:-1;">
                    <div style="position:absolute;width:200%;height:200%;left:0; top:0"></div>
                </div>
            </div>
            <h1>Registration</h1>
            <div class="form-reg-beauty" align="center">
                <form method="POST" id="registerForm" action="/registerService">
                    <label>Email:</label> <br>
                    <input name="mail" class="form-control" placeholder="insert your mail" id="email" type="email"
                           required> <br>
                    <label>Username:</label> <br>
                    <input name="username" class="form-control" placeholder="choose your username" id="username"
                           type="text" required> <br>
                    <label>Password:</label> <br>
                    <input name="psw" class="form-control" id="pwd" placeholder="insert password" type="password"
                           onkeyup="check()" required> <br>
                    <label>Conferm Password:</label> <br>
                    <input name="psw-check" class="form-control" placeholder="Conferm password" id="pwd-check"
                           type="password" onchange="check()" onkeyup="check()" required>
                    <span id="message"></span>
                    <label>Choose Job:</label>
                    <select name="job" class="form-control" form="registerForm">
                        <option value="worker" name="job">Worker</option>
                        <option value="manager" name="job">Manager</option>
                    </select>
                    <br>
                </form>
                <button type="submit" form="registerForm" onclick="sendReg()" class="btn btn-warning" id="registerBtn">
                    Registrati
                </button>
                <%--<button class="btn btn-primary" onclick="doLogin()" id="loginBtn">Log In</button> --%>
                <br>
            </div>
        </main>
    </div>
</div>
</body>
</html>

