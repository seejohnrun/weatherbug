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
