class NotificationMailer < ApplicationMailer
  default from: "no-reply@mutiny-loot.com"

  def comment_added(comment)
    @news_post = comment.news_post
    @news_post_owner = @news_post.user
    
    mail(to: @news_post_owner.email,
         suject: "A comment has been added to a news post.")
  end
end
