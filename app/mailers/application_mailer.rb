class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAIL_DEFAULT"]
  layout "mailer"
end
