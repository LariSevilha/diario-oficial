# frozen_string_literal: true

class SearchsController < ApplicationController
  def index
    @msg = ''
    q = params[:q]
    array_search = []

    # Busca por produtos
    products = Product.where('name ILIKE ?', "%#{q}%")
    products.each do |product|
      array_search << {
        name: product.name,
        photo: product.photo,
        description: product.description,
        slug: product.slug,
        type: 'product'
      }
    end

    blogs = Blog.where('title ILIKE ?', "%#{q}%")
    blogs.each do |blog|
      array_search << {
        title: blog.title,
        type: 'blog'
      }
    end

    portfolios = Portfolio.where('title ILIKE ?', "%#{q}%")
    portfolios.each do |portfolio|
      array_search << {
        photo: portfolio.photo,
        title: portfolio.title,
        description: portfolio.description,
        slug: portfolio.slug,
        type: 'portfolio'
      }
    end

    testimonies = Testimony.where('name ILIKE ?', "%#{q}%")
    testimonies.each do |testimony|
      array_search << {
        name: testimony.name,
        city: testimony.city,
        brief: testimony.brief,
        type: 'testimony'
      }
    end

    @result_search_size = array_search.size

    @result_search = Kaminari.paginate_array(
      array_search, total_count: @result_search_size
    ).page(params[:page])
  end
end
