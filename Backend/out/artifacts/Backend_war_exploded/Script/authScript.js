function doLogin() {
    location.href = "/login";
}

function doRegister() {
    location.href = "/register";
}

var check_pass_bool = false;

var check = function() {
    if (document.getElementById('pwd').value ==
        document.getElementById('pwd-check').value) {
        document.getElementById('message').style.color = 'green';
        //document.getElementById('message').innerHTML = 'matching';
        document.getElementById("pwd-check").style.backgroundColor = 'green';
        check_pass_bool = true;
    } else {
        document.getElementById('message').style.color = 'red';
        //document.getElementById('message').innerHTML = 'not matching';
        document.getElementById("pwd-check").style.backgroundColor = 'red';
        check_pass_bool = false;
    }
}


function sendReg() {
    console.log("sendReg launch");
    var formData = new FormData();
    var username = document.getElementById("username").value;
    var psw = document.getElementById("pwd").value;
    var psw_check = document.getElementById("pwd-check").value;
    var mail = document.getElementById("email").value;
    var job = document.getElementById("job").value;

    if(psw.toString() == psw_check.toString()){

        formData.append("username", username);
        formData.append("mail", mail);
        formData.append("psw", psw);
        formData.append("psw-check", psw_check);
        formData.append("job", job);


        var request = new XMLHttpRequest();
        request.open("POST", "localhost:8080/registerService");
        request.send(formData);
    } else {
        window.alert("Passwords don't match! Please retry ")
    }

    console.log("sendReg finish");
}

check();