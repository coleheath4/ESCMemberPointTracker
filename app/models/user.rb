class User < ApplicationRecord

    scope :sorted, lambda { order("points DESC") }

end
