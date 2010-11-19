require File.dirname(__FILE__) + '/spec_helper'

describe Weatherbug::Station do

  before(:all) do
    @station_from_zip = Weatherbug::closest_station(:zip_code => '08005')
    @station_from_zip.should be_a(Weatherbug::Station)
  end

  before(:all) do
    @station_from_city_code = Weatherbug::closest_station(:city_code => 65355)
    @station_from_city_code.should be_a(Weatherbug::Station)
  end

  before(:all) do
    @station = @station_from_zip # no need to re-request
  end

  it 'should have the fields that zip code stations should have' do
    [:station_id, :name, :zip_code, :station_type, :city, :state].each { |k| @station_from_zip.send(k).should be_a(String) }
    [:distance, :latitude, :longitude].each { |k| @station_from_zip.send(k).should be_a(Float) }
  end

  it 'should have the fields that city code stations should have' do
    [:station_id, :name, :city, :country].each { |k| @station_from_city_code.send(k).should be_a(String) }
    [:city_code].each { |k| @station_from_city_code.send(k).should be_a(Fixnum) }
    [:latitude, :longitude].each { |k| @station_from_city_code.send(k).should be_a(Float) }
  end

  it 'should have the fields that US stations should have' do
    station = Weatherbug.get_station('AWSHQ')
    station.station_id.should == 'AWSHQ'
    station.name.should == 'WeatherBug Headquarters'
    station.city.should == 'Germantown'
    station.state.should == 'MD'
    station.zip_code.should == '20876'
    station.station_type.should == 'WeatherBug'
    station.latitude.should == 39.20055
    station.longitude.should == -77.26305
  end

  it 'should have the fields that international stations should have' do
    station = Weatherbug.get_station('SBMO')
    station.station_id.should == 'SBMO'
    station.name.should == 'Maceio (Campo Palmar)'
    station.city.should == 'Maceio'
    station.state.should == 'BR'
    station.zip_code.should == '00000'
    station.station_type.should == 'NWS'
    station.latitude.should == -9.51667
    station.longitude.should == -35.78333
  end

  it 'should be able to retrieve a live observation for a station' do
    lobs = @station.live_observation
    lobs.should be_a(Weatherbug::LiveObservation)
  end

  it 'should be able to retrieve a celcius observation for a station' do
    lobs = @station.live_observation(:c)
    lobs.should be_a(Weatherbug::LiveObservation)
    lobs.temp_units.should == '&deg;C'
  end

  it 'should be able to make a round trip and not have to hit the api twice - live observation' do
    @station.live_observation.station.object_id.should == @station.object_id
  end

  it 'should be able to retrieve a forecast for a station' do
    forecasts = @station.forecast
    forecasts.length.should > 0
    forecasts.each { |f| f.should be_a(Weatherbug::Forecast) }
  end

end
