<%--
  Created by IntelliJ IDEA.
  User: step
  Date: 15/07/2018
  Time: 19:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Stats</title>
    <link rel="stylesheet" href="/StyleSheets/statsStyle.css">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>

<%
    int campaign = Integer.parseInt(request.getParameter("campaign"));
%>


<div>
    <div class="external">
        <div class="internal">
            <h3> Numero di picchi non ancora annotati (0 annotazioni) </h3>
            <br>
            <br>
            <p class="result" id="counter1"> </p>
        </div>
        <div class="internal">
            <h3> Numero di picchi con 1 o più annotazioni </h3>
            <br>
            <br>
            <p class="result" id="counter2">  </p>
        </div>
        <div class="internal" >
            <h3> Numero di picchi con almeno 1 annotazione rifiutata </h3>
            <br>
            <br>
            <p class="result" id="counter3">  </p>
        </div>
        <div class="internal">
            <h3> Numero di conflitti </h3>
            <br>
            <br>
            <p class="result" id="counter4">  </p>
        </div>
    </div>
    <div class="external">
        <div class="internal">
            <button id="btn1" type="button" class="btn btn-primary">Elenco con annotazioni</button>
            <div id="box1"></div>
            <div id="boxResult1"></div>
        </div>
        <div class="internal">
            <button id="btn2" type="button" class="btn btn-primary">Elenco dei picchi <br />
                con almeno una annotazioni rifiutate</button>
            <div id="box2"></div>
        </div>
        <div id="btn3" class="internal">
            <button type="button" class="btn btn-primary">Elenco dei conflitti della campagna</button>
            <div id="box3"></div>
        </div>
    </div>
    <br>
    <div id="boxResult" class="external" align="center">
        <div id="boxResultPeak" align="center" >
        </div>
        <br>
        <div id="boxResultDetails" align="center" class="chartjs-size-monitor">
        </div>
    </div>
</div>

