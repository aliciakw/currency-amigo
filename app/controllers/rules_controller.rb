class RulesController < ApplicationController
  def index
    @rules = Rule.all()
    render :json => @rules
  end
end
