class FedenaMailer < ActionMailer::Base
  def email(sender,recipients, subject, message)
    @bcc = recipients
    @recipients = 'info@kunalinfotech.net'
    @from = sender
    @subject = subject
    @sent_on = Time.now
    @body['message'] = message
  end
end
