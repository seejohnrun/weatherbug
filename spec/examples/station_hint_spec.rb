require File.dirname(__FILE__) + '/spec_helper'

describe Weatherbug::StationHint do

  before(:all) do
    @hint = Weatherbug::stations_in_box(67.609, -18.413, -7.71, -137.153).last
  end

  it 'should have the fields a hint should have' do
    ['name', 'station_id'].each { |k| @hint.send(k).should be_a(String) }
  end

  it 'should be able to get the real station from a hint' do
    @hint.station.should be_a(Weatherbug::Station)
    @hint.station.station_id.should == @hint.station_id
  end

  it 'should be able to hold onto a station when you call for it twice' do
    station = @hint.station
    @hint.station.object_id.should == station.object_id
  end

end
