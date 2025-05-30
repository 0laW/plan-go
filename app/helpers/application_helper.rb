module ApplicationHelper
  def nav_link_class(path, options = {})
    base_class = options[:class] || "nav-link"
    active_class = options[:active_class] || "active"

    if current_page?(path)
      "#{base_class} #{active_class}"
    else
      base_class
    end
  end

  def nav_item_active?(paths)
    paths = [paths] unless paths.is_a?(Array)
    paths.any? { |path| current_page?(path) }
  end

  # For dropdown menus that should be active when any child is active
  def dropdown_active?(paths)
    nav_item_active?(paths) ? "active" : ""
  end


end
