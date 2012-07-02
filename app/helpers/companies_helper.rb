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
