# This mailer handles the email operations for users.
# It includes methods for account activation and password reset emails.
#
# Methods:
# - account_activation(user): Sends an account activation email to the user. The email includes a link to activate the account.
# - password_reset(user): Sends a password reset email to the user. The email includes a link to reset the password.
class UserMailer < ApplicationMailer

  # Send account activation email.
  #
  # Params:
  # - `user` - The user to send the email to.
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  # Send password reset email.
  #
  # Params:
  # - `user` - The user to send the email to.
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
