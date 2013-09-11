class UserMailer < ActionMailer::Base
  default from: "aalto.nsbg@gmail.com"

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

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def contract_broken_email(user, breaking_party, broken_party)
    @user = user
    @breaking_party = breaking_party
    @broken_party = broken_party
    mail :to => user.email, :subject => "#{breaking_party.name} has broken their contract with #{broken_party.name}"
  end

end
