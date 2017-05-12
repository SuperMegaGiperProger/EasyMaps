unit GeoUnit;
 
//----------------------------------------------------------------------------//

interface

uses
  math;

const
  R = 6371;

function radToDeg(rad: real): real;
function degToRad(deg: real): real;
function getLatitude(y: real): real;
function getLongitude(x: real): real;
function getXDecartCoordinates(longitude: real): real;
function getYDecartCoordinates(latitude: real): real;
function distation(lat1, lon1, lat2, lon2: real): real;

//----------------------------------------------------------------------------//

implementation

function radToDeg(rad: real): real;
begin
  result := rad * 180.0 / pi;
end;

function degToRad(deg: real): real;
begin
  result := deg * pi / 180.0;
end;

function getLatitude(y: real): real;
begin
  result := arctan(exp(y / r)) - pi / 4.0;
  result := radToDeg(result * 2.0);
end;

function getLongitude(x: real): real;
begin
  result := radToDeg(x / R);
end;

function getXDecartCoordinates(longitude: real): real;
begin
  result := R * degToRad(longitude);
end;

function getYDecartCoordinates(latitude: real): real;
begin
  result := tan(pi / 4.0 + degToRad(latitude) / 2.0);
  result := R * ln(result);
end;

function distation(lat1, lon1, lat2, lon2: real): real;
begin
  result := sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1);
  result := R * arccos(result);
end;

//----------------------------------------------------------------------------//

end.
