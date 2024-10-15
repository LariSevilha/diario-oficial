# frozen_string_literal: true
 
every 1.day, at: '3:20 pm' do
  rake 'official_diary:check_publication'
end
