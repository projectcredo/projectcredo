require 'active_support/security_utils'

class StaticPagesController < ApplicationController
  include ActiveSupport::SecurityUtils

  def about
  end

  def how_to
  end

  def lets_encrypt
    if secure_compare params[:id], ENV['8sNcrPS1EVyT3z54lUNVLWxe9y5PdbpasbXXjgd48y8.z3DKE5GPOwED-2OCcZfwwCsOEKy7duPdBUarIV-Hvss
']
      render text: ENV['8sNcrPS1EVyT3z54lUNVLWxe9y5PdbpasbXXjgd48y8.z3DKE5GPOwED-2OCcZfwwCsOEKy7duPdBUarIV-Hvss
']
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
