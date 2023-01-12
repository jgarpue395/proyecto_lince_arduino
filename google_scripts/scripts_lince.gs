// abro la hoja de calculo, a traves del metodo openByUrl, pasandole como parametro la url de la hoja de calculo
const sheet = SpreadsheetApp.openByUrl("https://docs.google.com/spreadsheets/d/1VfWjrDH09sLQeiZVHfeS2yjjuTQMvLqADJIsz4DTVrE/edit#gid=0");

// funcion doPost, se realiza al hacer una petcion post
function doPost(request) 
{
  // llama al metodo setData
  setData(request.parameter.velocidadInstantanea, request.parameter.velocidadMedia, request.parameter.tiempoCarrera, request.parameter.numVueltas, 
  request.parameter.coordenadas);
}

// funcion setData, guada los valores en la hoja de calculo guardada en la constante sheet
function setData(velocidadInstantanea, velocidadMedia, tiempoCarrera, numVueltas, coordenadas) 
{
  // indica con que hoja del libro se va a trabajar
  hoja = sheet.getSheetByName("Hoja 1");

  if (coordenadas != "NoDisponible")
  {
    var coords = parseCoordenadas(coordenadas);
    // introduce la linea con los nuevos datos en el excel
    sheet.appendRow([velocidadInstantanea, velocidadMedia, tiempoCarrera, numVueltas, coords.latitud, coords.longitud]);
  }
  else 
  {
    // introduce la linea con los nuevos datos en el excel
    sheet.appendRow([velocidadInstantanea, velocidadMedia, tiempoCarrera, numVueltas, "No disponible", "No disponible"]);
  }
}

function parseCoordenadas(coordenadas) {
  // Separa la latitud, la longitud y la dirección de la latitud y longitud en 4 variables
  var lat = coordenadas.split(',')[0];
  var latDir = coordenadas.split(',')[1];
  var lng = coordenadas.split(',')[2];
  var lngDir = coordenadas.split(',')[3];

  // Calcula los grados, minutos y segundos de la latitud y la longitud
  var latDegrees = Math.floor(lat / 100);
  var latMinutes = (lat / 100 - latDegrees) * 100;
  var latSeconds = (latMinutes - Math.floor(latMinutes)) * 100;
  var lngDegrees = Math.floor(lng / 100);
  var lngMinutes = (lng / 100 - lngDegrees) * 100;
  var lngSeconds = (lngMinutes - Math.floor(lngMinutes)) * 100;

  // Formatea la latitud y la longitud con los grados, minutos y segundos calculados
  var latitud = latDegrees + "º" + Math.floor(latMinutes) + "." + latSeconds.toFixed(4).replace(".","") + "'" + latDir;
  var longitud = lngDegrees + "º" + Math.floor(lngMinutes) + "." + lngSeconds.toFixed(4).replace(".","") + "'" + lngDir;

  return {
    latitud,
    longitud
  };
}