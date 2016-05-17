require 'rest-client'
require 'nokogiri'
require 'launchy'

# constants for API
SEATTLE_APARTMENTS = "http://seattle.craigslist.org/search/see/apa"

# get HTML page from the URL and return it in a Nokogiri object
def get_data(url)
  page = RestClient.get(url)
  Nokogiri::HTML(page)
end

# take a Nokogiri object and filter it by keyword, then print and return results
def filter_results(results, keyword)
  print 'Enter a keyword > '
  keyword = gets.chomp.downcase

  filtered = []

  results.css('.hdrlnk').each do |result|
    if result.text.downcase.include? keyword
      uri = result.attributes['href'].value
      link = "http://seattle.craigslist.org#{uri}"
      filtered << {:title => result.text, :link => link}
    end
  end

  print_results(filtered)

  filtered
end

# print results (array of hashes with title and link)
def print_results(results)
  results.each_with_index do |result, idx|
    puts idx, result[:title], result[:link], '---------'
  end
end

# run the client, which allows the user to select links and filter
def client
  html_page = get_data(SEATTLE_APARTMENTS)
  filtered_data = filter_results(html_page)
  while true
    print 'Select a link to view (q to quit, s to search) > '
    user_idx = gets.chomp.downcase
    if user_idx == 'q'
      break
    elsif user_idx == 's'
      filtered_data = filter_results(html_page)
    elsif not (0...filtered_data.length) === user_idx.to_i
      puts 'Invalid index. Try again'
    else
      Launchy.open(filtered_data[user_idx.to_i][:link])
    end
  end
end

# run client
client






