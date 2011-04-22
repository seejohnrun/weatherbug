require File.dirname(__FILE__) + '/spec_helper'

describe WeatherBug::Link do

  it 'should be able to get links for a zip code' do
    links = WeatherBug.get_links 'home', :zip_code => '08005'
    links.should_not be_empty
    links.each do |link|
      link.should be_a(WeatherBug::Link)
    end
  end

  it 'should be able to get certain fields for a link' do
    links = WeatherBug.get_links 'home', :zip_code => '08005'
    links.should_not be_empty
    links.first.url.should_not be_empty
    links.first.zip_code.should == '08005'
    links.first.link_name.should_not be_empty
  end

  it 'should be able to get multiple link types at once' do
    links = WeatherBug.get_links ['home', 'forecast'], :zip_code => '08005'
    links.should_not be_empty
  end

end
