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

module CompaniesHelper
  
  def get_stat_hash(level, capacity, type, specialized)
    stat_hash = {}
    stat_hash["fixed_cost"] = calculate_fixed_cost(level, capacity, type, specialized)
    stat_hash["variable_cost"] = calculate_variable_cost(level, capacity, type, specialized)
    stat_hash
  end

  private
  
  def calculate_fixed_cost(level, capacity, type, specialized)
    if specialized
      (1000*level*capacity*type)/2
    else
      (1000*level*capacity*type)
    end
  end

  def calculate_variable_cost(level, capacity, type, specialized)
    if specialized
      (100*level*capacity*type)/2
    else
      (100*level*capacity*type)
    end
  end
end
