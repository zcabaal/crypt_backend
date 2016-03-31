describe Issue do
  it_behaves_like('a model') do
    subject { build :issue }
  end
end