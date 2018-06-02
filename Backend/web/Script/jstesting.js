var mymap = L.map('mapid').setView([41.277733, 16.4101], 13);

L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox.streets',
    accessToken: 'pk.eyJ1Ijoic3RlZmFubzk2IiwiYSI6ImNqaHhrd2M5dzBic3czcm55eXU3ODBmMGIifQ.5QLpFduGJVrWHk032DinKg'
}).addTo(mymap);

var marker = L.marker([41.277733, 16.4101]).addTo(mymap);