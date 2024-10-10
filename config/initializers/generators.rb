# frozen_string_literal: true

Rails.application.configure do
  # Disabel Generate assets and helpes
  config.generators.assets = false
  config.generators.helper = false

  # don't generate RSpec tests for views and helpers
  config.generators do |g|
    g.test_framework nil
    g.view_specs false
    g.helper_specs false
    g.request_specs false
  end
end
