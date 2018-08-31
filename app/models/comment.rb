class Comment < ApplicationRecord
  acts_as_nested_set

  belongs_to :post, counter_cache: true
  belongs_to :user

  scope :created_at_desc, ->{ order(created_at: :desc) }
end
