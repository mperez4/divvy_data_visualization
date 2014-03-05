//this function passes in lat and lon from and to trips. it places a unfoldingmaps marker in the coordinates
//we should make a class that returns the data
void addMarkers(float from_lat, float from_lon, float from_tripduration, float to_lat, float to_lon, float to_tripduration) {
  Location from_station = new Location(from_lat, from_lon);
  Location to_station = new Location(to_lat, to_lon);
  SimplePointMarker from_station_marker = new SimplePointMarker(from_station);
  SimplePointMarker to_station_marker = new SimplePointMarker(to_station);
  SimpleLinesMarker connectionMarker = new SimpleLinesMarker(from_station, to_station);
  to_station_marker.setColor(color(255, 0, 0, 100));
  from_station_marker.setColor(color(0, 0, 250, 100));
  map.addMarkers(from_station_marker);
  map.addMarkers(to_station_marker);
  map.addMarkers(connectionMarker);
}

