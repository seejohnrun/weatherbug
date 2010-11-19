require File.dirname(__FILE__) + '/spec_helper'

describe Weatherbug, :nearby_stations do
  
  it 'should be able to get 25 nearby stations for a given zip code' do
    stations = Weatherbug::nearby_stations(:zip_code => '08005')
    stations.size.should be > 0
    stations.each { |s| s.class.should == Weatherbug::Station }  
  end

  it 'should not be able to use bad options' do
    lambda do
      stations = Weatherbug::nearby_stations(:john => 'is_cool')
    end.should raise_error(ArgumentError)
  end

  it 'should not be able to combine zip code and city code' do
    lambda do
      stations = Weatherbug::nearby_stations(:zip_code => '08005', :city_code => 64712)
    end.should raise_error(ArgumentError)
  end

  it 'should not be able to combine postal code and city code' do
    lambda do
      stations = Weatherbug::nearby_stations(:postal_code => '2345', :city_code => 64712)
    end.should raise_error(ArgumentError)
  end

  it 'should be able to use zip code and postal code' do
    stations = Weatherbug::nearby_stations(:zip_code => '08005', :postal_code => '1234')
    stations.size.should be > 0
    stations.each { |s| s.should be_a(Weatherbug::Station) }
  end

  it 'should require postal code when using zip code' do
    lambda do
      stations = Weatherbug::nearby_stations(:postal_code => 1234)
    end.should raise_error(ArgumentError)
  end

end

describe Weatherbug, :closest_station do
  
  it 'should be able to get 25 nearby stations for a given zip code' do
    station = Weatherbug::closest_station(:zip_code => '08005')
    station.should be_a(Weatherbug::Station) 
  end

  it 'should not be able to use bad options' do
    lambda do
      station = Weatherbug::closest_station(:john => 'is_cool')
    end.should raise_error(ArgumentError)
  end

  it 'should not be able to combine zip code and city code' do
    lambda do
      station = Weatherbug::closest_station(:zip_code => '08005', :city_code => 64712)
    end.should raise_error(ArgumentError)
  end

  it 'should not be able to combine postal code and city code' do
    lambda do
      station = Weatherbug::closest_station(:postal_code => '2345', :city_code => 64712)
    end.should raise_error(ArgumentError)
  end

  it 'should be able to use zip code and postal code' do
    station = Weatherbug::closest_station(:zip_code => '08005', :postal_code => '1234')
    station.should be_a(Weatherbug::Station)
  end

  it 'should require postal code when using zip code' do
    lambda do
      station = Weatherbug::closest_station(:postal_code => 1234)
    end.should raise_error(ArgumentError)
  end

end

describe Weatherbug, :get_station do

  it 'should be able to get a valid station' do
    station = Weatherbug::get_station('AWSHQ')
    station.should be_a(Weatherbug::Station)
  end

  it 'should get nothing when requesting an invalid station' do
    lambda do
      station = Weatherbug::get_station('fake')
    end.should raise_error(ArgumentError)
  end

end

describe Weatherbug, :live_observation do

  it 'should be able to get live observations for a station' do
    lops = Weatherbug::live_observation('AWSHQ')
    lops.should be_a(Weatherbug::LiveObservation)
  end

  it 'should get no result when getting live observations for a non-existent station' do
    lambda do
      lops = Weatherbug::live_observation('fake')
    end.should raise_error(ArgumentError)
  end

  it 'should be able to get live observations for a station in F degrees' do
    lops = Weatherbug::live_observation('AWSHQ', :f)
    lops.temp_units.should == '&deg;F'
  end

  it 'should be able to get live observations for a station in C degrees' do
    lops = Weatherbug::live_observation('AWSHQ', :c)
    lops.temp_units.should == '&deg;C'
  end

end

describe Weatherbug, :forecast do

  it 'should be able to get a forecast by lat/lng' do
    forecasts = Weatherbug::forecast(:latitude => 39.095, :longitude => -77.783)
    forecasts.length.should > 0
    forecasts.each { |f| f.should be_a(Weatherbug::Forecast) }
  end

end

describe Weatherbug, :stations_in_box do

  it 'should be able to get a list of station hints by bounding box' do
    station_hints = Weatherbug::stations_in_box(67.609, -18.413, -7.71, -137.153)
    station_hints.length.should > 0
    station_hints.each { |f| f.should be_a(Weatherbug::StationHint) }
  end

end
