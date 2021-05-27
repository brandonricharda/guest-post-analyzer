require 'uri'

class GuestPost < ApplicationRecord
    validates :url, presence: true
    validates_with GuestPostValidator

    belongs_to :batch

    def get_links
        
        results = {}

        article = session.file_by_url(self.url)

        begin
            html = article.export_as_string("html")
            parsable_article = Nokogiri::HTML.fragment(html)
    
            links = parsable_article.css("a")
    
            links.each do |link|
                raw_url = link["href"]
                clean_url = raw_url.split("/url?q=")[1].split("&")[0]
                results[link.text] = clean_url
            end
        rescue Google::Apis::ClientError
            results[self.url] = { "" => "is not a native Google Doc file" }
        end
    
        results

    end

    def compile_data
        result = {}
        result[self.url] = self.get_links
        result
    end

    def session
        GoogleDriveSession.new.session
    end

end