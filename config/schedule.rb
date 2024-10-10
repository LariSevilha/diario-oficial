# frozen_string_literal: true
 

every 1.day, at: '2:30 pm' do
  rake "official_diary:check_and_publish"
end 