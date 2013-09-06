require 'addressable/uri'
require 'net/http'
require 'uri'

working_dir      = '/Users/chris/Desktop/'
url_source_file  = "#{working_dir}bad_urls.txt"
INVALID_URLS = "#{working_dir}invalid_urls.txt"
NON_404s     = "#{working_dir}non_404s.txt"
TO_REDIRECT  = "#{working_dir}to_redirect.txt"


def valid_url?(url)
	parsed = Addressable::URI.parse(url) or return false
	['http', 'https'].include?(parsed.scheme)
rescue Addressable::URI::InvalidURIError
	false
end

def get_response_code(url)
	uri = URI.parse(url)
	http = Net::HTTP.new(uri.host, '80')
	request = Net::HTTP::Get.new(uri.request_uri)
	response = http.request(request)
	response.code
end

def parse_url_file(path)
	file = File.open(path, "r")
	data = file.read
	file.close
	data.split("\n")
end

def write_invalid_url(url)
	File.open(INVALID_URLS, 'a') { |file| file.write("#{url}\n") }
end

def write_non_404_url(url)
	File.open(NON_404s, 'a') { |file| file.write("#{url}\n") }
end

def write_404_url(url)
	File.open(TO_REDIRECT, 'a') { |file| file.write("#{url}\n") }
end

def check_urls(urls)

	url_count = urls.length
	cur_count = 0

	urls.each do |url|
		cur_count += 1
		progress = "#{cur_count}/#{url_count}"

		if valid_url?(url)
			if get_response_code(url) == '404'
				puts "#{progress} | 404: #{url}"
				write_404_url(url)
			else
				puts "#{progress} | Not a 404: #{url}"
				write_non_404_url(url)
			end
		else
			puts "#{progress} | Invalid URL: #{url}"
			write_invalid_url(url)
		end
	end
end

urls = parse_url_file(url_source_file)
check_urls(urls)






