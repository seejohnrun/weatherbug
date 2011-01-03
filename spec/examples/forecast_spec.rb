require File.dirname(__FILE__) + '/spec_helper'

describe WeatherBug::Forecast do

  before(:all) do
    @forecast = WeatherBug.forecast(:latitude => 39.095, :longitude => -77.783).first
  end

  it 'should have the fields that forecasts have' do
    [:title, :short_title, :description, :prediction, :temp_units, :probability_of_precipitation, :icon].each { |k| @forecast.send(k).should be_a(String) }
    [:temp_high, :temp_low].each { |k| @forecast.send(k).should be_a(Fixnum) }
    [:date].each { |k| @forecast.send(k).should be_a(Date) }
    [:condition].each { |k| @forecast.send(k).should be_a(Symbol) }
    @forecast.temp_units.should == '°F'
  end

  it 'should return the correct number of days when given today' do
    forecast = WeatherBug::Forecast.new
    forecast.send(:title=, 'Today')
    forecast.date.to_s.should == Date.today.to_s
  end

  it 'should return the correct number of days when given tonight' do
    forecast = WeatherBug::Forecast.new
    forecast.send(:title=, 'Tonight')
    forecast.date.to_s.should == Date.today.to_s
  end

  it 'should return the correct number of days when given tomorrow' do
    forecast = WeatherBug::Forecast.new
    forecast.send(:title=, 'Tomorrow')
    forecast.date.to_s.should == (Date.today + 1).to_s
  end

  it 'should return the correct number of days when given tomorrow night' do
    forecast = WeatherBug::Forecast.new
    forecast.send(:title=, 'Tomorrow night')
    forecast.date.to_s.should == (Date.today + 1).to_s
  end

  it 'should return a week from now when given today\'s wday' do
    forecast = WeatherBug::Forecast.new
    forecast.send(:title=, Date::DAYNAMES[Date.today.wday])
    forecast.date.to_s.should == (Date.today + 7).to_s
  end

  it 'should return proper when given a wday later in the week' do
    unless Date.today.wday >= 4 # Can't run this late in the week
      forecast = WeatherBug::Forecast.new
      forecast.send(:title=, Date::DAYNAMES[Date.today.wday + 2])
      forecast.date.to_s.should == (Date.today + 2).to_s 
    end
  end

  it 'should return proper when given a wday earlier in the week' do
    unless Date.today.wday <= 1 # Can't run this early in the week
      forecast = WeatherBug::Forecast.new
      forecast.send(:title=, Date::DAYNAMES[Date.today.wday - 2])
      forecast.date.to_s.should == (Date.today + 5).to_s 
    end
  end

end
