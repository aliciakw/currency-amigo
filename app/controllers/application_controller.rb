class ApplicationController < ActionController::Base
  def heartbeat
    render json: { status: 'ok' }
  end
end
