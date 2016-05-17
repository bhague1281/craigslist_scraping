# require gems
require 'rest-client'
require 'nokogiri'
require 'launchy'

def get_data
  url = 'http://seattle.craigslist.org/search/see/apa'
  apt_page = RestClient.get url

  parsed_apartments = Nokogiri::HTML(apt_page)
end

def filter_results(data)
  print 'Enter a keyword > '
  keyword = gets.chomp.downcase

  filtered = []

  data.css('.hdrlnk').each do |result|
    if result.text.downcase.include? keyword
      uri = result.attributes['href'].value
      link = "http://seattle.craigslist.org#{uri}"
      filtered << {:title => result.text, :link => link}
    end
  end

  filtered.each_with_index do |result, idx|
    puts idx
    puts result[:title]
    puts result[:link]
    puts '---------'
  end

  return filtered
end

def user_input(craigslist_data)
  filtered_data = filter_results(craigslist_data)
  while true
    print 'Select a link to view (q to quit, s to search) > '
    user_idx = gets.chomp
    break if user_idx == 'q'
    if user_idx == 's'
      filtered_data = filter_results(craigslist_data)
    else
      Launchy.open(filtered_data[user_idx.to_i][:link])
    end
  end
end


data = get_data
user_input(data)






