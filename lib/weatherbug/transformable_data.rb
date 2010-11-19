module WeatherBug
  
  # This is a super-convenient class for transorming data and requiring things in the 
  # different associated WeatherBug data classes
  class TransformableData

    def self.register_transformer(name, options = {})
      @transformers ||= {}
      options[:name] = name.split(/[:@]/).last.gsub('-', '_').to_sym unless options.has_key?(:name)
      private; attr_writer options[:name]
      public;  attr_reader options[:name]
      @transformers[name] = options
    end

    def self.from_document(document)
      object = self.new
      @transformers.each do |key, options|
        value = document.xpath(key).text
        # If this thing is empty, skip it
        next if value.nil?
        # If this thing needs to be transformed, transform it (from a string)
        value = value.send(options[:transform]) if options.has_key?(:transform)
        # Assign it on the class
        object.send("#{options[:name]}=", value)
      end
      object
    end

  end

end
