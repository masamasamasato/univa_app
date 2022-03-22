class ApplicationMailer < ActionMailer::Base
  default from:     "Un!va運営事務局",
          bcc:      "sent@gmail.com",
          reply_to: "reply@gmail.com"
  layout 'mailer'
end