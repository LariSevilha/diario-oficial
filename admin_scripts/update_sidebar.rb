# frozen_string_literal: true

require 'nokogiri'
require 'active_support/inflector'

def update_sidebar(sidebar_path, model_name)
  new_link = "<li><a href='/admin/#{model_name.downcase}s'>#{model_name}s</a></li>"

  # Read the current content of the sidebar partial
  sidebar_content = File.read(sidebar_path)

  # Parse the sidebar content using Nokogiri
  doc = Nokogiri::HTML(sidebar_content)
  ul = doc.at_css('div#sidebar-menu > ul')

  # Find the existing "Navegação" section
  navigation_section = ul.xpath('.//span[contains(text(), "Navegação")]/ancestor::li')

  if navigation_section.any?
    # Add the new link to the "Navegação" section if it doesn't already exist
    nav_ul = navigation_section.css('ul').first
    nav_ul.add_child(Nokogiri::HTML::DocumentFragment.parse(new_link)) unless nav_ul.to_html.include?(new_link)
  else
    # Create a new "Navegação" section with the new link
    new_navigation_section = <<-HTML
      <li class="has_sub">
        <a href="javascript:void(0);" class="waves-effect">
          <i class="dripicons-home"></i>
          <span> Navegação </span>
          <span class="menu-arrow float-right">
            <i class="mdi mdi-chevron-right"></i>
          </span>
        </a>
        <ul class="list-unstyled">
          #{new_link}
        </ul>
      </li>
    HTML

    ul.add_child(Nokogiri::HTML::DocumentFragment.parse(new_navigation_section))
  end

  # Write the updated content back to the sidebar partial
  File.open(sidebar_path, 'w') { |file| file.write(doc.to_html) }

  puts "Sidebar updated successfully: #{sidebar_path}"
end

# Get the sidebar file path and model name from the command line arguments
sidebar_path = ARGV[0]
model_name = ARGV[1]

if sidebar_path && model_name
  update_sidebar(sidebar_path, model_name)
else
  puts 'Usage: ruby update_sidebar.rb <sidebar_path> <model_name>'
end
