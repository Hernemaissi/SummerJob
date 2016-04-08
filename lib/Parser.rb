=begin
This file is part of Network Service Business Game.

    Network Service Business Game is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Network Service Business Game is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Network Service Business Game.  If not, see <http://www.gnu.org/licenses/>
=end

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
        if value.is_a?(Hash)
          value.each do |k, v|
            value[k] = (v.is_a?(String) && v.gsub(/\s+/, "").to_f != 0) ? v.gsub(/\s+/, "") : v
          end
        end

      end
     end
    end
  end
end
