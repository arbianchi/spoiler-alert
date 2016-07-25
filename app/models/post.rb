class Post < ApplicationRecord

  acts_as_votable

  validates_presence_of :content,
                        :time_in_episode

  belongs_to :user
  belongs_to :feed
  has_many :comments

end
