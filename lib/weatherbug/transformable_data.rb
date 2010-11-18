module Weatherbug
  
  # This is a super-convenient class for transorming data and requiring things in the 
  # different associated Weatherbug data classes
  class TransformableData

    def self.register_transformer(name, options = {})
      @transformers ||= {}
      private; attr_writer options[:name]
      public;  attr_reader options[:name]
      @transformers[name] = options
    end

    def self.from_document(document)
      object = self.new
      @transformers.each do |key, options|
        value = document.xpath(key).text
        puts value if key == 'aws:station-id' && value.empty?
        # If this thing is not optional, blow up on us
        raise ArgumentError.new("Required value missing from API: #{key}") if options.has_key?(:required) && options[:required] && (value.nil? || value.empty?)
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
