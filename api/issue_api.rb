module API
  class IssueAPI < Grape::API
    resource :issue do
      params do
        optional :type, type: Symbol, default: :support
        requires :message, type: String
      end
      post do
        @id = validate_token
        Issue.create!(user: @id, type: params.type, message: params.message)
        {status: 'success'}
      end
    end
  end
end