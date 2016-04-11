class NonNegative < Grape::Validations::Base
  def validate_param!(attr_name, params)
    unless params[attr_name].nil?
      if params[attr_name] < 0
        fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: 'cannot be negative'
      end
    end
  end
end