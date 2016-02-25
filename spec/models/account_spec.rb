describe Account do
  it_behaves_like('a model') do
    subject { build :account }
  end
end