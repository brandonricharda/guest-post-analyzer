require 'uri'

class GuestPost < ApplicationRecord
    validates :url, presence: true
    validates_with GuestPostValidator

    belongs_to :batch
    
    after_create :check_file_format

    def get_links
        
        results = {}

        if self.is_google_doc
    
            article_links.each do |link|
                # Nokogiri occasionally grabs phantom links for which the anchor text is " "
                # The "next" statement below skips those
                next if link.text.length < 3
                raw_url = link["href"]
                clean_url = raw_url.split("/url?q=")[1].split("&")[0]
                results[link.text] = clean_url
            end

        end
    
        results

    end

    def check_spelling
        if self.is_google_doc
            json = SpellChecker.new(text).response.read_body
            JSON.parse(json)["matches"]
        end
    end

    def check_file_format
        begin
            article.export_as_string("html")
        rescue Google::Apis::ClientError
            self.update(:is_google_doc => false)
        end
    end

    def article
        session.file_by_url(self.url)
    end

    def html
        article.export_as_string("html")
    end

    def text
        article.export_as_string("txt")
    end

    def article_links
        parsable_article = Nokogiri::HTML.fragment(html)
        parsable_article.css("a")
    end

    def session
        GoogleDriveSession.new.session
    end

end