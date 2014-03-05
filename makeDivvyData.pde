// the max trips is the amount of trips we want to get.
int max_trips = 10;
PVector[] to_station = new PVector[max_trips];
PVector[] from_station = new PVector[max_trips];
void setup() {
  createPVectors();
}
void draw() {
}
void createPVectors() {
  //lets load the stations data!
  JSONArray stationsJSON = loadJSONArray("http://data.olab.io/divvy/stations.json");  
  //through the api, lets load 10 trips!
  JSONArray tripsJSON = loadJSONArray("http://data.olab.io/divvy/api.php?&page=0&rpp=10");
  //we will now go through all the trips (see api)
  for (int i = 0; i < tripsJSON.size();i++) {    
    //load one trip at a time.
    JSONObject tripJSON = tripsJSON.getJSONObject(i);
    //grab the to_station and from_station data    
    int fromStationID = tripJSON.getInt("from_station_id");
    int toStationID = tripJSON.getInt("to_station_id");
    //for EVERY trip, load all 300 stations and check to see if trip[i]'s to_station_id matches a station from the stationsJSON,
    //and if so, grab the latitude and longitude data from the stationJSON and add it to the trip[i]
    for (int j = 0; j < stationsJSON.size(); j++) {
      //load station[j]
      JSONObject stationJSON = stationsJSON.getJSONObject(j);
      //grab station id from station[j]
      int currentId = stationJSON.getInt("id");
      //grab the latitude and longitude of station[j]
      float latitude = stationJSON.getFloat("latitude");
      float longitude = stationJSON.getFloat("longitude");      
      //see if the id matches the id from the trip[i] data, then add the coordinates to a PVector
      if (currentId == fromStationID) {
        //create PVector[] with to lat and lon from trip[i]'s from_station[i]
        from_station[i] = new PVector(latitude, longitude, 0.0);
      }
      if (currentId == toStationID) {
        //create PVector[] with lat and lon from trip[i]'s to_station[i]
        to_station[i] = new PVector(latitude, longitude, 0.0);
      }
    }
  }
  //go through new PVectors that store the latitude, longitude and tripduration, though we might not use trip duration.............ttyl
  //since we are going through the PVector[]s at the same time, they match and make a trip. as in from_station[1] matches to to_station[1] in a trip  
  for (int e = 0; e < from_station.length; e++) {
    println("trip#" + e + " from station at " + from_station[e].x + ", " + from_station[e].y);
    println("trip#" + e + " to station at " + to_station[e].x + ", " + to_station[e].y);
  }
}

