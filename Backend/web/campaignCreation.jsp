<%@ page import="Util.Constants" %>
<%@ page import="Handler.CookieHandler" %><%--
  Created by IntelliJ IDEA.
  User: Paolo De Santis
  Date: 22/05/2018
  Time: 18:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Campaign Creation</title>
</head>
<body>

<%
    if(!CookieHandler.getInstance().isSafe(request,response)){
        return;
    }
%>

<H1>Create Your Campaign</H1>

<div class="form-reg-beauty" align="center">
    <form method="POST" id="campaignCreationForm" action="/campaignCreationService">
        <label>Campaign Name:</label> <br>
        <br>
        <input name="name" class="form-control" placeholder="insert campaign name" id="name" type="text" required> <br>
        <input name="owner_id" type="hidden" value="<%= Integer.parseInt(request.getParameter("user"))%>"> <br>
        <button type="submit" class="btn btn-primary"  id="createCampBtn">Create</button>
        <br>
    </form>
</div>

<script language="javascript" type="text/javascript">
    function returnHomeManager() {
        location.href = "/homeManager";
    }
</script>
<br>
<button class="btn btn-primary" onclick="returnHomeManager()">Return</button></div>

</body>
</html>
