class NonNegative < Grape::Validations::Base
  def validate_param!(attr_name, params)
    unless params[attr_name].nil?
      if params[attr_name] < 0
        fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: 'cannot be negative'
      end
    end
  end
end

class Email < Grape::Validations::Base
  def validate_param!(attr_name, params)
    #sec: http://stackoverflow.com/questions/22993545/ruby-email-validation-with-regex
    unless params[attr_name] =~ /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      fail Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)], message: 'is not valid'
    end
  end
end