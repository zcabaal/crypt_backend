describe GlobalPrefs do
  it_behaves_like('a model') do
    subject { build :global_prefs }
  end
  it 'is a singleton model' do
    create :global_prefs
    expect { create :global_prefs }.to raise_error(Mongoid::Errors::Validations)
  end
end