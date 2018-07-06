class Post < ApplicationRecord
	acts_as_paranoid
	acts_as_votable

	mount_uploader :image, ImageUploader

	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings
	belongs_to :user

	validates :title, :content, presence: true

	def user
	  User.unscoped { super }
	end

	def self.search(search)
	  if search
	    where("title ilike :q or content ilike :q", q: "%#{search}%")
	  else
	    all.order(:id)
	  end
	end

	def all_tags
		self.tags.map(&:name).join(', ')
	end

	def all_tags=(names)
    self.tags = names.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end
end
