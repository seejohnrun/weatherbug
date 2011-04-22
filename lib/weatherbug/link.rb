module WeatherBug

  class Link < TransformableData

    register_transformer '@linkname', :name => :link_name
    register_transformer '@zipcode', :name => :zip_code
    register_transformer '@url', :name => :url

  end

end
