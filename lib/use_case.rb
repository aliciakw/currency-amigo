module Sanctu::UseCase
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  module ClassMethods
    def call(*args)
      ActiveRecord::Base.transaction do
        return new().call(*args)
      end
    end
  end

  def call
    raise NotImplementedError
  end
end