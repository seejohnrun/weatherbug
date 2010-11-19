
require 'rubygems'
require 'nokogiri'
require 'open-uri'

module Weatherbug

  require 'weatherbug/hash_methods'
  require 'weatherbug/transformable_data'
  autoload :Station, 'weatherbug/station'
  autoload :StationHint, 'weatherbug/station_hint'
  autoload :LiveObservation, 'weatherbug/live_observation'
  autoload :Forecast, 'weatherbug/forecast'

  API_URL = 'datafeed.weatherbug.com'


  # Set your application's partner ID 
  def self.partner_id=(partner_id)
    @partner_id = partner_id
  end

  # Get the 25 closest stations, or less in less dense areas
  def self.nearby_stations(lookup_options)
    HashMethods.valid_keys(lookup_options, [:zip_code, :city_code, :postal_code, :include_pws])
    HashMethods.valid_one_only(lookup_options, [:zip_code, :city_code])
    HashMethods.valid_one_only(lookup_options, [:postal_code, :city_code])
    HashMethods.valid_needs(lookup_options, :zip_code, :postal_code) if lookup_options.has_key?(:postal_code)
    response = make_request('StationList', HashMethods.convert_symbols(lookup_options))

    response.xpath('/aws:weather/aws:station').map { |station| Weatherbug::Station.from_document(station) }
  end

  def self.closest_station(lookup_options)
    HashMethods.valid_keys(lookup_options, [:zip_code, :city_code, :postal_code, :include_pws])
    HashMethods.valid_one_only(lookup_options, [:zip_code, :city_code])
    HashMethods.valid_one_only(lookup_options, [:postal_code, :city_code])
    HashMethods.valid_needs(lookup_options, :zip_code, :postal_code) if lookup_options.has_key?(:postal_code)
    params = HashMethods.convert_symbols(lookup_options)
    params['ListType'] = '1'
    response = make_request('StationList', params)

    Weatherbug::Station.from_document response.xpath('/aws:weather/aws:station').first 
  end

  def self.get_station(station_id)
    params = {'StationId' => station_id}
    response = make_request('StationInfo', params)

    Weatherbug::Station.from_document response.xpath('/aws:weather/aws:station').first
  end

  def self.live_observation(station, unit_type = :f)
    station_id = station.is_a?(Weatherbug::Station) ? station.station_id : station
    params = {'StationId' => station_id}
    params['UnitType'] = '1' if unit_type == :c
    response = make_request('LiveObservations', params)

    live_observation = Weatherbug::LiveObservation.from_document response.xpath('/aws:weather/aws:ob').first
    live_observation.send(:station_reference=, station) if station.is_a?(Weatherbug::Station)
    live_observation
  end

  # Get the list of stations in a bounding box
  # Does not return full stations
  def self.stations_in_box(top_right_lat, top_right_lng, bot_left_lat, bot_left_lng)
    params = {
      'LatitudeTopRight' => top_right_lat,
      'LongitudeTopRight' => top_right_lng,
      'LatitudeBottomLeft' => bot_left_lat,
      'LongitudeBottomLeft' => bot_left_lng
    }
    response = make_request('StationListByLatLng', params)
    
    station_data = response.xpath('/aws:weather/aws:stations/aws:station')
    return nil unless station_data 

    station_data.map do |sdata|
      Weatherbug::StationHint.from_document(sdata)
    end
  end

  def self.forecast(options)
    self.retrieve_forecast(1, options)
  end

  private

  # TODO add validation for fields
  def self.retrieve_forecast(forecast_type, options)
    HashMethods.valid_keys(options, [:latitude, :longitude])
    params = HashMethods.convert_symbols(options)
    params['ForecastType'] = forecast_type
    response = make_request(options.has_key?(:longitude) ? 'ClosestForecastByLatLng' : 'Forecast', params)

    forecast_data = response.xpath('/aws:weather/aws:forecasts/aws:forecast')
    return nil unless forecast_data

    forecast_data.map do |fdata|
      Weatherbug::Forecast.from_document(fdata)
    end
  end

  # Make the actual request, unwrap it and send it back
  # Handles errors that may come up
  def self.make_request(method, params)
    params['RequestType'] = method
    params['PartnerId'] = @partner_id
    data = open("http://#{API_URL}/GetXml.aspx?#{params.map { |k, v| "#{k}=#{v}" }.join('&')}")
    raise Exception.new("Unexpected exception - empty response") unless data
    Nokogiri::XML(data)
  end

end

Weatherbug.partner_id = 'f0c313fe-fffe-4f5d-96dc-5a5d6ec9eb30'
stations = Weatherbug::nearby_stations(:zip_code => '08005')
