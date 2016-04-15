module API
  class IssueAPI < Grape::API
    resource :issue do
      params do
        optional :type, type: Symbol, default: :support
        requires :email, type: String
        requires :message, type: String
      end
      post do
        @id = nil
        unless env['HTTP_AUTHORIZATION'].nil?
          @id = validate_token
        end
        Issue.create!(user: @id, type: params.type, message: params.message, email: params.email)
        {status: 'success'}
      end
    end
  end
end