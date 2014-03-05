module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Network Business Game"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def line_break(string)
      string.gsub("\n", '<br/>')
  end

  def win_to_uni(string)
    string.gsub("\r\n", "\n\n")
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def params_capacity_name
    !Parameters.instance.capacity_name.blank? ? Parameters.instance.capacity_name : "Capacity"
  end

  def params_experience_name
    !Parameters.instance.experience_name.blank? ? Parameters.instance.experience_name : "Customer Experience"
  end

  def params_unit_name
    !Parameters.instance.unit_name.blank? ? Parameters.instance.unit_name : "Unit"
  end

end