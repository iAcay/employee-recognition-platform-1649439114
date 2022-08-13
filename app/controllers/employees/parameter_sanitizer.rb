module Employees
  class ParameterSanitizer < Devise::ParameterSanitizer
    def initialize(*)
      super
      permit(:sign_up, keys: %i[first_name last_name])
      permit(:account_update, keys: %i[first_name last_name])
    end
  end
end
