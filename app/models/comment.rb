class Comment < ApplicationRecord
  belongs_to :post, optional: true
  belongs_to :event, optional: true
end
