class PoolContainer < ApplicationRecord
    
    has_many :pools
    belongs_to :user

end
