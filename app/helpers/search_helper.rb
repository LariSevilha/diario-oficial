# frozen_string_literal: true

module SearchHelper
  def type_name(number_type, _category = nil)
    case number_type
    when 'blog'
      'Blog'
    when 'portfolio'
      'Portfólios'
    when 'product'
      'Produtos'
    end
  end

  def url_link(result_search)
    case result_search[:type]
    when 'blog'
      blog_path(result_search[:slug])
    when 'portfolio'
      portfolio_path(result_search[:slug])
    when 'product'
      product_path(result_search[:slug])
    else
      result_search[:slug]
    end
  end
end
