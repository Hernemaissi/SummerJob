class UserMailer < ActionMailer::Base
  default from: "nbgaalto@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirm_email.subject
  #
  def confirm_email(user)
    @user = user
    mail :to => user.email, :subject => "Confirm registration"

  end

  def confirm_group_email(user)
    @user = user
    mail :to => user.email, :subject => "Confirm group membership"

  end

end
