class SubscribeUserToMailingListJob < ApplicationJob
  queue_as :default

  def perform(user)
    gb = Gibbon::Request.new
    gb.lists(ENV["MAILCHIMP_LIST_ID"]).members.create(body: {email_address: user.email, status: "subscribed", merge_fields: {USERNAME: user.username}})
  end
end
