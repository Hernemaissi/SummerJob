module CompaniesHelper
  def update_stats(c)
    c.max_capacity = 1000*c.size
    c.max_penetration = 5*c.size
    c.max_quality = 100*c.size
    c.fixedCost = 1000*c.size
    c.variableCost = 1000*c.size
    c.save
  end
end
