class ApplicationMailer < ActionMailer::Base
  default from: 'accounts@projectcredo.com'
  layout 'mailer'

  def omniauth_registration (user, password, provider)
    @user = user
    @password = password
    @provider = provider
    mail(to: @user.email, subject: 'Registration confirmation')
  end
end
