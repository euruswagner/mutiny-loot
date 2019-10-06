class AdminMailer < ApplicationMailer
  default from: "no-reply@mutiny-loot.com"
  layout 'mailer'

  def new_user_waiting_for_approval(email)
    @email = email
    mail(to: 'euruswagner@gmail.com', 
         subject: 'New User Awaiting Admin Approval')
  end
end
