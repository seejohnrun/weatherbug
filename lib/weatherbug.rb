
require 'rubygems'
require 'nokogiri'
require 'open-uri'

module Weatherbug

  require 'weatherbug/hash_methods'
  require 'weatherbug/transformable_data'
  autoload :Station, 'weatherbug/station'

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

  private

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
