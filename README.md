# WeatherBug Partner API

To get set up:

    gem install weatherbug

This is a Ruby interface for the Weatherbug Partner API.  It does not cover the entire API, but covers basic functionality.

    stations = WeatherBug::nearest_stations(:zip_code => '10012')
    station = WeatherBug::closest_station(:zip_code => '08005')
    station = WeatherBug::get_station(station_id)
    stations = WeatherBug::stations_in_box(tr_lat, tr_lng, bl_lat, bl_lng)

You can do some cool things with stations:

    station.live_observation
    station.forecast

### TODO

* Expand the README to actually be useful
* Add more functionality
* Make RDOC friendly

### Author

* John Crepezzi (@seejohnrun)

### LICENSE

(MIT License.  _See LICENSE_)
