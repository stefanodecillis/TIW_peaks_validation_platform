function returnHome (){
    window.location = "/";
};

function userDetailRedirect(id){
    location.href = "/userDetails.jsp?user="+id;
};

function doLogout(id){
    var request = new XMLHttpRequest();
    request.open("POST", "/logout");
    request.send();
    returnHome()
};
