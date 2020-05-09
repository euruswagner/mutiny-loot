class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :news_post
  after_create :send_comment_email

  def send_comment_email
    NotificationMailer.comment_added(self).deliver_now
  end

  validates :message, presence: true, length: {minimum: 2}
end
