describe API::GlobalPrefsAPI do

  it 'returns only the required attribute' do
    create :global_prefs
    get 'api/v1/global_prefs'
    json_response = JSON.parse last_response.body
    expect(json_response).to include("about" => anything, "faq" => anything,
                                     "privacy_policy" => anything, "terms_and_conditions" => anything, "sharing_url" => anything,
                                     "graceful_error_message" => anything, "logo_url" => anything,
                                     "app_tour_messages" => anything, "supported_currencies" => anything)
    expect(json_response).not_to include('exchange_rates' => anything)
  end
end