<script>
    var btn1 = document.getElementById('btn1');
    var btn2 = document.getElementById('btn2');
    var btn3 = document.getElementById('btn3');

    btn1.onclick = function(){
        cleanBoxResult();
        var box = document.getElementById('boxResultPeak');
        var list = document.createElement('table');
        list.classList.add('table');

        $.ajax({
            type: 'GET',
            url: 'stats-api?campaign=<%=campaign%>&stat=5&depth=1',
            dataType: 'json',
            success: function (data) {
                $.each(data,function(index,element){
                    var tr = document.createElement('tr');
                    var td = document.createElement('td');
                    var btn = document.createElement('button');
                    var text = document.createTextNode(element.peak_name);
                    btn.appendChild(text);
                    btn.onclick = function (){
                        getAnnotation(element.peak_id,1);
                    }
                    td.appendChild(btn);
                    tr.appendChild(td);
                    list.appendChild(tr);
                });

            }
        });
        box.appendChild(list);
    };

    btn2.onclick = function(){

        cleanBoxResult()
        var box = document.getElementById('boxResultPeak');
        var list = document.createElement('table');
        list.classList.add('table');

        $.ajax({
            type: 'GET',
            url: 'stats-api?campaign=<%=campaign%>&stat=6&depth=1',
            dataType: 'json',
            success: function (data) {
                $.each(data,function(index,element){
                    var tr = document.createElement('tr');
                    var td = document.createElement('td');
                    var btn = document.createElement('button');
                    var text = document.createTextNode(element.peak_name);
                    btn.appendChild(text);
                    btn.onclick = function (){
                        getAnnotation(element.peak_id,2);
                    }
                    td.appendChild(btn);
                    tr.appendChild(td);
                    list.appendChild(tr);
                });

            }
        });
        box.appendChild(list);
    };

    btn3.onclick = function () {
      cleanBoxResult();
        var box = document.getElementById('boxResultPeak');
        var list = document.createElement('table');
        list.classList.add('table');

        var tbody = document.createElement('tbody');

        $.ajax({
            type: 'GET',
            url: 'stats-api?campaign=<%=campaign%>&stat=7',
            dataType: 'json',
            success: function (data) {
                $.each(data,function(index,element){
                    var tr = document.createElement('tr');

                    var fieldCell = document.createElement('td');
                    var field = document.createTextNode((index+1) +")");
                    fieldCell.style.width="10px";
                    fieldCell.appendChild(field);
                    tr.appendChild(fieldCell);

                    var td = document.createElement('td');
                    td.appendChild(document.createTextNode(element.name));
                    tr.appendChild(td);
                    td = document.createElement('td');

                    //positive annotations
                    fieldCell = document.createElement('td');
                    field = document.createTextNode('# positive annotations: ');
                    fieldCell.appendChild(field);
                    tr.appendChild(fieldCell);

                    td.appendChild(document.createTextNode(element.num_positive_annotations));
                    tr.appendChild(td);
                    td = document.createElement('td');

                    //negative annotations
                    fieldCell = document.createElement('td');
                    field = document.createTextNode('# negative annotations: ');
                    fieldCell.appendChild(field);
                    tr.appendChild(fieldCell);
                    td.appendChild(document.createTextNode(element.num_negative_annotations));
                    tr.appendChild(td);

                    tbody.appendChild(tr);
                });

            }
        });
        list.appendChild(tbody);
        box.appendChild(list);
    };

    function getAnnotation(peakId, apiRequest){
        var box2 = document.getElementById('boxResultDetails');
        while (box2.hasChildNodes()) {
            box2.removeChild(box2.firstChild);
        }
        var list = document.createElement('table');
        list.classList.add('table');
        list.style.justifyContent = "flex-start";

        //choose api

        var urlData;
        if(apiRequest == 1){
            urlData = 'stats-api?campaign=<%=campaign%>&stat=5&depth=2&peak='+peakId;
        } else if (apiRequest == 2){
            urlData = 'stats-api?campaign=<%=campaign%>&stat=6&depth=2&peak='+peakId;
        }
        var tbody = document.createElement('tbody');
        tbody.style.justifyContent = "flex-start";
        $.ajax({
            type: 'GET',
            url: urlData,
            dataType: 'json',
            success: function (data) {
                $.each(data,function(index,element){
                    if(element.validation == 1){
                        createRowForTable(tbody,element.username,"Valida", element.elevation, element.latitude.toFixed(2), element.longitude.toFixed(2),element.localized_names,element.peak_name,index+1);
                        createRowForTable(tbody,null);
                    } else {
                        createRowForTable(tbody,element.username,"Invalida", element.elevation, element.latitude.toFixed(2), element.longitude.toFixed(2),element.localized_names,element.peak_name,index+1);
                        createRowForTable(tbody,null);
                    }
                });

            }
        });

        list.appendChild(tbody);
        box2.appendChild(list);
    };

    function createRowForTable(table, username, validation, elevation, latitude,longitude,localizedNames, peakName,index){
        if(username == null){
            var tr = document.createElement('tr');
            var td = document.createElement('td');
            var text = document.createElement('br');
            td.appendChild(text);
            table.appendChild(tr);
        } else{
            var tr = document.createElement('tr');
            var indexRow = document.createTextNode(index + ")");
            var indexCell = document.createElement('td');
            indexCell.appendChild(indexRow)
            tr.appendChild(indexCell);

            var username = document.createTextNode(username);
            var validation = document.createTextNode(validation);
            var elevation = document.createTextNode(elevation);
            var latitude = document.createTextNode(latitude);
            var longitude = document.createTextNode(longitude);
            var peakName = document.createTextNode(peakName);
            var localizedNames = document.createTextNode(localizedNames);

            var usernameTd = document.createElement('td');
            var validationTd = document.createElement('td');
            var elevationTd = document.createElement('td');
            var latitudeTd = document.createElement('td');
            var longitudeTd = document.createElement('td');
            var peakNameTd = document.createElement('td');
            var localizedNamesTd = document.createElement('td');

            usernameTd.appendChild(username);
            validationTd.appendChild(validation);
            elevationTd.appendChild(elevation);
            latitudeTd.appendChild(latitude);
            longitudeTd.appendChild(longitude);
            peakNameTd.appendChild(peakName);
            localizedNamesTd.appendChild(localizedNames);

            //username
            var fieldCell = document.createElement('td');
            var field = document.createTextNode('username: ');
            fieldCell.appendChild(field);
            tr.appendChild(fieldCell);

            tr.appendChild(usernameTd);

            //validation

            fieldCell = document.createElement('td');
            field = document.createTextNode('validation: ');
            fieldCell.appendChild(field);
            tr.appendChild(fieldCell);

            tr.appendChild(validationTd);

            //peakName

            fieldCell = document.createElement('td');
            field = document.createTextNode('peak name: ');
            fieldCell.appendChild(field);
            tr.appendChild(fieldCell);

            tr.appendChild(peakNameTd);

            //localizedNames

            fieldCell = document.createElement('td');
            field = document.createTextNode('localizedNames: ');
            fieldCell.appendChild(field);
            tr.appendChild(fieldCell);

            tr.appendChild(localizedNamesTd);

            //elevation

            fieldCell = document.createElement('td');
            field = document.createTextNode('elevation: ');
            fieldCell.appendChild(field);
            tr.appendChild(fieldCell);

            tr.appendChild(elevationTd);

            //latitude

            fieldCell = document.createElement('td');
            field = document.createTextNode('latitude: ');
            fieldCell.appendChild(field);
            tr.appendChild(fieldCell);

            tr.appendChild(latitudeTd);

            //longitude

            fieldCell = document.createElement('td');
            field = document.createTextNode('longitude: ');
            fieldCell.appendChild(field);
            tr.appendChild(fieldCell);

            tr.appendChild(longitudeTd);

            tr.style.height= "4px";

            table.appendChild(tr);
        }
    };

    function init(){
      var counter1 = document.getElementById('counter1');
      $.ajax({
            type: 'GET',
            url: 'stats-api?campaign=<%=campaign%>&stat=1',
            dataType: 'json',
            success: function (data) {
                counter1.textContent = data;
            }
        });
        var counter2 = document.getElementById('counter2');
        $.ajax({
            type: 'GET',
            url: 'stats-api?campaign=<%=campaign%>&stat=2',
            dataType: 'json',
            success: function (data) {
                counter2.textContent = data;
            }
        });
        var counter3 = document.getElementById('counter3');
        $.ajax({
            type: 'GET',
            url: 'stats-api?campaign=<%=campaign%>&stat=3',
            dataType: 'json',
            success: function (data) {
                counter3.textContent = data;
            }
        });
        var counter4 = document.getElementById('counter4');
        $.ajax({
            type: 'GET',
            url: 'stats-api?campaign=<%=campaign%>&stat=4',
            dataType: 'json',
            success: function (data) {
                counter4.textContent = data;
            }
        });
    };

    function cleanBoxResult(){
        var box = document.getElementById('boxResultDetails');
        while (box.hasChildNodes()) {
            box.removeChild(box.firstChild);
        }
        box = document.getElementById('boxResultPeak');
        while (box.hasChildNodes()) {
            box.removeChild(box.firstChild);
        }
    };

    init();
</script>
</body>
</html>
