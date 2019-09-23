var mapStyle = {
    "stroke": true,
    "color": '#404040',
    "weight": 1.5,
    "fill": true,
    "fillColor": '#FF5733',
    "fillOpacity": 0.5

};

/*Get popup information based on GeoJSON data  */
function getPopupInfo(feature, layer) {
    var str = feature.properties.description;
    layer.bindPopup("<h3>Soil Survey(s)</h3>" + str, {
        minWidth: 200
    });
};


var mymap = L.map('mapid').setView([52, -96.00], 4);

/*Add NRCAN basemap */
var wmsLayer = L.tileLayer.wms('http://maps.geogratis.gc.ca/wms/CBMT?', {
    layers: ['National', 'Sub_national', 'Regional'],
    attribution: '<a href="https://geogratis.gc.ca/geogratis/CBM_CBC?lang=en">©GeoGratis - Canada Base Map</a>'
}).addTo(mymap);



/*Add soilmap Layer */
var soilLayer = L.geoJson(
    soilmap, {
        style: mapStyle,
        onEachFeature: getPopupInfo
    }).addTo(mymap);


map.fitBounds(soilLayer.getBounds());