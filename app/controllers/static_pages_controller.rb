require 'active_support/security_utils'

class StaticPagesController < ApplicationController
  include ActiveSupport::SecurityUtils

  def about
  end

  def how_to
  end

  def lets_encrypt

      render text: ENV['JpdrWI4yOh6Zb1CqEnUr-ZPDaKGpXHEm2T_c-Uvr75g.z3DKE5GPOwED-2OCcZfwwCsOEKy7duPdBUarIV-Hvss']

  end
end
