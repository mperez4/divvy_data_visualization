import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.utils.*;
import de.fhpotsdam.unfolding.providers.*;

import java.util.Map;
import java.util.Date;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

UnfoldingMap map;
Location chicagoLocation = new Location(41.883, -87.632);

// the max trips is the amount of trips we want to get.
int max_trips = 50;
PVector[] to_station = new PVector[max_trips];
PVector[] from_station = new PVector[max_trips];

void setup() {
  size(800, 600, P2D);
  frameRate(60);
  map = new UnfoldingMap(this, new OpenStreetMap.CloudmadeProvider("07db658f6f5d48148dd007fcace89a16", 124011 ));
  map.zoomAndPanTo(chicagoLocation, 12);
  MapUtils.createDefaultEventDispatcher(this, map);
  createPVectors();
  for (int m = 0; m < to_station.length; m++) {
    addMarkers(from_station[m].x, from_station[m].y, from_station[0].z, to_station[m].x, to_station[m].y, to_station[1].z);
  }
}
void draw() {
  background(230);
  map.draw();
}
void createPVectors() {
  //lets load the stations data!
  JSONArray stationsJSON = loadJSONArray("http://data.olab.io/divvy/stations.json");  
  //through the api, lets load 10 trips!
  JSONArray tripsJSON = loadJSONArray("http://data.olab.io/divvy/api.php?&page=0&rpp="+max_trips);
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
}

