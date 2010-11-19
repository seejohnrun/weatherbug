module WeatherBug

  class Forecast < TransformableData

    register_transformer 'aws:title', :required => true   
    register_transformer 'aws:city'
    register_transformer 'aws:short-title'
    register_transformer 'aws:icon'
    register_transformer 'aws:description'
    register_transformer 'aws:prediction'
    register_transformer 'aws:lo', :name => :temp_low, :transform => :to_i
    register_transformer 'aws:hi', :name => :temp_high, :transform => :to_i
    register_transformer 'aws:hi/@units', :name => :temp_units
    register_transformer 'aws:prob-of-precip', :name => :probability_of_precipitation

    def date 
      date ||= begin
        key = title.split[0] # Remove 'night'
        return Date.today if key == 'Today' || key == 'Tonight'
        return Date.today + 1 if key == 'Tomorrow'
        # Figure out how far forward to go
        return nil unless appropriate_wday_index = Date::DAYNAMES.index(key)
        today_index = Date.today.wday

        distance = appropriate_wday_index - today_index
        Date.today + (distance > 0 ? distance : distance + 7)
      end
    end

  end

end
