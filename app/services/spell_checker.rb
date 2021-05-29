require 'uri'
require 'net/http'
require 'openssl'

class SpellChecker
    attr_accessor :response
    def initialize(text)
        url = URI("https://grammarbot.p.rapidapi.com/check")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["content-type"] = 'application/x-www-form-urlencoded'
        request["x-rapidapi-key"] = ENV["rapid_api_key"]
        request["x-rapidapi-host"] = 'grammarbot.p.rapidapi.com'

        request.body = "text=#{text}"

        @response = http.request(request)
    end
end