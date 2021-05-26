require 'uri'

class GuestPost < ApplicationRecord
    validates :url, presence: true
    validates_with GuestPostValidator

    def get_links
        article = session.file_by_url(self.url)
        html = article.export_as_string("html")
        URI.extract(html, /https/).map { |raw| raw = raw.split("/url?q=")[1].split("&amp")[0] }
    end

    def session
        GoogleDriveSession.new.session
    end

end