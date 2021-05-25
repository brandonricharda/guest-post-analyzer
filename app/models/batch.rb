class Batch < ApplicationRecord
    validates :urls, presence: true
end
