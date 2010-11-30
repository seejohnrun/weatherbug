require File.dirname(__FILE__) + '/spec_helper'

describe WeatherBug::LiveObservation do

  before(:all) do
    @live_observation = WeatherBug::live_observation('AWSHQ')
  end

  it 'should have the fields that live observations should have' do
    [:dew_point, :elevation, :feels_like, :humidity, :temp_high, :temp_low, :wind_speed].each { |k| @live_observation.send(k).should be_a(Fixnum) }
    [:station_id, :wind_direction, :temp_units, :station_name, :description, :icon].each { |k| @live_observation.send(k).should be_a(String) }
    [:pressure].each { |k| @live_observation.send(k).should be_a(Float) }
  end

  it 'should be able to take a live observation and get its city' do
    @live_observation.station.should be_a(WeatherBug::Station)
  end

  it 'should be able to get a description from a live observation' do
    @live_observation.description.length.should > 0
  end

  it 'should be able to get an icon from a live observation' do
    @live_observation.icon.length.should > 0
  end

end
