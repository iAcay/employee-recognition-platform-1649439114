# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'sz.nedzynski@gmail.com'
  layout 'mailer'
end
