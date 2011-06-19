require File.dirname(__FILE__) + '/spec_helper'

describe WeatherBug, :nearby_stations do
  
  it 'should be able to get 25 nearby stations for a given zip code' do
    stations = WeatherBug::nearby_stations(:zip_code => '08005')
    stations.size.should be > 0
    stations.each { |s| s.class.should == WeatherBug::Station }  
  end

  it 'should not be able to use bad options' do
    lambda do
      stations = WeatherBug::nearby_stations(:john => 'is_cool')
    end.should raise_error(ArgumentError)
  end

  it 'should not be able to combine zip code and city code' do
    lambda do
      stations = WeatherBug::nearby_stations(:zip_code => '08005', :city_code => 64712)
    end.should raise_error(ArgumentError)
  end

  it 'should not be able to combine postal code and city code' do
    lambda do
      stations = WeatherBug::nearby_stations(:postal_code => '2345', :city_code => 64712)
    end.should raise_error(ArgumentError)
  end

  it 'should be able to use zip code and postal code' do
    stations = WeatherBug::nearby_stations(:zip_code => '08005', :postal_code => '1234')
    stations.size.should be > 0
    stations.each { |s| s.should be_a(WeatherBug::Station) }
  end

  it 'should require postal code when using zip code' do
    lambda do
      stations = WeatherBug::nearby_stations(:postal_code => 1234)
    end.should raise_error(ArgumentError)
  end

  it 'should give different results when including pws' do
    stations1 = WeatherBug::nearby_stations(:zip_code => '08005')
    stations2 = WeatherBug::nearby_stations(:zip_code => '08005', :include_pws => true)

    s1hash = stations1.map { |s| s.station_id }.sort.join('/')
    s2hash = stations2.map { |s| s.station_id }.sort.join('/')

    s1hash.should_not == s2hash
  end

end

describe WeatherBug, :closest_station do
  
  it 'should be able to get 25 nearby stations for a given zip code' do
    station = WeatherBug::closest_station(:zip_code => '08005')
    station.should be_a(WeatherBug::Station) 
  end

  it 'should not be able to use bad options' do
    lambda do
      station = WeatherBug::closest_station(:john => 'is_cool')
    end.should raise_error(ArgumentError)
  end

  it 'should not be able to combine zip code and city code' do
    lambda do
      station = WeatherBug::closest_station(:zip_code => '08005', :city_code => 64712)
    end.should raise_error(ArgumentError)
  end

  it 'should not be able to combine postal code and city code' do
    lambda do
      station = WeatherBug::closest_station(:postal_code => '2345', :city_code => 64712)
    end.should raise_error(ArgumentError)
  end

  it 'should be able to use zip code and postal code' do
    station = WeatherBug::closest_station(:zip_code => '08005', :postal_code => '1234')
    station.should be_a(WeatherBug::Station)
  end

  it 'should require postal code when using zip code' do
    lambda do
      station = WeatherBug::closest_station(:postal_code => 1234)
    end.should raise_error(ArgumentError)
  end

end

describe WeatherBug, :get_station do

  it 'should be able to get a valid station' do
    station = WeatherBug::get_station('AWSHQ')
    station.should be_a(WeatherBug::Station)
  end

  it 'should get nothing when requesting an invalid station' do
    lambda do
      station = WeatherBug::get_station('fake')
    end.should raise_error(WeatherBug::NoSuchStation)
  end

end

describe WeatherBug, :live_observation do

  it 'should be able to get live observations for a station' do
    lops = WeatherBug::live_observation('AWSHQ')
    lops.should be_a(WeatherBug::LiveObservation)
  end

  it 'should get no result when getting live observations for a non-existent station' do
    lambda do
      lops = WeatherBug::live_observation('fake')
    end.should raise_error(WeatherBug::NoSuchStation)
  end

  it 'should be able to get live observations for a station in F degrees' do
    lops = WeatherBug::live_observation('AWSHQ', :f)
    lops.temp_units.should == '&deg;F'
  end

  it 'should be able to get live observations for a station in C degrees' do
    lops = WeatherBug::live_observation('AWSHQ', :c)
    lops.temp_units.should == '&deg;C'
  end

end

describe WeatherBug, :forecast do

  it 'should be able to get a forecast by lat/lng' do
    forecasts = WeatherBug::forecast(:latitude => 39.095, :longitude => -77.783)
    forecasts.length.should > 0
    forecasts.each { |f| f.should be_a(WeatherBug::Forecast) }
  end

end

describe WeatherBug, :stations_in_box do

  it 'should be able to get a list of station hints by bounding box' do
    station_hints = WeatherBug::stations_in_box(67.609, -18.413, -7.71, -137.153)
    station_hints.length.should > 0
    station_hints.each { |f| f.should be_a(WeatherBug::StationHint) }
  end

end
