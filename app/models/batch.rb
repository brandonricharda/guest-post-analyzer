class Batch < ApplicationRecord
    validates :urls, presence: true

    def split_urls
        self.urls.split(/[\r\n]+/)
    end
end
