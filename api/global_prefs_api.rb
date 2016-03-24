module API
  class GlobalPrefsAPI < Grape::API
    resource :global_prefs do
      get do
        GlobalPrefs.first
      end
    end
  end
end