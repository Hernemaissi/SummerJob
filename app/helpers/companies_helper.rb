module CompaniesHelper
  def update_stats(c)
    c.max_capacity = get_max_capacity(c.size)
    c.max_penetration = get_max_penetration(c.size)
    c.max_quality = get_max_quality(c.size)
    c.fixedCost = get_fixed_cost(c.size)
    c.variableCost = get_variable_cost(c.size)
    c.save
  end
  
  def stat_hash(size)
    stats = Hash.new
    stats["max_capacity"] = get_max_capacity(size)
    stats["max_penetration"] = get_max_penetration(size)
    stats["max_quality"] = get_max_quality(size)
    stats["fixed_cost"] = get_fixed_cost(size)
    stats["variable_cost"] = get_variable_cost(size)
    stats
  end
  
  private
  
  def get_max_capacity(size)
    1000*size
  end
  
  def get_max_penetration(size)
    5*size
  end
  
  def get_max_quality(size)
    100*size
  end
  
  def get_fixed_cost(size)
    1000*size
  end
  
  def get_variable_cost(size)
    1000*size
  end
end
