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

  it 'should have the fields that zip code stations should have' do
    [:id, :name, :zip_code, :station_type, :city, :state].each { |k| @station_from_zip.send(k).should be_a(String) }
    [:distance, :latitude, :longitude].each { |k| @station_from_zip.send(k).should be_a(Float) }
  end

  it 'should have the fields that city code stations should have' do
    [:id, :name, :city, :country].each { |k| @station_from_city_code.send(k).should be_a(String) }
    [:city_code].each { |k| @station_from_city_code.send(k).should be_a(Fixnum) }
    [:latitude, :longitude].each { |k| @station_from_city_code.send(k).should be_a(Float) }
  end

  it 'should have the fields that US stations should have' do
    station = Weatherbug.get_station('AWSHQ')
    station.id.should == 'AWSHQ'
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
    station.id.should == 'SBMO'
    station.name.should == 'Maceio (Campo Palmar)'
    station.city.should == 'Maceio'
    station.state.should == 'BR'
    station.zip_code.should == '00000'
    station.station_type.should == 'NWS'
    station.latitude.should == -9.51667
    station.longitude.should == -35.78333
  end

end
