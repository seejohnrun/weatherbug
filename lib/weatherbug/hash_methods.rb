module WeatherBug

  class HashMethods

    WB_MAPPING = {
      :zip_code => 'ZipCode',
      :city_code => 'CityCode',
      :postal_code => 'PostalCode',
      :include_pws => 'IncludePWS',
      :latitude => 'Latitude',
      :longitude => 'Longitude',
    }

    # Raise an argument error if we get invalid keys at all
    def self.valid_keys(hash, allowed)
      invalids = nil
      hash.keys.each { |key| (invalids ||= []; invalids << key) unless allowed.include?(key) }
      raise ArgumentError.new("Invalid options: #{invalids.join(', ')}") unless invalids.nil?
    end

    def self.valid_one_only(hash, conflictions)
      conflicts = []
      conflictions.each { |c| conflicts << c if hash.keys.include?(c) }
      raise ArgumentError.new("Cannot combine options: #{conflicts.join(', ')}") if conflicts.size > 1
    end

    def self.valid_needs(hash, key, key_for)
      raise ArgumentError.new("You must supply option #{key} to use #{key_for}") unless hash.has_key?(key)
    end

    def self.convert_symbols(hash)
      hash.inject({}) do |rhash, (original_key, value)|
        rhash[WB_MAPPING.fetch(original_key, original_key)] = value
        rhash
      end
    end

  end

end
