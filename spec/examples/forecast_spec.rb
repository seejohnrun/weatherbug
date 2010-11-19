require File.dirname(__FILE__) + '/spec_helper'

describe WeatherBug::Forecast do

  before(:all) do
    @forecast = WeatherBug.forecast(:latitude => 39.095, :longitude => -77.783).first
  end

  it 'should have the fields that forecasts have' do
    [:title, :short_title, :description, :prediction, :temp_units, :probability_of_precipitation].each { |k| @forecast.send(k).should be_a(String) }
    [:temp_high, :temp_low].each { |k| @forecast.send(k).should be_a(Fixnum) }
    @forecast.temp_units.should == '°F'
  end

end
