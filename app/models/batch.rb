class Batch < ApplicationRecord
    validates :urls, presence: true
    has_many :guest_posts

    after_create :create_guest_posts unless Rails.env.test?

    def split_urls
        self.urls.split(/[\r\n]+/)
    end

    def create_guest_posts
        split_urls.each do |url|
            self.guest_posts.create(:url => url)
        end
    end
    
end
