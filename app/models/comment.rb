class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :item
  after_create :send_comment_email

  def send_comment_email
    NotificationMailer.comment_added(self).deliver_now
  end
end
