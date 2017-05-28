require 'active_support/security_utils'

class StaticPagesController < ApplicationController
  include ActiveSupport::SecurityUtils

  def about
  end

  def how_to
  end

  def lets_encrypt
    if secure_compare params[:id], ENV['LETS_ENCRYPT_CHALLENGE']
      render text: ENV['LETS_ENCRYPT_RESPONSE']
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
