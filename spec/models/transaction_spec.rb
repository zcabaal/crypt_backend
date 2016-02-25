describe Transaction do
  it_behaves_like('a model') do
    subject { build :transaction }
  end
end