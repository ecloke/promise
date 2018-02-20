class Achievement < ApplicationRecord
	validates :source, presence: true, uniqueness: { message: "has already been submitted" }
	acts_as_votable
	belongs_to :user
	has_many :comments

end
