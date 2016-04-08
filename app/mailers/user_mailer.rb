=begin
This file is part of Network Service Business Game.

    Network Service Business Game is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Network Service Business Game is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Network Service Business Game.  If not, see <http://www.gnu.org/licenses/>
=end

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
