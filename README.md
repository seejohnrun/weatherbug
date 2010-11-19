# WeatherBug Partner API

To get set up:

    gem install weatherbug

This is a Ruby interface for the Weatherbug Partner API.  It does not cover the entire API, but covers basic functionality.

    stations = WeatherBug::nearest_stations(:zip_code => '10012')
		station = WeatherBug::closest_station(:zip_code => '08005')

You can do some cool things with stations:

    station.live_observation
    station.forecast

### TODO

* Expand the README

### Author

* John Crepezzi

### LICENSE

(MIT License.  _See LICENSE_)
