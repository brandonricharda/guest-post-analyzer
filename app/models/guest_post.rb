class GuestPost < ApplicationRecord
    validates :url, presence: true
    validates_with GuestPostValidator
end