class NotificationMailer < ApplicationMailer
  default from: "no-reply@mutiny-loot.com"

  def comment_added(comment)
    @item = comment.item
    
    mail(to: 'euruswagner@gmail.com',
         suject: "A comment has been added to an item.")
  end
end
