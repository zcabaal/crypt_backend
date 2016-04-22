module API
  class ProfileAPI < Grape::API
    resource :profile do
      get do
        @id = validate_token
        User.find id: @id
      end
      params do
        requires :email, type: String, allow_blank: false, email: true
        requires :given_name, type: String, allow_blank: false
        requires :family_name, type: String, allow_blank: false
      end
      put do
        @id = validate_token
        user = User.find id: @id
        user.email = params.email
        user.given_name = params.given_name
        user.family_name = params.family_name
        user.save!
        user
      end
    end
  end
end