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
        request["x-rapidapi-key"] = '9d5c7b046cmshf6fdae56ace44d0p1a3fe3jsnfd1188e7ccc5'
        request["x-rapidapi-host"] = 'grammarbot.p.rapidapi.com'

        request.body = "text=#{text}"

        @response = http.request(request)
    end
end