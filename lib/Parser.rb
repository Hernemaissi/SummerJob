module Parser
  # Make a class method available to define space-trimming behavior.
  def self.included base
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Register a before-validation handler for the given fields to
    # trim leading and trailing spaces.
    def parsed_fields *field_list
     field_list.each do |field|
      define_method("#{field}=") do |value|
        self[field] = value.is_a?(String) ? value.gsub(/\s+/, "") : value
      end
     end
    end
  end
end