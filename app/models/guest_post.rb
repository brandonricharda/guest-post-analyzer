require 'uri'

class GuestPost < ApplicationRecord
    validates :url, presence: true
    validates_with GuestPostValidator

    belongs_to :batch
    
    after_create :check_file_format

    def get_links
        
        results = {}

        article = session.file_by_url(self.url)

        if self.is_google_doc

            html = article.export_as_string("html")
            parsable_article = Nokogiri::HTML.fragment(html)
    
            links = parsable_article.css("a")
    
            links.each do |link|
                # Nokogiri occasionally grabs phantom links for which the anchor text is " "
                # The "next" statement below skips those
                next if link.text.length < 3
                p link.text
                raw_url = link["href"]
                clean_url = raw_url.split("/url?q=")[1].split("&")[0]
                results[link.text] = clean_url
            end

        end
    
        results

    end

    def check_file_format
        article = session.file_by_url(self.url)
        begin
            article.export_as_string("html")
        rescue Google::Apis::ClientError
            self.update(:is_google_doc => false)
        end
    end

    def session
        GoogleDriveSession.new.session
    end

end