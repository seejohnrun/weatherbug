
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'

module WeatherBug

  require 'weatherbug/hash_methods'
  require 'weatherbug/transformable_data'
  autoload :Station, 'weatherbug/station'
  autoload :StationHint, 'weatherbug/station_hint'
  autoload :LiveObservation, 'weatherbug/live_observation'
  autoload :Forecast, 'weatherbug/forecast'
  autoload :Link, 'weatherbug/link'

  API_URL = 'datafeed.weatherbug.com'

  Error = Class.new(RuntimeError)
  NoSuchStation = Class.new(Error)

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
    lookup_options[:include_pws] = '1' if lookup_options.has_key?(:include_pws)
    response = make_request('StationList', HashMethods.convert_symbols(lookup_options))

    response.xpath('/aws:weather/aws:station').map { |station| WeatherBug::Station.from_document(station) }
  end

  def self.closest_station(lookup_options)
    HashMethods.valid_keys(lookup_options, [:zip_code, :city_code, :postal_code, :include_pws])
    HashMethods.valid_one_only(lookup_options, [:zip_code, :city_code])
    HashMethods.valid_one_only(lookup_options, [:postal_code, :city_code])
    HashMethods.valid_needs(lookup_options, :zip_code, :postal_code) if lookup_options.has_key?(:postal_code)
    params = HashMethods.convert_symbols(lookup_options)
    params['ListType'] = '1'
    lookup_options[:include_pws] = '1' if lookup_options.has_key?(:include_pws)
    response = make_request('StationList', params)

    WeatherBug::Station.from_document response.xpath('/aws:weather/aws:station').first 
  end

  def self.get_station(station_id)
    params = {'StationId' => station_id}
    response = make_request('StationInfo', params)

    WeatherBug::Station.from_document response.xpath('/aws:weather/aws:station').first
  end

  # Get links for a certain zip code or postal code
  def self.get_links(link_names = [], lookup_options = {})
    HashMethods.valid_keys(lookup_options, [:zip_code, :postal_code])
    HashMethods.valid_one_only(lookup_options, [:zip_code, :postal_code])
    HashMethods.valid_needs(lookup_options, :zip_code, :postal_code) if lookup_options.has_key?(:postal_code)
    params = HashMethods.convert_symbols(lookup_options)
    params['LinkName'] = link_names.is_a?(Array) ? link_names.join(',') : link_names
    response = make_request('GetLink', params)

    response.xpath('/aws:weather/aws:Links/aws:Link').map do |link_data|
      WeatherBug::Link.from_document link_data
    end
  end

  def self.live_observation(station, unit_type = :f)
    station_id = station.is_a?(WeatherBug::Station) ? station.station_id : station
    params = {'StationId' => station_id}
    params['UnitType'] = '1' if unit_type == :c
    params['ShowIcon'] = '1'
    response = make_request('LiveObservations', params)

    live_observation = WeatherBug::LiveObservation.from_document response.xpath('/aws:weather/aws:ob').first
    live_observation.send(:station_reference=, station) if station.is_a?(WeatherBug::Station)
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
      WeatherBug::StationHint.from_document(sdata)
    end
  end

  def self.forecast(options)
    self.retrieve_forecast(7, options)
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
      WeatherBug::Forecast.from_document(fdata)
    end
  end

  # Make the actual request, unwrap it and send it back
  # Handles errors that may come up
  def self.make_request(method, params)
    params['RequestType'] = method
    params['PartnerId'] = @partner_id
    data = open("http://#{API_URL}/GetXml.aspx?#{params.map { |k, v| "#{k}=#{v}" }.join('&')}")
    raise Error.new("Unexpected exception - empty response") unless data
    Nokogiri::XML(data)
  end

end
